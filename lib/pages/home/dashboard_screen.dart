import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:lottie/lottie.dart';
import 'package:team_coffee/models/filter_model.dart';
import 'package:team_coffee/pages/home/top_app_bar_widget.dart';
import 'package:team_coffee/pages/home/widgets/animated_event_grid.dart';
import 'package:team_coffee/pages/home/widgets/animated_event_list.dart';
import 'package:team_coffee/pages/home/widgets/filter_modal_widget.dart';

import '../../controllers/event_controller.dart';
import '../../utils/dimensions.dart';
import '../../utils/string_resources.dart';
import '../event/all_events_screen.dart';

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final EventController eventController = Get.find<EventController>();
  String searchQuery = '';

  int currentPage = 0;
  final int pageSize = 10;

  @override
  void initState() {
    super.initState();
    _loadEvents();
  }

  Future<void> _loadEvents() async {
    await eventController.fetchFilteredEvents(
      page: currentPage,
      size: pageSize,
      search: searchQuery,
      filters: EventFilters(
          eventType: eventController.selectedEventType.value,
          status: eventController.selectedEventStatus.value,
          timeFilter: eventController.selectedTimeFilter.value),
    );
  }

  void _onApplyFilters(EventFilters filters) {
    setState(() {
      eventController.selectedEventType.value = filters.eventType;
      eventController.selectedEventStatus.value = filters.status;
      eventController.selectedTimeFilter.value = filters.timeFilter ?? "TODAY";
      currentPage = 0; // Reset to first page when applying new filters
    });
    _loadEvents();
  }

  void _onSearch(String query) {
    setState(() {
      searchQuery = query;
      currentPage = 0; // Reset to first page when searching
    });
    _loadEvents();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          TopAppbar(
            selectedEventType: eventController.selectedEventType.value,
            onEventTypeChanged: (type) {
              setState(() {
                eventController.selectedEventType.value = type;
                currentPage = 0;
              });
              _loadEvents();
            },
            eventController: eventController,
            onSearch: _onSearch,
            onFilterTap: () {
              showModalBottomSheet(
                context: context,
                showDragHandle: true,
                isScrollControlled: true,
                useRootNavigator: true,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(
                      top: Radius.circular(Dimensions.radius30)),
                ),
                builder: (context) =>
                    FilterModal(onApplyFilters: _onApplyFilters),
              );
            },
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.only(
                  left: Dimensions.width20 * 1.3,
                  right: Dimensions.width20,
                  top: 0,
                  bottom: 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    AppStrings.activeEventsTitle.tr,
                    style: TextStyle(
                      fontSize: Dimensions.font20 * 1.1,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  !eventController.pendingEvents.isEmpty
                      ? GestureDetector(
                          onTap: () {
                            // Handle "See more" tap
                            Get.to(EventScreen(
                                eventController: eventController,
                                isPending: true));
                          },
                          child: Row(
                            children: [
                              Text(
                                AppStrings.seeMoreTitle.tr,
                                style: TextStyle(
                                  fontSize: Dimensions.font16,
                                  color: Colors.blue,
                                ),
                              ),
                              const Icon(Icons.arrow_right, color: Colors.blue),
                            ],
                          ),
                        )
                      : SizedBox.shrink(),
                ],
              ),
            ),
          ),
          AnimatedEventGrid(
            selectedEventType: eventController.selectedEventType.value,
            eventController: eventController,
            onEventTypeChanged: (type) {
              setState(() {
                eventController.selectedEventType.value = type;
                currentPage = 0;
              });
              _loadEvents();
            },
          ),
          AnimatedEventList(
            eventController: eventController,
            eventType: eventController.selectedEventType.value,
            onLoadMore: () {
              setState(() {
                currentPage++;
              });
              _loadEvents();
            },
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(Dimensions.height15),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(Dimensions.radius15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Padding(
                  padding: EdgeInsets.all(Dimensions.width15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppStrings.howDoesItWorkTitle.tr,
                        style: TextStyle(
                          fontSize: Dimensions.font20 * 1.2,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: Dimensions.height10 * 0.8),
                      Row(children: [
                        Lottie.asset('assets/image/animation02.json',
                            width: Dimensions.width10 * 13,
                            height: Dimensions.width10 * 13,
                            fit: BoxFit.fill),
                        SizedBox(width: Dimensions.width10 * 0.8),
                        Expanded(
                          child: RichText(
                            text: TextSpan(
                              text: AppStrings.howDoesItWorkDesc.tr,
                              style: TextStyle(
                                fontSize: Dimensions.font20 * 0.9,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                              children: <TextSpan>[
                                TextSpan(
                                  text: AppStrings.howDoesItWorkMoto.tr,
                                  style: TextStyle(
                                      fontWeight: FontWeight.normal,
                                      fontSize: Dimensions.font20 * 0.80),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ]),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:lottie/lottie.dart';
import 'package:team_coffee/models/filter_model.dart';
import 'package:team_coffee/pages/home/top_app_bar_widget.dart';
import 'package:team_coffee/pages/home/widgets/animated_completed_event_list.dart';
import 'package:team_coffee/pages/home/widgets/animated_pending_event_grid.dart';
import 'package:team_coffee/pages/home/widgets/animated_in_progress_event_list.dart';
import 'package:team_coffee/pages/home/widgets/filter_modal_widget.dart';
import 'package:team_coffee/pages/home/widgets/invite_friends_widget.dart';
import '../../controllers/event_controller.dart';
import '../../controllers/group_controller.dart';
import '../../utils/dimensions.dart';
import '../../utils/string_resources.dart';

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final EventController eventController = Get.find<EventController>();
  final GroupController groupController = Get.find<GroupController>();
  int currentPage = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ever(groupController.currentGroupId, (_) async => await _loadEvents());
      Future.microtask(() async {
        await _initializeEventController();
        if (mounted) setState(() {});
      });
    });
  }

  Future<void> _initializeEventController() async {
    // Set initial values
    eventController.selectedEventType.value = 'ALL';
    eventController.selectedEventStatus.value = ['PENDING'];
    eventController.selectedTimeFilter.value = 'THIS_WEEK';

    // Load events
    await _loadEvents();
  }

  Future<void> _loadEvents() async {
    await eventController.fetchFilteredEvents(
      page: currentPage,
      size: eventController.pageSize,
      search: '',
      filters: EventFilters(
          eventType: eventController.selectedEventType.value,
          status: eventController.selectedEventStatus.value,
          timeFilter: eventController.selectedTimeFilter.value),
    );
  }

  Future<void> _loadPendingEvents() async {
    await eventController.fetchPendingEvents(
      page: currentPage,
      size: eventController.pageSize,
      search: '',
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
    });

    _loadEvents();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<GroupController>(
        builder: (_) => CustomScrollView(
          slivers: [
            TopAppbar(
              selectedEventType: eventController.selectedEventType.value,
              onEventTypeChanged: (type) async {
                setState(() {
                  eventController.selectedEventType.value = type;
                  currentPage = 0;
                });
                await _loadEvents();
              },
              eventController: eventController,
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
            GetX<EventController>(
              init: eventController,
              initState: (_) => _loadEvents(),
              builder: (_) => AnimatedEventGrid(
                selectedEventType: eventController.selectedEventType.value,
                eventController: eventController,
                onEventTypeChanged: (type) {
                  eventController.selectedEventType.value = type;
                  _loadPendingEvents();
                },
              ),
            ),
            SliverToBoxAdapter(
              child: CustomCard(),
            ),
            Obx(() =>
                eventController.selectedEventStatus.contains("IN_PROGRESS")
                    ? AnimatedEventList(
                        eventController: eventController,
                        eventType: eventController.selectedEventType.value,
                      )
                    : SliverToBoxAdapter(child: SizedBox.shrink())),
            Obx(() => eventController.selectedEventStatus.contains("COMPLETED")
                ? AnimatedCompletedEventList(
                    eventController: eventController,
                    eventType: eventController.selectedEventType.value,
                  )
                : SliverToBoxAdapter(child: SizedBox.shrink())),
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: Dimensions.height15,
                    vertical: Dimensions.height15),
                child: Container(
                  padding: EdgeInsets.all(Dimensions.height10),
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
                    padding: EdgeInsets.symmetric(
                      horizontal: Dimensions.width15,
                    ),
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
                              width: Dimensions.width10 * 10,
                              height: Dimensions.width10 * 10,
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
      ),
    );
  }
}

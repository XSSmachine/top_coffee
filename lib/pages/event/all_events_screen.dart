import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:team_coffee/routes/route_helper.dart';

import '../../controllers/event_controller.dart';
import '../../models/event_model.dart';
import '../../utils/colors.dart';
import '../../utils/dimensions.dart';
import '../../utils/string_resources.dart';
import '../../widgets/create_event_widget.dart';

class EventScreen extends StatefulWidget {
  final EventController eventController;
  final String eventStatus;

  EventScreen({
    Key? key,
    required this.eventController,
    required this.eventStatus,
  }) : super(key: key);

  @override
  State<EventScreen> createState() => _EventScreenState();
}

class _EventScreenState extends State<EventScreen> {
  String _getImagePath(String eventType) {
    switch (eventType) {
      case "FOOD":
        return 'assets/image/burek.png';
      case "COFFEE":
        return 'assets/image/turska.png';
      case "BEVERAGE":
        return 'assets/image/pice.png';
      default:
        return 'assets/image/placeholder.jpg'; // Fallback image
    }
  }

  int currentPage = 0;
  bool isLoading = false;
  bool hasMore = true;
  final int pageSize = 10;
  final ScrollController _scrollController = ScrollController();

  void _loadMore() {
    if (!_scrollController.hasClients) return;
    if (_scrollController.position.maxScrollExtent ==
            _scrollController.offset &&
        !isLoading &&
        hasMore) {
      _fetchOrders();
    }
  }

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_loadMore);

    _resetAndFetch();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _fetchOrders() async {
    if (isLoading) return;
    setState(() {
      isLoading = true;
    });
    try {
      final newOrders = await widget.eventController.getAllFilteredEvents(
        page: currentPage,
        size: pageSize + 1,
        search: '',
        status: widget.eventStatus,
        type: 'ALL',
      );
      setState(() {
        currentPage++;
        isLoading = false;
        hasMore = newOrders.length > pageSize;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Error fetching orders: $e');
    }
  }

  Future<void> refresh() async {
    _resetAndFetch();
  }

  void _resetAndFetch() {
    setState(() {
      currentPage = 0;
      hasMore = true;
    });
    widget.eventController.clearAllEvents();
    _fetchOrders();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppStrings.eventsTitle.tr),
      ),
      body: NotificationListener<ScrollNotification>(
        onNotification: (ScrollNotification scrollInfo) {
          if (scrollInfo is ScrollEndNotification) {
            _loadMore();
          }
          return true;
        },
        child: GetBuilder<EventController>(
          builder: (eventController) {
            final events = eventController.allEventList;
            return RefreshIndicator(
              onRefresh: refresh,
              child: NotificationListener<ScrollNotification>(
                onNotification: (ScrollNotification scrollInfo) {
                  if (scrollInfo is ScrollEndNotification) {
                    _loadMore();
                  }
                  return true;
                },
                child: events.isEmpty
                    ? Center(
                        child: SizedBox(
                          height: Dimensions.height45 * 3.7,
                          child: Column(
                            children: [
                              SizedBox(height: Dimensions.height10),
                              const Center(child: CreateEventWidget())
                            ],
                          ),
                        ),
                      )
                    : ListView.builder(
                        controller: _scrollController,
                        padding: EdgeInsets.only(
                          top: Dimensions.height10,
                          left: Dimensions.width15,
                          right: Dimensions.width15,
                        ),
                        itemCount: events.length + 1,
                        itemBuilder: (context, index) {
                          if (index < events.length) {
                            EventModel event = events[index];
                            return GestureDetector(
                              onTap: () {
                                Get.toNamed(RouteHelper.getEventDetail(
                                  event.eventId ?? "",
                                  widget.eventStatus,
                                  null,
                                ));
                              },
                              child: Container(
                                margin: EdgeInsets.only(
                                    bottom: Dimensions.height10),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(
                                      Dimensions.radius15),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.5),
                                      spreadRadius: 2,
                                      blurRadius: Dimensions.radius15 / 3,
                                      offset: const Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: Row(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(
                                            Dimensions.radius15),
                                        bottomLeft: Radius.circular(
                                            Dimensions.radius15),
                                      ),
                                      child: Image.asset(
                                        _getImagePath(
                                            event.eventType ?? "FOOD"),
                                        height: Dimensions.height20 * 5,
                                        width: Dimensions.height20 * 5,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    Expanded(
                                      child: Padding(
                                        padding: EdgeInsets.all(
                                            Dimensions.height10 * 0.4),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              event.title ?? 'No Title',
                                              style: TextStyle(
                                                fontSize: Dimensions.font16,
                                                fontWeight: FontWeight.bold,
                                              ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            Text(
                                              '${AppStrings.authorTitle.tr} ${event.userProfileFirstName} ${event.userProfileLastName}',
                                              style: TextStyle(
                                                color: Colors.grey,
                                                fontSize:
                                                    Dimensions.font20 * 0.6,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            Text(
                                              event.description ??
                                                  "No description",
                                              style: TextStyle(
                                                color:
                                                    AppColors.mainBlueDarkColor,
                                                fontWeight: FontWeight.bold,
                                                fontSize:
                                                    Dimensions.font20 * 0.6,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          } else {
                            return Padding(
                              padding: EdgeInsets.symmetric(vertical: 32),
                              child: Center(
                                child: isLoading
                                    ? CircularProgressIndicator()
                                    : hasMore
                                        ? Text(AppStrings.loadMore.tr)
                                        : Text(AppStrings.noMore.tr),
                              ),
                            );
                          }
                        },
                      ),
              ),
            );
          },
        ),
      ),
    );
  }
}

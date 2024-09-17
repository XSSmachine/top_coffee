import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:intl/intl.dart';
import 'package:stomp_dart_client/stomp_dart_client.dart' as client;
import 'package:stomp_dart_client/stomp_dart_client.dart';
import 'package:team_coffee/pages/detail/event_details_screen.dart';
import 'package:team_coffee/pages/home/widgets/skeleton_item.dart';
import '../../../base/show_custom_snackbar.dart';
import '../../../controllers/auth_controller.dart';
import '../../../controllers/event_controller.dart';
import '../../../models/event_model.dart';
import '../../../models/filter_model.dart';
import '../../../routes/route_helper.dart';
import '../../../utils/app_constants.dart';
import '../../../utils/colors.dart';
import '../../../utils/dimensions.dart';
import '../../../widgets/timer/count_timer_widget.dart';
import '../../event/all_events_screen.dart';

class AnimatedCompletedEventList extends StatefulWidget {
  final EventController eventController;
  final String eventType;

  const AnimatedCompletedEventList({
    Key? key,
    required this.eventController,
    required this.eventType,
  }) : super(key: key);

  @override
  _AnimatedEventListState createState() => _AnimatedEventListState();
}

class _AnimatedEventListState extends State<AnimatedCompletedEventList>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  List<EventModel>? _previousEvents;
  bool _hasAnimated = false;

  ScrollController _scrollController = ScrollController();

  final String webSocketUrl = AppConstants.BASE_SOCKET_URL;
  late client.StompClient _client;
  List<dynamic> messages = List.empty();

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _setupWebSocket();
    _refreshEvents();
    _initializeEvents();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _setupAnimations() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _fadeAnimation =
        Tween<double>(begin: 0.0, end: 1.0).animate(_animationController);
  }

  void _setupWebSocket() {
    _client = client.StompClient(
        config: StompConfig(url: webSocketUrl, onConnect: onConnectCallback));
    _client.activate();
  }

  void _initializeEvents() {
    EventFilters filters = EventFilters(
      eventType: widget.eventController.selectedEventType.value,
      status: widget.eventController.selectedEventStatus.value,
      timeFilter: widget.eventController.selectedTimeFilter.value,
    );

    widget.eventController.fetchFilteredEvents(
      page: 0,
      size: widget.eventController.pageSize,
      search: '',
      filters: filters,
    );
  }

  Future<void> _refreshEvents() async {
    await widget.eventController.fetchFilteredEvents(
      page: 0,
      size: widget.eventController.pageSize,
      search: '',
      filters: EventFilters(
        eventType: widget.eventController.selectedEventType.value,
        status: widget.eventController.selectedEventStatus.value,
        timeFilter: widget.eventController.selectedTimeFilter.value,
      ),
    );
  }

  void onConnectCallback(StompFrame connectFrame) async {
    String? groupId = await Get.find<AuthController>().getGroupId();
    print("Group ID: $groupId");
    _client.subscribe(
      destination: '/topic/groups/$groupId',
      headers: {},
      callback: (frame) {
        print(frame.body);
        Map<String, dynamic> data = jsonDecode(frame.body!);
        showCustomEventSnackBar(
          name: data["firstName"],
          surname: data["lastName"],
          eventTitle: data["title"],
          imageUrl: data["profilePhoto"],
        );
        widget.eventController.onWebSocketMessage(
          widget.eventType,
          0,
          widget.eventController.pageSize,
          '',
          EventFilters(
            eventType: widget.eventType,
            status: ['COMPLETED'],
            timeFilter: '',
          ),
        );
      },
    );
  }

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

  bool _shouldAnimate(List<EventModel> newEvents) {
    if (_previousEvents == null || !listEquals(_previousEvents, newEvents)) {
      _previousEvents = List.from(newEvents);
      _hasAnimated = false;
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return SliverToBoxAdapter(
      child: RefreshIndicator(
        onRefresh: _refreshEvents,
        child: FutureBuilder<void>(
          future: _refreshEvents(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: Dimensions.width20 * 1.3),
                child: StaggeredGridView.countBuilder(
                  padding: EdgeInsets.only(top: Dimensions.height10),
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  itemCount: 2,
                  itemBuilder: (BuildContext context, int index) {
                    return AnimationConfiguration.staggeredGrid(
                      position: index,
                      duration: const Duration(milliseconds: 375),
                      columnCount: 2,
                      child: SlideAnimation(
                        verticalOffset: 50.0,
                        child: FadeInAnimation(
                          child: SkeletonEventItem(),
                        ),
                      ),
                    );
                  },
                  staggeredTileBuilder: (int index) =>
                      const StaggeredTile.fit(1),
                ),
              );
            }
            return StreamBuilder<List<EventModel>>(
              stream: widget.eventController.completedEventsStream,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }
                return Obx(() {
                  final events = widget.eventController.completedEvents;
                  if (events.isEmpty) {
                    return SizedBox.shrink();
                  }
                  if (_shouldAnimate(events) && !_hasAnimated) {
                    _animationController.forward(from: 0.0);
                    _hasAnimated = true;
                  }
                  return _buildEventList(events);
                });
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildEventList(List<EventModel> events) {
    return Visibility(
      visible: events.isNotEmpty,
      child: Padding(
        padding: EdgeInsets.only(left: Dimensions.width15 / 3),
        child: SizedBox(
          height: events.isEmpty ? 0 : Dimensions.height45 * 6.2,
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: Dimensions.height45 * 6.2,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildHeader(),
                _buildEventListView(events),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: Dimensions.width20,
        vertical: Dimensions.height10 * 0.5,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Completed events",
            style: TextStyle(
              fontSize: Dimensions.font20 * 1.1,
              fontWeight: FontWeight.bold,
            ),
          ),
          GestureDetector(
            onTap: () {
              Get.to(EventScreen(
                eventController: widget.eventController,
                eventStatus: "COMPLETED",
              ));
            },
            child: Row(
              children: [
                Text(
                  "See more",
                  style: TextStyle(
                    fontSize: Dimensions.font16,
                    color: Colors.blue,
                  ),
                ),
                const Icon(Icons.arrow_right, color: Colors.blue),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEventListView(List<EventModel> events) {
    return SizedBox(
      height: Dimensions.height45 * 5.1,
      child: ListView.builder(
        controller: _scrollController,
        padding: EdgeInsets.all(Dimensions.height10),
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: events.length,
        itemBuilder: (context, index) => _buildEventItem(events[index]),
      ),
    );
  }

  Widget _buildEventItem(EventModel event) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: GestureDetector(
        onTap: () {
          Get.to(
            () => EventDetailsScreen(
              eventId: event.eventId ?? "",
              page: "completed",
            ),
            transition: Transition.fade,
          );
        },
        child: Container(
          width: Dimensions.width20 * 9,
          height: Dimensions.height30 * 5,
          margin: EdgeInsets.symmetric(
            horizontal: Dimensions.width10,
            vertical: Dimensions.height10 / 2,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(Dimensions.radius15),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                spreadRadius: 1,
                blurRadius: 10,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  Image.asset(
                    _getImagePath(event.eventType ?? "FOOD"),
                    height: Dimensions.height20 * 7,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: Dimensions.width10,
                        vertical: Dimensions.height10 * 0.2,
                      ),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: [
                            Colors.black.withOpacity(0.8),
                            Colors.transparent,
                          ],
                        ),
                      ),
                      child: Text(
                        event.title ?? 'No Title',
                        style: TextStyle(
                          fontSize: Dimensions.font16 * 1.2,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ],
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(Dimensions.height10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.person,
                            size: Dimensions.iconSize16,
                            color: Colors.grey,
                          ),
                          Flexible(
                            child: Text(
                              '${event.userProfileFirstName} ${event.userProfileLastName}',
                              style: TextStyle(
                                color: Colors.grey[700],
                                fontSize: Dimensions.font16 * 0.8,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.calendar_today,
                                size: Dimensions.iconSize16,
                                color: Colors.grey,
                              ),
                              SizedBox(width: Dimensions.width10 * 0.5),
                              Text(
                                _formatDate(event.pendingUntil),
                                style: TextStyle(
                                  color: Colors.grey[700],
                                  fontSize: Dimensions.font16 * 0.6,
                                ),
                              ),
                            ],
                          ),
                          Icon(
                            Icons.arrow_forward_ios,
                            color: Colors.grey,
                            size: Dimensions.height15,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDate(String? dateString) {
    if (dateString == null) return 'No date';
    final date = DateTime.parse(dateString);
    return DateFormat('MMM d, y').format(date);
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}

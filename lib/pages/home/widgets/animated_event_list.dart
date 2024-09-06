import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
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
import '../../../utils/dimensions.dart';
import '../../../widgets/timer/count_timer_widget.dart';
import '../../event/all_events_screen.dart';

class AnimatedEventList extends StatefulWidget {
  final EventController eventController;
  final String eventType;
  final VoidCallback onLoadMore;

  const AnimatedEventList({
    Key? key,
    required this.eventController,
    required this.eventType,
    required this.onLoadMore,
  }) : super(key: key);

  @override
  _AnimatedEventListState createState() => _AnimatedEventListState();
}

class _AnimatedEventListState extends State<AnimatedEventList>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
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
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      widget.onLoadMore();
    }
  }

  void _setupAnimations() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _fadeAnimation =
        Tween<double>(begin: 0.0, end: 1.0).animate(_animationController);
    _slideAnimation =
        Tween<Offset>(begin: const Offset(0.0, -0.5), end: Offset.zero)
            .animate(_animationController);
  }

  void _setupWebSocket() {
    _client = client.StompClient(
        config: StompConfig(url: webSocketUrl, onConnect: onConnectCallback));
    _client.activate();
  }

  Future<void> _refreshEvents() async {
    await widget.eventController.fetchInProgressEvents(widget.eventType);
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
        widget.eventController.eventsStream(
            widget.eventType,
            0,
            11,
            '',
            EventFilters(
                eventType: widget.eventType,
                status: ['IN_PROGRESS'],
                timeFilter: ''));
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
              stream: widget.eventController.eventsStream(
                'IN_PROGRESS',
                0,
                11,
                '',
                EventFilters(
                    eventType: widget.eventController.selectedEventType.value,
                    status: widget.eventController.selectedEventStatus.value,
                    timeFilter:
                        widget.eventController.selectedTimeFilter.value),
              ),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }
                return Obx(() {
                  final events = widget.eventController.inProgressEvents;
                  if (events.isEmpty) {
                    return SizedBox(height: Dimensions.height30);
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
          height: events.isEmpty ? 0 : Dimensions.height45 * 5,
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: Dimensions.height45 * 5,
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
            "Events in progress",
            style: TextStyle(
              fontSize: Dimensions.font20 * 1.1,
              fontWeight: FontWeight.bold,
            ),
          ),
          GestureDetector(
            onTap: () {
              Get.to(EventScreen(
                eventController: widget.eventController,
                isPending: false,
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
      height: Dimensions.height45 * 4,
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
      child: SlideTransition(
          position: _slideAnimation,
          child: Center(
            child: GestureDetector(
              onTap: () {
                // Get.toNamed(RouteHelper.getEventDetail(
                //     event.eventId ?? "", "in_progress", null));
                Get.to(
                    () => EventDetailsScreen(
                        eventId: event.eventId ?? "", page: "in_progress"),
                    transition: Transition.fade);
              },
              child: Container(
                width: Dimensions.width20 * 8,
                height: Dimensions.height30 * 5.6,
                margin: EdgeInsets.symmetric(horizontal: Dimensions.width10),
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
                clipBehavior: Clip.antiAlias,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(Dimensions.radius15),
                            topRight: Radius.circular(Dimensions.radius15),
                          ),
                          child: Hero(
                            tag: UniqueKey(),
                            child: Image.asset(
                              _getImagePath(event.eventType ?? "FOOD"),
                              height: Dimensions.height20 * 5,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Positioned(
                          top: Dimensions.height10 * 0.8,
                          left: Dimensions.width10 * 0.8,
                          child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: Dimensions.width10 * 0.8,
                                  vertical: Dimensions.height10 * 0.4),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(
                                    Dimensions.radius20 * 0.4),
                              ),
                              child: CountTimer(
                                  startTimeISO: event.pendingUntil!)),
                        ),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          left: Dimensions.height10,
                          right: Dimensions.height10,
                          top: Dimensions.height10 * 0.3,
                          bottom: Dimensions.height10 * 0.5),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            event.title ?? 'No Title',
                            style: TextStyle(
                              fontSize: Dimensions.font16,
                              fontWeight: FontWeight.bold,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: Dimensions.height10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(
                                child: Text(
                                  'By ${event.userProfileFirstName} ${event.userProfileLastName}',
                                  style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: Dimensions.font16 * 0.6),
                                  overflow: TextOverflow.ellipsis,
                                ),
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
                  ],
                ),
              ),
            ),
          )),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}

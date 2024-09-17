import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:stomp_dart_client/stomp_dart_client.dart' as client;
import 'package:stomp_dart_client/stomp_dart_client.dart';
import 'package:team_coffee/controllers/event_controller.dart';
import 'package:team_coffee/pages/home/widgets/skeleton_item.dart';
import '../../../base/show_custom_snackbar.dart';
import '../../../controllers/user_controller.dart';
import '../../../models/event_model.dart';
import '../../../models/filter_model.dart';
import '../../../routes/route_helper.dart';
import '../../../utils/app_constants.dart';
import '../../../utils/dimensions.dart';
import '../../../utils/string_resources.dart';
import '../../../widgets/create_event_widget.dart';
import '../../../widgets/timer/countdown_timer_widget.dart';
import '../../event/all_events_screen.dart';

class AnimatedEventGrid extends StatefulWidget {
  final String selectedEventType;
  final EventController eventController;
  final Function(String) onEventTypeChanged;

  const AnimatedEventGrid(
      {Key? key,
      required this.selectedEventType,
      required this.eventController,
      required this.onEventTypeChanged})
      : super(key: key);

  @override
  _AnimatedEventGridState createState() => _AnimatedEventGridState();
}

class _AnimatedEventGridState extends State<AnimatedEventGrid>
    with AutomaticKeepAliveClientMixin {
  late client.StompClient _client;
  final String webSocketUrl = AppConstants.BASE_SOCKET_URL;
  void _setupWebSocket() {
    _client = client.StompClient(
        config: StompConfig(url: webSocketUrl, onConnect: onConnectCallback));
    _client.activate();
  }

  void onConnectCallback(StompFrame connectFrame) async {
    String? userProfileId = await Get.find<UserController>().getProfileId();
    print("Group ID: $userProfileId");
    _client.subscribe(
      destination: '/topic/users/$userProfileId',
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
          'IN_PROGRESS',
          0,
          widget.eventController.pageSize,
          '',
          EventFilters(
            eventType: widget.eventController.selectedEventType.value,
            status: ['IN_PROGRESS'],
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

  @override
  void initState() {
    super.initState();
    _setupWebSocket();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return SliverToBoxAdapter(
      child: Column(
        children: [
          // Title Row
          Padding(
            padding: EdgeInsets.only(
                left: Dimensions.width20 * 1.3,
                right: Dimensions.width20,
                top: 0),
            child: Obx(() => widget.eventController.pendingEvents.isNotEmpty
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        AppStrings.activeEventsTitle.tr,
                        style: TextStyle(
                          fontSize: Dimensions.font20 * 1.1,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Get.to(EventScreen(
                              eventController: widget.eventController,
                              eventStatus: "PENDING"));
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
                    ],
                  )
                : SizedBox.shrink()),
          ),
          // Existing RefreshIndicator and StreamBuilder
          RefreshIndicator(
            onRefresh: _refreshEvents,
            child: StreamBuilder<List<EventModel>>(
              stream: widget.eventController.pendingEventsStream,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting &&
                    !snapshot.hasData) {
                  return _buildLoadingWidget();
                } else if (snapshot.hasError) {
                  return _buildErrorWidget(snapshot.error.toString());
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return _buildEmptyWidget();
                } else {
                  return Obx(() => _buildEventList(snapshot.data!));
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingWidget() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: Dimensions.width20 * 1.3),
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
        staggeredTileBuilder: (int index) => const StaggeredTile.fit(1),
      ),
    );
  }

  Widget _buildErrorWidget(String error) {
    return Center(child: Text('${AppStrings.errorMsg}: $error'));
  }

  Widget _buildEmptyWidget() {
    return Center(
      child: SizedBox(
        height: Dimensions.height45 * 5.8,
        child: Column(
          children: [
            Text("${AppStrings.emptyPendingEventText.tr}..."),
            SizedBox(height: Dimensions.height15),
            Center(
              child: Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: Dimensions.width10 * 0.4),
                child: CreateEventWidget(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEventList(List<EventModel> events) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: Dimensions.width20 * 1.3),
      child: AnimationLimiter(
        child: StaggeredGridView.countBuilder(
          padding: EdgeInsets.only(top: Dimensions.height10),
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          itemCount: events.length,
          itemBuilder: (BuildContext context, int index) {
            EventModel event = events[index];
            return AnimationConfiguration.staggeredGrid(
              position: index,
              duration: const Duration(milliseconds: 375),
              columnCount: 2,
              child: SlideAnimation(
                verticalOffset: 50.0,
                child: FadeInAnimation(
                  child: GestureDetector(
                    onTap: () {
                      Get.toNamed(RouteHelper.getEventDetail(
                          event.eventId ?? "", "pending", null));
                    },
                    child: _buildEventItem(event),
                  ),
                ),
              ),
            );
          },
          staggeredTileBuilder: (int index) => StaggeredTile.fit(1),
          mainAxisSpacing: Dimensions.height10 * 1.5, // Increased spacing
          crossAxisSpacing: Dimensions.width20,
        ),
      ),
    );
  }

  Widget _buildEventItem(EventModel event) {
    return Container(
      height: Dimensions.height20 * 12, // Increased height
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
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Background Image
          ClipRRect(
            borderRadius: BorderRadius.circular(Dimensions.radius15),
            child: Image.asset(
              _getImagePath(event.eventType ?? "FOOD"),
              fit: BoxFit.cover,
            ),
          ),
          // Gradient Overlay
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(Dimensions.radius15),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withOpacity(0.7),
                  ],
                  stops: const [0.5, 1.0],
                ),
              ),
            ),
          ),
          // Content
          Positioned(
            left: Dimensions.width10,
            right: Dimensions.width10,
            bottom: Dimensions.height10,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  event.title ?? 'No Title',
                  style: TextStyle(
                    fontSize: Dimensions.font16 * 1.2,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: Dimensions.height10 * 0.5),
                Text(
                  event.description ?? "No description",
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: Dimensions.font20 * 0.7,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: Dimensions.height10 * 0.5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        '${AppStrings.madeByText.tr} ${event.userProfileFirstName} ${event.userProfileLastName}',
                        style: TextStyle(
                          color: Colors.white60,
                          fontSize: Dimensions.font20 * 0.6,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Icon(
                      Icons.restaurant_menu,
                      color: Colors.white,
                      size: Dimensions.iconSize16 * 1.2,
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Timer
          Positioned(
            top: Dimensions.height10 * 0.8,
            left: Dimensions.height10 * 0.8,
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: Dimensions.width10 * 0.8,
                vertical: Dimensions.height10 * 0.4,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(Dimensions.radius20 * 0.4),
              ),
              child: CountdownTimer(
                initialMinutes: widget.eventController
                    .calculateRemainingTimeInRoundedMinutes(
                        event.pendingUntil!),
                onTimerExpired: () {
                  widget.onEventTypeChanged(
                      widget.eventController.selectedEventType.value);
                },
              ),
            ),
          ),
        ],
      ),
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
            timeFilter: widget.eventController.selectedTimeFilter.value));
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}

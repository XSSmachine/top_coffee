import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:team_coffee/controllers/event_controller.dart';
import 'package:team_coffee/pages/home/widgets/skeleton_item.dart';

import '../../../models/event_model.dart';
import '../../../models/filter_model.dart';
import '../../../routes/route_helper.dart';
import '../../../utils/colors.dart';
import '../../../utils/dimensions.dart';
import '../../../widgets/create_event_widget.dart';
import '../../../widgets/timer/countdown_timer_widget.dart';

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
  }

  @override
  void dispose() {
    super.dispose();
  }

  // @override
  // Widget build(BuildContext context) {
  //   return SliverToBoxAdapter(
  //     child: StreamBuilder<List<EventModel>>(
  //       stream: widget.eventController
  //           .pendingEventsStream(widget.selectedEventType)
  //           .asBroadcastStream(),
  //       builder: (context, snapshot) {
  //         if (snapshot.connectionState == ConnectionState.waiting) {
  //           if (!_isLongWaiting) {
  //             _startTimer();
  //           }
  //           return Padding(
  //             padding:
  //                 EdgeInsets.symmetric(horizontal: Dimensions.width20 * 1.3),
  //             child: StaggeredGridView.countBuilder(
  //               padding: EdgeInsets.only(top: Dimensions.height10),
  //               shrinkWrap: true,
  //               physics: const NeverScrollableScrollPhysics(),
  //               crossAxisCount: 2,
  //               itemCount: 2,
  //               itemBuilder: (BuildContext context, int index) {
  //                 return AnimationConfiguration.staggeredGrid(
  //                   position: index,
  //                   duration: const Duration(milliseconds: 375),
  //                   columnCount: 2,
  //                   child: SlideAnimation(
  //                     verticalOffset: 50.0,
  //                     child: FadeInAnimation(
  //                       child: SkeletonEventItem(),
  //                     ),
  //                   ),
  //                 );
  //               },
  //               staggeredTileBuilder: (int index) => const StaggeredTile.fit(1),
  //             ),
  //           );
  //         } else if (snapshot.hasError) {
  //           return Center(child: Text('Error: ${snapshot.error}'));
  //         } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
  //           return Center(
  //               child: SizedBox(
  //             height: Dimensions.height45 * 3.7,
  //             child: Column(
  //               children: [
  //                 SizedBox(height: Dimensions.height10),
  //                 const Text("Hmm looks empty here..."),
  //                 SizedBox(height: Dimensions.height15),
  //                 Center(
  //                     child: Padding(
  //                   padding: EdgeInsets.symmetric(
  //                       horizontal: Dimensions.width10 * 0.8),
  //                   child: CreateEventWidget(),
  //                 ))
  //               ],
  //             ),
  //           ));
  //         } else {
  //           _timer?.cancel();
  //           return Padding(
  //             padding:
  //                 EdgeInsets.symmetric(horizontal: Dimensions.width20 * 1.3),
  //             child: AnimationLimiter(
  //               child: StaggeredGridView.countBuilder(
  //                 padding: EdgeInsets.only(top: Dimensions.height10),
  //                 shrinkWrap: true,
  //                 physics: const NeverScrollableScrollPhysics(),
  //                 crossAxisCount: 2,
  //                 itemCount: snapshot.data!.length,
  //                 itemBuilder: (BuildContext context, int index) {
  //                   EventModel event = snapshot.data![index];
  //                   return AnimationConfiguration.staggeredGrid(
  //                     position: index,
  //                     duration: const Duration(milliseconds: 375),
  //                     columnCount: 2,
  //                     child: SlideAnimation(
  //                       verticalOffset: 50.0,
  //                       child: FadeInAnimation(
  //                         child: GestureDetector(
  //                           onTap: () {
  //                             Get.toNamed(RouteHelper.getEventDetail(
  //                                 event.eventId ?? "", "pending", null));
  //                           },
  //                           child:
  //                         ),
  //                       ),
  //                     ),
  //                   );
  //                 },
  //                 staggeredTileBuilder: (int index) => StaggeredTile.fit(1),
  //                 mainAxisSpacing: Dimensions.height10,
  //                 crossAxisSpacing: Dimensions.width20,
  //               ),
  //             ),
  //           );
  //         }
  //       },
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return SliverToBoxAdapter(
      child: RefreshIndicator(
        onRefresh: _refreshEvents,
        child: StreamBuilder<List<EventModel>>(
          stream: widget.eventController.eventsStream(
              widget.eventController.selectedEventStatus.first,
              0,
              11,
              '',
              EventFilters(
                  eventType: widget.eventController.selectedEventType.value,
                  status: widget.eventController.selectedEventStatus.value,
                  timeFilter: widget.eventController.selectedTimeFilter.value)),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting &&
                !snapshot.hasData) {
              return _buildLoadingWidget();
            } else if (snapshot.hasError) {
              return _buildErrorWidget(snapshot.error.toString());
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return _buildEmptyWidget();
            } else {
              return _buildEventList(snapshot.data!);
            }
          },
        ),
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
    return Center(child: Text('Error: $error'));
  }

  Widget _buildEmptyWidget() {
    return Center(
      child: SizedBox(
        height: Dimensions.height45 * 3.7,
        child: Column(
          children: [
            SizedBox(height: Dimensions.height10),
            const Text("Hmm looks empty here..."),
            SizedBox(height: Dimensions.height15),
            Center(
              child: Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: Dimensions.width10 * 0.8),
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
          mainAxisSpacing: Dimensions.height10,
          crossAxisSpacing: Dimensions.width20,
        ),
      ),
    );
  }

  Widget _buildEventItem(EventModel event) {
    return Container(
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
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(Dimensions.radius15),
                  topRight: Radius.circular(Dimensions.radius15),
                ),
                child: Image.asset(
                  _getImagePath(event.eventType ?? "FOOD"),
                  height: Dimensions.height20 * 5,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                top: Dimensions.height10 * 0.8,
                left: Dimensions.height10 * 0.8,
                child: Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: Dimensions.width10 * 0.8,
                        vertical: Dimensions.height10 * 0.4),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                          BorderRadius.circular(Dimensions.radius20 * 0.4),
                    ),
                    child: CountdownTimer(
                        initialMinutes: widget.eventController
                            .calculateRemainingTimeInRoundedMinutes(
                                event.pendingUntil!),
                        onTimerExpired: () {
                          Future.delayed(Duration(seconds: 3), () {
                            widget.onEventTypeChanged;
                          });
                        })),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.all(Dimensions.height10 * 0.4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
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
                Row(
                  children: [
                    SizedBox(width: Dimensions.width10 * 0.4),
                    Expanded(
                      child: Text(
                        event.description ?? "No description",
                        style: TextStyle(
                          color: AppColors.mainBlueDarkColor,
                          fontWeight: FontWeight.bold,
                          fontSize: Dimensions.font20 * 0.6,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        'By ${event.userProfileFirstName} ${event.userProfileLastName}',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: Dimensions.font20 * 0.6,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.grey,
                      size: Dimensions.iconSize16 * 0.8,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _refreshEvents() async {
    await widget.eventController.fetchFilteredEvents(
        page: 0,
        size: 11,
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

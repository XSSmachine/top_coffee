import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import '../../../controllers/event_controller.dart';
import '../../../models/event_model.dart';
import '../../../routes/route_helper.dart';
import '../../../utils/colors.dart';
import '../../../utils/dimensions.dart';
import '../../../widgets/create_event_widget.dart';
import '../../../widgets/timer/countdown_timer_widget.dart';
// Import other necessary packages and files

class PendingEventsGrid extends StatefulWidget {
  final String selectedEventType;
  final Function(String) onEventTypeChanged;

  const PendingEventsGrid(
      {Key? key,
      required this.selectedEventType,
      required this.onEventTypeChanged})
      : super(key: key);

  @override
  _PendingEventsGridState createState() => _PendingEventsGridState();
}

class _PendingEventsGridState extends State<PendingEventsGrid> {
  late Stream<List<EventModel>> _eventsStream;
  final EventController eventController = Get.find<EventController>();

  @override
  void initState() {
    super.initState();
    //_eventsStream =
    // eventController.pendingEventsStream(widget.selectedEventType);
  }

  @override
  void didUpdateWidget(PendingEventsGrid oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedEventType != widget.selectedEventType) {
      //_eventsStream =
      //  eventController.pendingEventsStream(widget.selectedEventType);
    }
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
  void dispose() {
    // If the stream is a broadcast stream, you don't need to close it.
    // If it's a single-subscription stream or StreamController, uncomment the next line:
    eventController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: StreamBuilder<List<EventModel>>(
        stream: _eventsStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
                child: SizedBox(
              height: Dimensions.height45 * 3.7,
              child: Column(
                children: [
                  SizedBox(height: Dimensions.height10),
                  const Text("Hmm looks empty here..."),
                  SizedBox(height: Dimensions.height15),
                  const Center(child: CreateEventWidget())
                ],
              ),
            ));
          } else {
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: Dimensions.width15),
              child: AnimationLimiter(
                child: StaggeredGridView.countBuilder(
                  padding: EdgeInsets.only(top: Dimensions.height10),
                  shrinkWrap: true,
                  physics: const AlwaysScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  itemCount: snapshot.data!.length,
                  itemBuilder: (BuildContext context, int index) {
                    EventModel event = snapshot.data![index];
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
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                    BorderRadius.circular(Dimensions.radius15),
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
                                          topLeft: Radius.circular(
                                              Dimensions.radius15),
                                          topRight: Radius.circular(
                                              Dimensions.radius15),
                                        ),
                                        child: Image.asset(
                                          _getImagePath(
                                              event.eventType ?? "FOOD"),
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
                                                horizontal:
                                                    Dimensions.width10 * 0.8,
                                                vertical:
                                                    Dimensions.height10 * 0.4),
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      Dimensions.radius20 *
                                                          0.4),
                                            ),
                                            child: CountdownTimer(
                                                initialMinutes: eventController
                                                    .calculateRemainingTimeInRoundedMinutes(
                                                        event.pendingUntil!),
                                                onTimerExpired: () {
                                                  widget.onEventTypeChanged;
                                                })),
                                      ),
                                    ],
                                  ),
                                  Padding(
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
                                        Row(
                                          children: [
                                            SizedBox(
                                                width:
                                                    Dimensions.width10 * 0.4),
                                            Expanded(
                                              child: Text(
                                                event.description ??
                                                    "No description",
                                                style: TextStyle(
                                                  color: AppColors
                                                      .mainBlueDarkColor,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize:
                                                      Dimensions.font20 * 0.6,
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(
                                              child: Text(
                                                'By ${event.userProfileFirstName} ${event.userProfileLastName}',
                                                style: TextStyle(
                                                  color: Colors.grey,
                                                  fontSize:
                                                      Dimensions.font20 * 0.6,
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
                            ),
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
        },
      ),
    );
  }
}

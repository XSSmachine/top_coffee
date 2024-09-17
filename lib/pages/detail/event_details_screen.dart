import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:team_coffee/routes/route_helper.dart';
import 'package:team_coffee/widgets/timer/count_timer_widget.dart';

import '../../controllers/event_controller.dart';
import '../../controllers/order_controller.dart';
import '../../models/event_model.dart';
import '../../utils/colors.dart';
import '../../utils/dimensions.dart';
import '../../utils/string_resources.dart';
import '../../widgets/order/order_details_widget.dart';
import '../../widgets/timer/countdown_timer_widget.dart';

/// This class displays event details with option to create new order for it or display order details

class EventDetailsScreen extends StatelessWidget {
  final EventController eventController = Get.find<EventController>();

  final String eventId;
  final String page;
  final String? orderId;

  EventDetailsScreen({
    Key? key,
    required this.eventId,
    required this.page,
    this.orderId,
  }) : super(key: key);

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
  Widget build(BuildContext context) {
    print(orderId.toString());
    return Scaffold(
      body: FutureBuilder<EventModel>(
        future: eventController.getEventById(eventId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
                child: Text('${AppStrings.errorMsg}: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final event = snapshot.data!;
            return Stack(
              children: [
                Column(
                  children: [
                    Expanded(
                        child: Stack(
                      children: [
                        Positioned(
                          top: 0,
                          left: 0,
                          right: 0,
                          child: Hero(
                            tag: UniqueKey(),
                            child: Image.asset(
                              _getImagePath(event.eventType ?? "FOOD"),
                              width: double.infinity,
                              height: MediaQuery.of(context).size.height * 0.4,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        // Scrollable content
                        SingleChildScrollView(
                          child: Column(
                            children: [
                              // Padding to account for the image height
                              SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.4 -
                                          30),
                              // Timer container

                              Center(
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: Dimensions.width15,
                                    vertical: Dimensions.height15 / 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(20),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black26,
                                        blurRadius: Dimensions.radius20 / 2,
                                        offset: Offset(0, 5),
                                      ),
                                    ],
                                  ),
                                  child: page != "completed"
                                      ? Column(
                                          children: [
                                            event.status == "PENDING"
                                                ? Text(
                                                    AppStrings.timePending.tr)
                                                : Text(AppStrings
                                                    .timeInProgress.tr),
                                            event.status == "PENDING"
                                                ? CountdownTimer(
                                                    initialMinutes: eventController
                                                        .calculateRemainingTimeInRoundedMinutes(
                                                            event
                                                                .pendingUntil!),
                                                    onTimerExpired: () {
                                                      Get.back();
                                                    },
                                                  )
                                                : CountTimer(
                                                    startTimeISO:
                                                        event.pendingUntil!,
                                                    size: Dimensions.font16,
                                                    showContainer: false,
                                                  )
                                          ],
                                        )
                                      : Text("FINISHED".tr),
                                ),
                              ),

                              SizedBox(
                                height: Dimensions.height10,
                              ),
                              Padding(
                                padding: EdgeInsets.all(Dimensions.width15),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          event.title ?? 'No Title',
                                          style: TextStyle(
                                            fontSize: Dimensions.font26 * 0.85,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: Dimensions.height15 / 2),
                                    Row(
                                      children: [
                                        CircleAvatar(
                                          backgroundImage: NetworkImage(
                                            event.photoUrl ??
                                                'https://via.placeholder.com/50x50',
                                          ),
                                          radius: Dimensions.radius20,
                                        ),
                                        SizedBox(
                                            width: Dimensions.height15 / 2),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              '${event.userProfileFirstName} ${event.userProfileLastName}',
                                              style: TextStyle(
                                                fontSize: Dimensions.font16,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Text(
                                              AppStrings.organizer.tr,
                                              style: TextStyle(
                                                fontSize:
                                                    Dimensions.font16 * 0.85,
                                                color: Colors.grey,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: Dimensions.height15),
                                    Text(
                                      AppStrings.aboutEvent.tr,
                                      style: TextStyle(
                                        fontSize: Dimensions.font16 * 1.1,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(height: Dimensions.height15 / 2),
                                    Text(
                                      event.description ?? "Short description",
                                      style: TextStyle(
                                        fontSize: Dimensions.font16,
                                      ),
                                    ),
                                    SizedBox(height: Dimensions.height15),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        SafeArea(
                          child: Padding(
                            padding: EdgeInsets.all(Dimensions.height10),
                            child: IconButton(
                              icon: Icon(Icons.arrow_back, color: Colors.white),
                              onPressed: () {
                                Get.back();
                              },
                            ),
                          ),
                        ),
                      ],
                    )),
                    Padding(
                      padding: EdgeInsets.all(Dimensions.height30),
                      child: _buildBottomButton(
                        context,
                        orderId,
                        page,
                        event,
                      ),
                    )
                  ],
                )
                // Fixed image at the top
              ],
            );
          } else {
            return const Center(child: Text('No data available'));
          }
        },
      ),
    );
  }

  Widget _buildBottomButton(
      BuildContext context, String? orderId, String page, EventModel event) {
    if (orderId != null && orderId.isNotEmpty && orderId != "null") {
      print("Order ID is -> $orderId");
      print("Page is $page");

      return OrderDetailsWidget(
        orderId: orderId,
        eventStatus: event.status!.replaceAll("_", " "),
      );
    } else {
      return Center(
        child: ElevatedButton(
          onPressed: () {
            if (page == "in_progress") {
              // Implement contact organizer functionality
              // For example: Get.toNamed(RouteHelper.getContactOrganizerPage());
            } else {
              Get.toNamed(
                  RouteHelper.getCreateOrderPage(eventId, event.eventType!));
            }
          },
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.symmetric(
                horizontal: Dimensions.width15 * 1.1,
                vertical: Dimensions.height15),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            foregroundColor: AppColors.mainPurpleColor,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                _getButtonText(page),
                style: TextStyle(
                  fontSize: Dimensions.font16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(width: Dimensions.width15 / 2),
              const Icon(Icons.arrow_forward),
            ],
          ),
        ),
      );
    }
  }

  String _getButtonText(String page) {
    if (page == "in_progress") {
      return AppStrings.contactOrganizer.tr;
    } else if (page == "pending") {
      return AppStrings.makeOrder.tr;
    } else {
      return AppStrings.makeOrder.tr; // Default text
    }
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:team_coffee/routes/route_helper.dart';
import 'package:team_coffee/widgets/timer/count_timer_widget.dart';

import '../../controllers/event_controller.dart';
import '../../controllers/order_controller.dart';
import '../../models/event_model.dart';
import '../../utils/colors.dart';
import '../../utils/dimensions.dart';
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

  @override
  Widget build(BuildContext context) {
    print(orderId.toString());
    return Scaffold(
      appBar: AppBar(
        title: const Text('Event Details'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Get.back();
          },
        ),
      ),
      body: FutureBuilder<EventModel>(
        future: eventController.getEventById(eventId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final event = snapshot.data!;
            return Column(
              children: [
                Expanded(
                  child: ListView(
                    children: [
                      Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Image.network(
                            'https://via.placeholder.com/400x200',
                            width: double.infinity,
                            height: Dimensions.height20 * 10.5,
                            fit: BoxFit.cover,
                          ),
                          Positioned(
                            top: Dimensions.height30 * 5.7,
                            left: Dimensions.width20 * 6.2,
                            child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 8),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Colors.black26,
                                      blurRadius: 10,
                                      offset: Offset(0, 5),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  children: [
                                    const Text("Time in progress: "),
                                    page == "pending"
                                        ? CountdownTimer(
                                            initialMinutes: eventController
                                                .calculateRemainingTimeInRoundedMinutes(
                                                    event.pendingUntil!),
                                            onTimerExpired: () {
                                              Get.back();
                                            })
                                        : CountTimer(
                                            startTimeISO: event.pendingUntil!,
                                            size: Dimensions.font16,
                                          ),
                                  ],
                                )),
                          ),
                        ],
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
                                  style: const TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                const CircleAvatar(
                                  backgroundImage: NetworkImage(
                                    'https://via.placeholder.com/50x50',
                                  ),
                                  radius: 20,
                                ),
                                const SizedBox(width: 8),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${event.userProfileFirstName} ${event.userProfileLastName}',
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const Text(
                                      'Organizer',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            const Text(
                              'About Event',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              event.description ?? "Short description",
                              style: const TextStyle(
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 16),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
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
        eventStatus: event.status!,
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
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
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
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 8),
              const Icon(Icons.arrow_forward),
            ],
          ),
        ),
      );
    }
  }

  String _getButtonText(String page) {
    if (page == "in_progress") {
      return "CONTACT ORGANIZER";
    } else if (page == "pending") {
      return "MAKE AN ORDER";
    } else {
      return "MAKE AN ORDER"; // Default text
    }
  }
}

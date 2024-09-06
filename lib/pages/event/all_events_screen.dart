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

class EventScreen extends StatelessWidget {
  final EventController eventController;
  final bool isPending;

  EventScreen({
    Key? key,
    required this.eventController,
    required this.isPending,
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
    return Scaffold(
      appBar: AppBar(
        title: Text(AppStrings.eventsTitle.tr),
      ),
      body: FutureBuilder<List<EventModel>>(
        future: isPending
            ? eventController.fetchPendingEvents("ALL")
            : eventController.fetchInProgressEvents("ALL"),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
                child: Text('${AppStrings.errorMsg.tr}: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: SizedBox(
                height: Dimensions.height45 * 3.7,
                child: Column(
                  children: [
                    SizedBox(height: Dimensions.height10),
                    const Center(child: CreateEventWidget())
                  ],
                ),
              ),
            );
          } else {
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: Dimensions.width15),
              child: ListView.builder(
                padding: EdgeInsets.only(top: Dimensions.height10),
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  EventModel event = snapshot.data![index];
                  return GestureDetector(
                    onTap: () {
                      Get.toNamed(RouteHelper.getEventDetail(
                          event.eventId ?? "",
                          isPending ? "pending" : "in_progress",
                          null));
                    },
                    child: Container(
                      margin: EdgeInsets.only(bottom: Dimensions.height10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius:
                            BorderRadius.circular(Dimensions.radius15),
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
                              topLeft: Radius.circular(Dimensions.radius15),
                              bottomLeft: Radius.circular(Dimensions.radius15),
                            ),
                            child: Image.asset(
                              _getImagePath(event.eventType ?? "FOOD"),
                              height: Dimensions.height20 * 5,
                              width: Dimensions.height20 * 5,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding:
                                  EdgeInsets.all(Dimensions.height10 * 0.4),
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
                                  Text(
                                    '${AppStrings.authorTitle.tr} ${event.userProfileFirstName} ${event.userProfileLastName}',
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: Dimensions.font20 * 0.6,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Text(
                                    event.description ?? "No description",
                                    style: TextStyle(
                                      color: AppColors.mainBlueDarkColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: Dimensions.font20 * 0.6,
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
                },
              ),
            );
          }
        },
      ),
    );
  }
}

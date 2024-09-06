import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:team_coffee/pages/event/all_events_screen.dart';
import 'package:team_coffee/pages/home/widgets/animated_event_grid.dart';
import 'package:team_coffee/pages/home/widgets/animated_event_list.dart';
import 'package:team_coffee/pages/home/widgets/filter_modal_widget.dart';
import 'package:team_coffee/utils/colors.dart';
import 'package:team_coffee/widgets/icon_and_text_widget.dart';
import '../../controllers/event_controller.dart';
import '../../routes/route_helper.dart';
import '../../utils/dimensions.dart';
import '../../utils/string_resources.dart';
import '../../widgets/event_type_chip.dart';

/// This class is the home screen, displaying all active events
/// and also gives brief overview on what app is about.
///

class TopAppbar extends StatelessWidget {
  final String selectedEventType;
  final Function(String) onEventTypeChanged;
  final EventController eventController;
  final Function(String) onSearch;
  final VoidCallback onFilterTap;

  const TopAppbar({
    super.key,
    required this.selectedEventType,
    required this.onEventTypeChanged,
    required this.eventController,
    required this.onSearch,
    required this.onFilterTap,
  });

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      backgroundColor: Colors.transparent.withOpacity(0.0),
      forceMaterialTransparency: true,
      pinned: true,
      floating: true,
      elevation: 2,
      snap: false,
      expandedHeight: Dimensions.height10 * 20,
      collapsedHeight: Dimensions.height10 * 20,
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: EdgeInsets.only(bottom: 0.0),
        background: Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              height: Dimensions.height10 * 19.5,
              decoration: const BoxDecoration(
                color: AppColors.mainPurpleColor,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(40),
                  bottomRight: Radius.circular(40),
                ),
              ),
            ),
            Positioned(
              top: Dimensions.height20 * 2.5,
              left: Dimensions.width20,
              right: Dimensions.width20,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Center(
                        child: Text(
                          'SyncSnack',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: Dimensions.font16 * 1.8,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 70),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.grey.withOpacity(0.2),
                          borderRadius:
                              BorderRadius.circular(Dimensions.radius20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 2.0,
                              offset: const Offset(0, 0),
                            ),
                          ],
                        ),
                        child: IconButton(
                          icon: Icon(Icons.notifications_none,
                              size: Dimensions.iconSize24, color: Colors.white),
                          onPressed: () {
                            Get.toNamed(RouteHelper.notificationListPage);
                          },
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: Dimensions.height10),
                  Container(
                    padding: EdgeInsets.all(Dimensions.height10 * 1.2),
                    decoration: BoxDecoration(
                      color: AppColors.mainPurpleColor,
                      borderRadius: BorderRadius.circular(Dimensions.radius20),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.search_outlined,
                            color: Colors.grey, size: Dimensions.iconSize24),
                        SizedBox(width: Dimensions.width10),
                        Expanded(
                          child: TextField(
                            decoration: InputDecoration(
                              hintText: '${AppStrings.searchTitle.tr}...',
                              hintStyle: TextStyle(fontSize: Dimensions.font16),
                              border: InputBorder.none,
                              prefixIcon: Text(
                                "|   ",
                                style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: Dimensions.font16),
                              ),
                              prefixIconConstraints:
                                  BoxConstraints(minWidth: 0, minHeight: 0),
                            ),
                            onChanged: onSearch,
                          ),
                        ),
                        GestureDetector(
                          onTap: onFilterTap,
                          child: Container(
                            padding: EdgeInsets.all(Dimensions.height10 * 0.8),
                            decoration: BoxDecoration(
                              color: Colors.grey.withOpacity(0.4),
                              borderRadius:
                                  BorderRadius.circular(Dimensions.radius20),
                            ),
                            child: IconAndTextWidget(
                              icon: Icons.filter_list,
                              text: AppStrings.filtersTitle.tr,
                              iconColor: Colors.grey,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                  // : Center(
                  //     child: Column(
                  //         crossAxisAlignment:
                  //             CrossAxisAlignment.center,
                  //         children: [
                  //           SizedBox(
                  //             height: Dimensions.height10,
                  //           ),
                  //           Text(
                  //             AppStrings.mainDescMsg.tr,
                  //             style: TextStyle(
                  //               color: Colors.white,
                  //               fontSize: Dimensions.font16,
                  //               fontWeight: FontWeight.normal,
                  //             ),
                  //             textAlign: TextAlign.center,
                  //           ),
                  //         ]),
                  //   ),
                ],
              ),
            ),
            Positioned(
              top: Dimensions.height10 * 17,
              left: 0,
              right: 0,
              child: SizedBox(
                height: Dimensions.height15 * 4,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      SizedBox(width: Dimensions.width10),
                      EventTypeChip(
                          label: AppStrings.allFilter.tr,
                          color: AppColors.redChipColor,
                          icon: Icons.fastfood,
                          selectedEventType:
                              eventController.selectedEventType.value,
                          onEventTypeChanged: onEventTypeChanged),
                      SizedBox(width: Dimensions.width10 * 0.8),
                      EventTypeChip(
                          label: AppStrings.coffeeFilter.tr,
                          color: AppColors.orangeChipColor,
                          icon: Icons.coffee,
                          selectedEventType:
                              eventController.selectedEventType.value,
                          onEventTypeChanged: onEventTypeChanged),
                      SizedBox(width: Dimensions.width10 * 0.8),
                      EventTypeChip(
                          label: AppStrings.foodFilter.tr,
                          color: AppColors.greenChipColor,
                          icon: Icons.restaurant,
                          selectedEventType:
                              eventController.selectedEventType.value,
                          onEventTypeChanged: onEventTypeChanged),
                      SizedBox(width: Dimensions.width10 * 0.8),
                      EventTypeChip(
                          label: AppStrings.beverageFilter.tr,
                          color: AppColors.blueChipColor,
                          icon: Icons.liquor,
                          selectedEventType:
                              eventController.selectedEventType.value,
                          onEventTypeChanged: onEventTypeChanged),
                      SizedBox(width: Dimensions.width10 * 0.8),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              height: Dimensions.height20,
            )
          ],
        ),
      ),
    );
    /* SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.only(
                  left: Dimensions.width20 * 1.3,
                  right: Dimensions.width20,
                  top: 0,
                  bottom: 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    AppStrings.activeEventsTitle.tr,
                    style: TextStyle(
                      fontSize: Dimensions.font20 * 1.1,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  !eventController.pendingEvents.isEmpty
                      ? GestureDetector(
                          onTap: () {
                            // Handle "See more" tap
                            Get.to(EventScreen(
                                eventController: eventController,
                                isPending: true));
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
                      : SizedBox.shrink(),
                ],
              ),
            ),
          ),*/
    // AnimatedEventGrid(
    //     selectedEventType: selectedEventType,
    //     eventController: eventController,
    //     onEventTypeChanged: onEventTypeChanged),
    // AnimatedEventList(
    //   eventController: eventController,
    //   eventType: selectedEventType,
    // ),
    // SliverToBoxAdapter(
    //   child: Padding(
    //     padding: EdgeInsets.all(Dimensions.height15),
    //     child: Container(
    //       decoration: BoxDecoration(
    //         color: Colors.white,
    //         borderRadius: BorderRadius.circular(Dimensions.radius15),
    //         boxShadow: [
    //           BoxShadow(
    //             color: Colors.grey.withOpacity(0.5),
    //             spreadRadius: 2,
    //             blurRadius: 5,
    //             offset: const Offset(0, 3),
    //           ),
    //         ],
    //       ),
    //       child: Padding(
    //         padding: EdgeInsets.all(Dimensions.width15),
    //         child: Column(
    //           crossAxisAlignment: CrossAxisAlignment.start,
    //           children: [
    //             Text(
    //               AppStrings.howDoesItWorkTitle.tr,
    //               style: TextStyle(
    //                 fontSize: Dimensions.font20 * 1.2,
    //                 fontWeight: FontWeight.bold,
    //               ),
    //             ),
    //             SizedBox(height: Dimensions.height10 * 0.8),
    //             Row(children: [
    //               Lottie.asset('assets/image/animation02.json',
    //                   width: Dimensions.width10 * 13,
    //                   height: Dimensions.width10 * 13,
    //                   fit: BoxFit.fill),
    //               SizedBox(width: Dimensions.width10 * 0.8),
    //               Expanded(
    //                 child: RichText(
    //                   text: TextSpan(
    //                     text: AppStrings.howDoesItWorkDesc.tr,
    //                     style: TextStyle(
    //                       fontSize: Dimensions.font20 * 0.9,
    //                       fontWeight: FontWeight.bold,
    //                       color: Colors.black,
    //                     ),
    //                     children: <TextSpan>[
    //                       TextSpan(
    //                         text: AppStrings.howDoesItWorkMoto.tr,
    //                         style: TextStyle(
    //                             fontWeight: FontWeight.normal,
    //                             fontSize: Dimensions.font20 * 0.80),
    //                       ),
    //                     ],
    //                   ),
    //                 ),
    //               ),
    //             ]),
    //           ],
    //         ),
    //       ),
    //     ),
    //   ),
    // ),
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:team_coffee/utils/colors.dart';
import 'package:team_coffee/widgets/create_event_widget.dart';
import 'package:team_coffee/widgets/timer/count_timer_widget.dart';
import 'package:team_coffee/widgets/timer/countdown_timer_widget.dart';
import 'package:team_coffee/widgets/icon_and_text_widget.dart';

import '../../controllers/event_controller.dart';
import '../../models/event_model.dart';
import '../../routes/route_helper.dart';
import '../../utils/dimensions.dart';
import '../../widgets/event_type_chip.dart';

/// This class is the home screen, displaying all active events
/// and also gives brief overview on what app is about.
///

class TopAppbar extends StatelessWidget {
  final String selectedEventType;
  final Function(String) onEventTypeChanged;
  final EventController eventController;

  const TopAppbar({
    super.key,
    required this.selectedEventType,
    required this.onEventTypeChanged,
    required this.eventController,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: Colors.transparent.withOpacity(0.0),
            forceMaterialTransparency: true,
            pinned: true,
            floating: true,
            elevation: 2,
            snap: false,
            expandedHeight: Dimensions.height10 * 20,
            collapsedHeight: Dimensions.height10 * 20,
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    height: Dimensions.height10 * 20.5,
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
                                    size: Dimensions.iconSize24,
                                    color: Colors.white),
                                onPressed: () {},
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: Dimensions.height10),
                        !eventController.pendingEvents.isEmpty
                            ? Container(
                                padding:
                                    EdgeInsets.all(Dimensions.height10 * 1.2),
                                decoration: BoxDecoration(
                                  color: AppColors.mainPurpleColor,
                                  borderRadius: BorderRadius.circular(
                                      Dimensions.radius20),
                                ),
                                child: Row(
                                  children: [
                                    Icon(Icons.search_outlined,
                                        color: Colors.grey,
                                        size: Dimensions.iconSize16),
                                    SizedBox(width: Dimensions.width10),
                                    const Expanded(
                                      child: TextField(
                                        decoration: InputDecoration(
                                          hintText: 'Search...',
                                          border: InputBorder.none,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      padding: EdgeInsets.all(
                                          Dimensions.height10 * 0.8),
                                      decoration: BoxDecoration(
                                        color: Colors.grey.withOpacity(0.4),
                                        borderRadius: BorderRadius.circular(
                                            Dimensions.radius20),
                                      ),
                                      child: const IconAndTextWidget(
                                        icon: Icons.filter_list,
                                        text: "Filters",
                                        iconColor: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : Center(
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        height: Dimensions.height10,
                                      ),
                                      Text(
                                        'Experience the joy of shared meals, organize team snacks in just a few clicks.',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: Dimensions.font16,
                                          fontWeight: FontWeight.normal,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ]),
                              ),
                      ],
                    ),
                  ),
                  Positioned(
                    top: Dimensions.height10 * 18,
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
                                label: "MIX",
                                color: AppColors.redChipColor,
                                icon: Icons.fastfood,
                                selectedEventType: selectedEventType,
                                onEventTypeChanged: onEventTypeChanged),
                            SizedBox(width: Dimensions.width10 * 0.8),
                            EventTypeChip(
                                label: "COFFEE",
                                color: AppColors.orangeChipColor,
                                icon: Icons.coffee,
                                selectedEventType: selectedEventType,
                                onEventTypeChanged: onEventTypeChanged),
                            SizedBox(width: Dimensions.width10 * 0.8),
                            EventTypeChip(
                                label: "FOOD",
                                color: AppColors.greenChipColor,
                                icon: Icons.restaurant,
                                selectedEventType:
                                    eventController.selectedEventType.value,
                                onEventTypeChanged: onEventTypeChanged),
                            SizedBox(width: Dimensions.width10 * 0.8),
                            EventTypeChip(
                                label: "BEVERAGE",
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
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.only(
                  left: Dimensions.width20, right: Dimensions.width20, top: 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Active events",
                    style: TextStyle(
                      fontSize: Dimensions.font20 * 1.1,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      // Handle "See more" tap
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
            ),
          ),
          SliverToBoxAdapter(
            child: FutureBuilder<List<EventModel>>(
              future: eventController.fetchPendingEvents(selectedEventType),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(
                      child: SizedBox(
                    height: Dimensions.height45 * 3.5,
                    child: Column(
                      children: [
                        SizedBox(
                          height: Dimensions.height10,
                        ),
                        const Text("Hmm looks empty here..."),
                        SizedBox(
                          height: Dimensions.height15,
                        ),
                        const Center(child: CreateEventWidget())
                      ],
                    ),
                  ));
                } else {
                  return Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: Dimensions.width15),
                    child: GridView.builder(
                      padding: EdgeInsets.only(top: Dimensions.height10),
                      shrinkWrap: true,
                      physics: const AlwaysScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: Dimensions.width20,
                        mainAxisSpacing: Dimensions.height10,
                        childAspectRatio:
                            1, // Adjust this value to change the height of the grid items
                      ),
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        EventModel event = snapshot.data![index];
                        return GestureDetector(
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
                                      child: Image.network(
                                        'https://via.placeholder.com/300x100',
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
                                            borderRadius: BorderRadius.circular(
                                                Dimensions.radius20 * 0.4),
                                          ),
                                          child: CountdownTimer(
                                              initialMinutes: eventController
                                                  .calculateRemainingTimeInRoundedMinutes(
                                                      event.pendingUntil!),
                                              onTimerExpired: () {
                                                onEventTypeChanged;
                                              })),
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding:
                                      EdgeInsets.all(Dimensions.height10 * 0.4),
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
                                              width: Dimensions.width10 * 0.4),
                                          Expanded(
                                            child: Text(
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
                        );
                      },
                    ),
                  );
                }
              },
            ),
          ),
          SliverToBoxAdapter(
            child: Obx(() {
              if (eventController.inProgressEvents.isEmpty) {
                return SizedBox(height: Dimensions.height30);
              } else {
                return Visibility(
                  visible: eventController.inProgressEvents.isNotEmpty,
                  child: SizedBox(
                    height: eventController.inProgressEvents.isEmpty
                        ? 0
                        : Dimensions.height45 * 5.5,
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        maxHeight: Dimensions.height45 * 5.5,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: Dimensions.width20,
                                vertical: Dimensions.height10 * 0.5),
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
                                    // Handle "See more" tap
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
                                      const Icon(Icons.arrow_right,
                                          color: Colors.blue),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: Dimensions.height45 * 4.5,
                            child: ListView.builder(
                              padding: EdgeInsets.all(Dimensions.height10),
                              shrinkWrap: true,
                              scrollDirection: Axis.horizontal,
                              physics: const AlwaysScrollableScrollPhysics(),
                              itemCount:
                                  eventController.inProgressEvents.length,
                              itemBuilder: (context, index) {
                                EventModel event =
                                    eventController.inProgressEvents[index];
                                return Center(
                                  child: GestureDetector(
                                    onTap: () {
                                      Get.toNamed(RouteHelper.getEventDetail(
                                          event.eventId ?? "",
                                          "in_progress",
                                          null));
                                    },
                                    child: Container(
                                      width: Dimensions.width20 * 8,
                                      height: Dimensions.height30 * 8,
                                      margin: EdgeInsets.symmetric(
                                          horizontal: Dimensions.width10),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(
                                            Dimensions.radius15),
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
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
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
                                                child: Image.network(
                                                  'https://via.placeholder.com/300x100',
                                                  height:
                                                      Dimensions.height20 * 5,
                                                  width: double.infinity,
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                              Positioned(
                                                top: Dimensions.height10 * 0.8,
                                                left: Dimensions.width10 * 0.8,
                                                child: Container(
                                                    padding: EdgeInsets.symmetric(
                                                        horizontal:
                                                            Dimensions.width10 *
                                                                0.8,
                                                        vertical: Dimensions
                                                                .height10 *
                                                            0.4),
                                                    decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius: BorderRadius
                                                          .circular(Dimensions
                                                                  .radius20 *
                                                              0.4),
                                                    ),
                                                    child: CountTimer(
                                                        startTimeISO: event
                                                            .pendingUntil!)),
                                              ),
                                            ],
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(
                                              left: Dimensions.height10,
                                              right: Dimensions.height10,
                                              top: Dimensions.height10 * 0.3,
                                              bottom: Dimensions.height10 * 0.5,
                                            ),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Text(
                                                  event.title ?? 'No Title',
                                                  style: TextStyle(
                                                    fontSize: Dimensions.font16,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                SizedBox(
                                                    height:
                                                        Dimensions.height10 *
                                                            0.3),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Flexible(
                                                      child: Text(
                                                        'By ${event.userProfileFirstName} ${event.userProfileLastName}',
                                                        style: TextStyle(
                                                            color: Colors.grey,
                                                            fontSize: Dimensions
                                                                    .font16 *
                                                                0.6),
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
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }
            }),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(Dimensions.height15),
              child: Container(
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
                child: Padding(
                  padding: EdgeInsets.all(Dimensions.width15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'How does it work?',
                        style: TextStyle(
                          fontSize: Dimensions.font20 * 1.2,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: Dimensions.height10 * 0.8),
                      Row(children: [
                        Lottie.asset('assets/image/animation02.json',
                            width: Dimensions.width10 * 13,
                            height: Dimensions.width10 * 13,
                            fit: BoxFit.fill),
                        SizedBox(width: Dimensions.width10 * 0.8),
                        Expanded(
                          child: RichText(
                            text: TextSpan(
                              text: 'Discover, Order, Enjoy: ',
                              style: TextStyle(
                                fontSize: Dimensions.font20 * 0.9,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                              children: <TextSpan>[
                                TextSpan(
                                  text:
                                      'Your Team\'s Snack Experience Made Simple',
                                  style: TextStyle(
                                      fontWeight: FontWeight.normal,
                                      fontSize: Dimensions.font20 * 0.80),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ]),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

/*
          SliverToBoxAdapter(
            child: FutureBuilder<List<EventModel>>(
              future: eventController.fetchPendingEvents(selectedEventType),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return _buildEmptyState();
                } else {
                  return _buildPendingEvents(snapshot.data!);
                }
              },
            ),
          ),
          SliverToBoxAdapter(
            child: Obx(() {
              if (eventController.inProgressEvents.isEmpty) {
                return const SizedBox.shrink();
              } else {
                return _buildInProgressEvents();
              }
            }),
          ),
          SliverToBoxAdapter(
            child: _buildHowItWorks(),
          ),
*/

  Widget _buildEmptyState() {
    return Column(
      children: [
        SizedBox(height: Dimensions.height20),
        const Text("No events yet. Create one to get started!"),
        SizedBox(
          height: Dimensions.height20,
        ),
        const Center(child: CreateEventWidget()),
      ],
    );
  }

  Widget _buildPendingEvents(List<EventModel> events) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(
              horizontal: Dimensions.width20, vertical: Dimensions.height10),
          child: Text(
            "Active events",
            style: TextStyle(
              fontSize: Dimensions.font20 * 1.1,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: Dimensions.width15),
          child: GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: Dimensions.width20,
              mainAxisSpacing: Dimensions.height10,
              childAspectRatio: 1,
            ),
            itemCount: events.length,
            itemBuilder: (context, index) {
              EventModel event = events[index];
              return _buildEventCard(event);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildInProgressEvents() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(
              horizontal: Dimensions.width20, vertical: Dimensions.height10),
          child: Text(
            "Events in progress",
            style: TextStyle(
              fontSize: Dimensions.font20 * 1.1,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(
          height: Dimensions.height45 * 4,
          child: ListView.builder(
            padding: EdgeInsets.all(Dimensions.height10),
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            physics: const AlwaysScrollableScrollPhysics(),
            itemCount: eventController.inProgressEvents.length,
            itemBuilder: (context, index) {
              EventModel event = eventController.inProgressEvents[index];
              return _buildEventCard(event, isHorizontal: true);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildEventCard(EventModel event, {bool isHorizontal = false}) {
    return GestureDetector(
      onTap: () {
        print(event.groupId);
        Get.toNamed(
            RouteHelper.getEventDetail(event.groupId ?? "", "home", null));
      },
      child: Container(
        width: isHorizontal ? Dimensions.width20 * 8 : null,
        margin: EdgeInsets.symmetric(
            horizontal: isHorizontal ? Dimensions.width10 : 0),
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(Dimensions.radius15),
                    topRight: Radius.circular(Dimensions.radius15),
                  ),
                  child: Image.network(
                    'https://via.placeholder.com/300x100',
                    height: Dimensions.height20 * 5,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  top: Dimensions.height10 * 0.8,
                  left: Dimensions.width10 * 0.8,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: Dimensions.width10 * 0.8,
                      vertical: Dimensions.height10 * 0.4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                          BorderRadius.circular(Dimensions.radius20 * 0.4),
                    ),
                    child: CountdownTimer(
                      initialMinutes: eventController
                          .calculateRemainingTimeInRoundedMinutes(
                              event.pendingUntil!),
                      onTimerExpired: () {
                        onEventTypeChanged(selectedEventType);
                      },
                    ),
                  ),
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
      ),
    );
  }

  Widget _buildHowItWorks() {
    return Padding(
      padding: EdgeInsets.all(Dimensions.height15),
      child: Container(
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
        child: Padding(
          padding: EdgeInsets.all(Dimensions.width15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'How does it work?',
                style: TextStyle(
                  fontSize: Dimensions.font20 * 1.2,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: Dimensions.height10 * 0.8),
              Row(
                children: [
                  Lottie.asset(
                    'assets/image/animation02.json',
                    width: Dimensions.width10 * 13,
                    height: Dimensions.width10 * 13,
                    fit: BoxFit.fill,
                  ),
                  SizedBox(width: Dimensions.width10 * 0.8),
                  Expanded(
                    child: RichText(
                      text: TextSpan(
                        text: 'Discover, Order, Enjoy: ',
                        style: TextStyle(
                          fontSize: Dimensions.font20 * 0.9,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                        children: <TextSpan>[
                          TextSpan(
                            text: 'Your Team\'s Snack Experience Made Simple',
                            style: TextStyle(
                              fontWeight: FontWeight.normal,
                              fontSize: Dimensions.font20 * 0.80,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

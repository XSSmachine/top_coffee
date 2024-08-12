import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/auth_controller.dart';
import '../../controllers/event_controller.dart';
import 'dashboard.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final EventController eventController = Get.find<EventController>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchInitialData();
    });
  }

  void _fetchInitialData() {
    eventController
        .fetchPendingEvents(eventController.selectedEventType.value)
        .then((_) {
      return eventController
          .fetchInProgressEvents(eventController.selectedEventType.value);
    }).catchError((error) {
      // Handle any errors here
      print('Error fetching initial data: $error');
    });
  }

  void _updateSelectedEventType(String newType) {
    setState(() {
      eventController.selectedEventType.value = newType;
      eventController
          .fetchPendingEvents(eventController.selectedEventType.value);
      eventController.fetchInProgressEvents(newType);
    });
    // Call any method you need when the event type changes
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() => TopAppbar(
            selectedEventType: eventController.selectedEventType.value,
            onEventTypeChanged: _updateSelectedEventType,
            eventController: eventController,
          )),
    );
  }
}

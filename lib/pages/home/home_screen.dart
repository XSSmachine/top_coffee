import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
    _fetchInitialData();
  }

  Future<void> _fetchInitialData() async {
    await eventController
        .fetchPendingEvents(eventController.selectedEventType.value);
    await eventController
        .fetchInProgressEvents(eventController.selectedEventType.value);
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

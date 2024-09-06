import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stomp_dart_client/stomp_dart_client.dart' as client;
import 'package:stomp_dart_client/stomp_dart_client.dart';
import 'package:team_coffee/pages/home/dashboard_screen.dart';

import '../../base/show_custom_snackbar.dart';
import '../../controllers/auth_controller.dart';
import '../../controllers/event_controller.dart';
import '../../models/filter_model.dart';
import '../../models/response_model.dart';
import '../../utils/app_constants.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final EventController eventController = Get.find<EventController>();

  /*void onConnectCallback(StompFrame connectFrame) async {
    String? groupId = await Get.find<AuthController>().fetchMeGroupId();
    _client.subscribe(
        destination: '/topic/groups/${groupId}', //topic/groups/groupId
        headers: {},
        callback: (frame) {
          print(frame.body);
          showCustomSnackBar(frame.body ?? "Null message");
          // Received a frame for this subscription
          messages = jsonDecode(frame.body!).reversed.toList();
        });
  }*/

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
    print("STREAM CALL" + eventController.selectedEventType.value);
    setState(() {
      eventController.selectedEventType.value = newType;
      eventController.onWebSocketMessage(
          0,
          eventController.pageSize,
          '',
          EventFilters(
              eventType: eventController.selectedEventType.value,
              status: eventController.selectedEventStatus.value,
              timeFilter: eventController.selectedTimeFilter.value));
      //eventController.fetchInProgressEvents(newType);
    });
    // Call any method you need when the event type changes
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DashboardScreen(),
    );
  }
}

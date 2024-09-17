import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:team_coffee/pages/home/dashboard_screen.dart';
import '../../controllers/event_controller.dart';
import '../../models/filter_model.dart';

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
    EventFilters filters = EventFilters(
      eventType: eventController.selectedEventType.value,
      status: eventController.selectedEventStatus,
      timeFilter: eventController.selectedTimeFilter.value,
    );

    eventController
        .fetchFilteredEvents(
      page: 0,
      size: eventController.pageSize,
      search: '',
      filters: filters,
    )
        .catchError((error) {
      // Handle any errors here
      print('Error fetching initial data: $error');
    });
  }

  void _updateSelectedEventType(String newType) {
    setState(() {
      eventController.selectedEventType.value = newType;
      _fetchFilteredEvents();
    });
  }

  void _fetchFilteredEvents() {
    EventFilters filters = EventFilters(
      eventType: eventController.selectedEventType.value,
      status: eventController.selectedEventStatus,
      timeFilter: eventController.selectedTimeFilter.value,
    );

    eventController.fetchFilteredEvents(
      page: 0,
      size: eventController.pageSize,
      search: '',
      filters: filters,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DashboardScreen(),
    );
  }
}

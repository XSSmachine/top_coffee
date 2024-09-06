import 'dart:async';
import 'dart:convert';

import 'package:get/get.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:team_coffee/base/show_custom_snackbar.dart';
import 'package:team_coffee/controllers/notification_controller.dart';
import 'package:team_coffee/models/filter_model.dart';

import '../data/repository/event_repo.dart';
import '../data/repository/order_repo.dart';
import '../data/repository/user_repo.dart';
import '../models/event_body_model.dart';
import '../models/event_model.dart';
import '../models/monthly_summary.dart';
import '../models/order_get_model.dart';
import '../utils/string_resources.dart';

class EventController extends GetxController implements GetxService {
  final EventRepo eventRepo;
  final OrderRepo orderRepo;
  final UserRepo userRepo;

  EventController({
    required this.eventRepo,
    required this.orderRepo,
    required this.userRepo,
  });

  RxString selectedEventType = "ALL".obs;
  RxString selectedTimeFilter = "".obs;
  RxList<String> selectedEventStatus = ["PENDING"].obs;
  final int pageSize = 10;

  final Rx<bool> _isLoading = false.obs;
  final Rx<EventModel?> _currentEvent = Rx<EventModel?>(null);
  final RxList<EventModel> _pendingEvents = <EventModel>[].obs;
  final RxList<EventModel> _inProgressEvents = <EventModel>[].obs;
  final RxList<EventModel> _completedEvents = <EventModel>[].obs;
  final RxList<OrderGetModel> _currentEventOrders = <OrderGetModel>[].obs;

  bool get isLoading => _isLoading.value;
  EventModel? get currentEvent => _currentEvent.value;
  List<EventModel> get pendingEvents => _pendingEvents;
  List<EventModel> get inProgressEvents => _inProgressEvents;
  List<EventModel> get completedEvents => _completedEvents;
  List<OrderGetModel> get currentEventOrders => _currentEventOrders;

  final _currentEventStream = StreamController<EventModel?>.broadcast();
  Stream<EventModel?> get currentEventStream => _currentEventStream.stream;

  void resetAllValues() {
    _currentEvent.value = null;
    _pendingEvents.clear();
    _inProgressEvents.clear();
    _currentEventOrders.clear();
    selectedEventType.value = AppStrings.allFilter.tr;
    _isLoading.value = false;
  }

  /// Method for calculating remaining time for each event
  double calculateRemainingTimeInRoundedMinutes(String ISO,
      {Duration eventDuration = const Duration(hours: 1)}) {
    DateTime startTime = DateTime.parse(ISO);
    DateTime now = DateTime.now();
    Duration remainingTime = startTime.difference(now);
    double remainingMinutes = (remainingTime.inSeconds / 60);
    return remainingMinutes > 0 ? remainingMinutes : 0;
  }

  /// Method for creating new event
  Future<bool?> createEvent(EventBody eventBody,
      NotificationController notificationController) async {
    _isLoading.value = true;
    try {
      final response = await eventRepo.createEvent(eventBody);
      if (response.statusCode == 200 || response.statusCode == 201) {
        if (response.body != null) {
          return true;
        }
      } else if (response.statusCode == 400) {
        showCustomSnackBar("Error 400");
      }
    } catch (e) {
      print('Error creating event: $e');
    } finally {
      _isLoading.value = false;
    }
    return false;
  }

  /// Method for changing event status into "COMPLETED" or "CANCELLED"
  Future<bool?> updateEvent(String eventId, String status) async {
    _isLoading.value = true;
    try {
      final response = await eventRepo.updateEvent(eventId, status);
      if (response.statusCode == 200 || response.statusCode == 201) {
        if (response.body != null) {
          return true; // Event created successfully
        }
      } else if (response.statusCode == 400) {
        showCustomSnackBar("Error 400");
      }
    } catch (e) {
      print('Error creating event: $e');
    } finally {
      _isLoading.value = false;
    }
    return false; // Event creation failed
  }

  // void updateSelectedEventType(String newType) {
  //   selectedEventType.value = newType;
  //   fetchPendingEvents(newType);
  //   //fetchInProgressEvents(newType);
  //   update();
  // }

  Future<void> fetchFilteredEvents({
    required int page,
    required int size,
    required String search,
    required EventFilters filters,
  }) async {
    try {
      print(
          'FETCHING FILTERED EVENTS _________ $page ---- $size----  ----${filters.status} ----- [${filters.status.join(", ")}] ---- ${filters.timeFilter}');
      print('LOADING HERE!');

      List<EventModel> newPendingEvents = [];
      List<EventModel> newInProgressEvents = [];
      List<EventModel> newCompletedEvents = [];

      if (filters.status.isEmpty) {
        filters = filters.copyWith(status: ['PENDING']);
      }

      for (String status in filters.status) {
        await _fetchEventsForStatus(
          status: status,
          page: page,
          size: size,
          search: search,
          filters: filters,
          newPendingEvents: newPendingEvents,
          newInProgressEvents: newInProgressEvents,
          newCompletedEvents: newCompletedEvents,
        );
      }

      // Update the state based on pagination
      if (page == 0) {
        // Replace all events if it's the first page
        _pendingEvents.value = newPendingEvents;
        _inProgressEvents.value = newInProgressEvents;
        _completedEvents.value = newCompletedEvents;
      } else {
        // Append new events if it's not the first page
        _pendingEvents.addAll(newPendingEvents);
        _inProgressEvents.addAll(newInProgressEvents);
        _completedEvents.addAll(newCompletedEvents);
      }

      print(
          'Fetched events: Pending: ${_pendingEvents.length}, In Progress: ${_inProgressEvents.length}, Completed: ${_completedEvents.length}');

      _emitUpdatedEvents();
    } catch (e) {
      print('Error fetching filtered events: $e');
      // You might want to show an error message to the user here
    }
  }

  Future<void> _fetchEventsForStatus({
    required String status,
    required int page,
    required int size,
    required String search,
    required EventFilters filters,
    required List<EventModel> newPendingEvents,
    required List<EventModel> newInProgressEvents,
    required List<EventModel> newCompletedEvents,
  }) async {
    try {
      final response = await eventRepo.getFilteredEvents(
        page,
        size,
        search,
        filters,
      );
      if (response.statusCode == 200) {
        print(response.body.toString());
        List<EventModel> events = (response.body as List<dynamic>)
            .map((event) => EventModel.fromJson(event as Map<String, dynamic>))
            .toList();
        switch (status) {
          case 'PENDING':
            for (EventModel event in events) {
              print("TITLEEEE  " + event.title!);
            }
            newPendingEvents.addAll(events);
            break;
          case 'IN_PROGRESS':
            newInProgressEvents.addAll(events);
            break;
          case 'COMPLETED':
            newCompletedEvents.addAll(events);
            break;
          default:
            print('Unexpected status: $status');
        }
        print('Fetched ${events.length} events for status: $status');
      } else {
        throw Exception('Failed to load events for status: $status');
      }
    } catch (e) {
      print('Error fetching events for status $status: $e');
    }
  }

  final Map<String, StreamController<List<EventModel>>> _streamControllers = {
    'PENDING': StreamController<List<EventModel>>.broadcast(),
    'IN_PROGRESS': StreamController<List<EventModel>>.broadcast(),
    'COMPLETED': StreamController<List<EventModel>>.broadcast(),
  };

  Stream<List<EventModel>> eventsStream(
      String status, int page, int size, String search, EventFilters filters) {
    if (!_streamControllers.containsKey(status)) {
      _streamControllers[status] =
          StreamController<List<EventModel>>.broadcast();
    }

    // Initial fetch
    _fetchAndEmit(page, size, search, filters);

    // Close the controller when the stream is no longer listened to
    _streamControllers[status]!.onCancel = () {
      _streamControllers[status]?.close();
      _streamControllers.remove(status);
    };

    return _streamControllers[status]!.stream;
  }

  Future<void> _fetchAndEmit(
      int page, int size, String search, EventFilters filters) async {
    try {
      await fetchFilteredEvents(
          page: page, size: size, search: search, filters: filters);
      _emitUpdatedEvents();
    } catch (e) {
      print('Error fetching and emitting events: $e');
      // You might want to emit an error to the streams here
    }
  }

  void _emitUpdatedEvents() {
    if (_streamControllers.containsKey('PENDING') &&
        !_streamControllers['PENDING']!.isClosed) {
      _streamControllers['PENDING']!.add(_pendingEvents);
      print('Emitted ${_pendingEvents.length} pending events');
    }
    if (_streamControllers.containsKey('IN_PROGRESS') &&
        !_streamControllers['IN_PROGRESS']!.isClosed) {
      _streamControllers['IN_PROGRESS']!.add(_inProgressEvents);
      print('Emitted ${_inProgressEvents.length} in-progress events');
    }
    if (_streamControllers.containsKey('COMPLETED') &&
        !_streamControllers['COMPLETED']!.isClosed) {
      _streamControllers['COMPLETED']!.add(_completedEvents);
      print('Emitted ${_completedEvents.length} completed events');
    }
  }

  void onWebSocketMessage(
      int page, int size, String search, EventFilters filters) {
    _fetchAndEmit(page, size, search, filters);
  }

  @override
  void onClose() {
    for (var controller in _streamControllers.values) {
      controller.close();
    }
    super.onClose();
  }

  //Getting pending events
  Future<List<EventModel>> fetchPendingEvents(String eventType) async {
    _isLoading.value = true;
    try {
      final events = await eventRepo.getPendingEvents(eventType);
      print("PENDING........${events.length}");
      _pendingEvents.assignAll(events);
      return events;
    } catch (e) {
      print(e.toString());
      print('Error fetching pending events: $e');
      rethrow;
    } finally {
      _isLoading.value = false;
    }
  }

  //Getting in_progress events
  Future<List<EventModel>> fetchInProgressEvents(String eventType) async {
    _isLoading.value = true;
    try {
      final events = await eventRepo.getInProgressEvents(eventType);

      if (events.isNotEmpty) {
        _inProgressEvents.assignAll(events);
        return events;
      } else {
        return [];
      }
    } catch (e) {
      print(eventType);
      print('Error fetching in-progress events: $e');
      rethrow;
    } finally {
      _isLoading.value = false;
    }
  }

  //Getting completed events
  Future<List<EventModel>> fetchCompleteEvents(String eventType) async {
    _isLoading.value = true;
    try {
      final events = await eventRepo.getCompleteEvents(eventType);
      //_inProgressEvents.assignAll(events); // This should probably be _completedEvents
      return events;
    } catch (e) {
      print('Error fetching completed events: $e');
      rethrow;
    } finally {
      _isLoading.value = false;
    }
  }

  Future<EventModel> getEventById(String eventId) async {
    try {
      final orders = await eventRepo.getEventById(eventId);
      return orders;
    } catch (e) {
      print('Error fetching event orders: $e');
      return EventModel(
          userProfileId: null,
          userProfileFirstName: null,
          userProfileLastName: null);
    }
  }

  Future<void> getActiveEvent2() async {
    try {
      // Assume this method fetches the active event from an API or database
      final event = await getActiveEvent();
      _currentEventStream.add(event);
    } catch (e) {
      print('Error fetching active event: $e');
      // _currentEventStream.add(null);
    }
  }

  Future<EventModel?> getActiveEvent() async {
    try {
      print("getting current active event");
      final orders = await eventRepo.getMyActiveEvent();
      if (orders != null) {
        print("ACTIVE EVENT STATUS" + orders.status.toString());
        _currentEvent.value = orders;
        return orders;
      } else {
        _currentEvent.value = null;
        print('Error fetching active event');
        return orders;
      }
    } catch (e) {
      print('Error fetching event orders: $e');
      return EventModel(
          userProfileId: null,
          userProfileFirstName: null,
          userProfileLastName: null);
    }
  }

  // Getting details for user who created the event
  Future<void> fetchEventCreator(String creatorId) async {
    try {
      await userRepo.getUserById(creatorId);
    } catch (e) {
      print('Error fetching event creator: $e');
    }
  }

  Future<void> fetchOrderUsers() async {
    try {
      for (final order in _currentEventOrders) {
        await userRepo.getUserById(order.userProfileId!);
      }
    } catch (e) {
      print('Error fetching order users: $e');
    }
  }

  Future<List<MonthlySummary>> fetchEventsStatistics() async {
    final response = await eventRepo.fetchEventsStats();
    if (response.isNotEmpty) {
      return response;
    } else {
      throw Exception('Failed to get orders statistic data');
    }
  }

  Future<List<dynamic>> fetchEventPieData() async {
    try {
      final response = await eventRepo.fetchEventPieData();
      if (response.statusCode == 200) {
        return response.body;
      } else {
        throw Exception('Failed to load data: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching data: $e');
      throw Exception('Failed to fetch event data: $e');
    }
  }
}

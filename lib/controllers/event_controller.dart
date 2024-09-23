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
import 'group_controller.dart';

class EventController extends GetxController implements GetxService {
  final EventRepo eventRepo;
  final OrderRepo orderRepo;
  final UserRepo userRepo;

  final Rx<bool> _hasMorePending = false.obs;
  final Rx<bool> _hasMoreInProgress = false.obs;
  final Rx<bool> _hasMoreCompleted = false.obs;

  bool get hasMorePending => _hasMorePending.value;
  bool get hasMoreInProgress => _hasMorePending.value;
  bool get hasMoreCompleted => _hasMorePending.value;

  EventController({
    required this.eventRepo,
    required this.orderRepo,
    required this.userRepo,
  });

  final GroupController _groupController = Get.find<GroupController>();

  @override
  void onInit() {
    super.onInit();
    ever(
        _groupController.currentGroupId,
        (_) async => await fetchFilteredEvents(
              page: 0,
              size: pageSize,
              search: '',
              filters: EventFilters(
                  eventType: selectedEventType.value,
                  status: selectedEventStatus.value,
                  timeFilter: selectedTimeFilter.value),
            ));
  }

  RxString selectedEventType = "ALL".obs;
  RxString selectedTimeFilter = "THIS_WEEK".obs;
  RxList<String> selectedEventStatus = ["PENDING"].obs;
  final int pageSize = 11;

  final StreamController<List<EventModel>> _pendingEventsController =
      StreamController<List<EventModel>>.broadcast();
  final StreamController<List<EventModel>> _inProgressEventsController =
      StreamController<List<EventModel>>.broadcast();
  final StreamController<List<EventModel>> _completedEventsController =
      StreamController<List<EventModel>>.broadcast();

  // Expose streams
  Stream<List<EventModel>> get pendingEventsStream =>
      _pendingEventsController.stream;
  Stream<List<EventModel>> get inProgressEventsStream =>
      _inProgressEventsController.stream;
  Stream<List<EventModel>> get completedEventsStream =>
      _completedEventsController.stream;

  final Rx<bool> _isLoading = false.obs;
  final Rx<EventModel?> _currentEvent = Rx<EventModel?>(null);
  final RxList<EventModel> _pendingEvents = <EventModel>[].obs;
  final RxList<EventModel> _inProgressEvents = <EventModel>[].obs;
  final RxList<EventModel> _completedEvents = <EventModel>[].obs;
  final RxList<OrderGetModel> _currentEventOrders = <OrderGetModel>[].obs;
  final RxList<EventModel> _allEventList = <EventModel>[].obs;
  final RxList<EventModel> _pendingEventList = <EventModel>[].obs;
  final RxList<EventModel> _inProgressEventList = <EventModel>[].obs;
  final RxList<EventModel> _completedEventList = <EventModel>[].obs;

  bool get isLoading => _isLoading.value;
  EventModel? get currentEvent => _currentEvent.value;
  List<EventModel> get pendingEvents => _pendingEvents;
  List<EventModel> get inProgressEvents => _inProgressEvents;
  List<EventModel> get completedEvents => _completedEvents;
  List<OrderGetModel> get currentEventOrders => _currentEventOrders;
  List<EventModel> get allEventList => _allEventList;
  List<EventModel> get pendingEventList => _pendingEventList;
  List<EventModel> get inProgressEventList => _inProgressEventList;
  List<EventModel> get completedEventList => _completedEventList;

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
        return false;
      }
    } catch (e) {
      print('Error creating event: $e');
      return null;
    } finally {
      _isLoading.value = false;
    }
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

  Future<void> fetchPendingEvents({
    required int page,
    required int size,
    required String search,
    required EventFilters filters,
  }) async {
    try {
      final response = await eventRepo.getFilteredEvents(
        page,
        size,
        search,
        filters.copyWith(status: ['PENDING']),
      );
      if (response.statusCode == 200) {
        List<EventModel> events = (response.body as List<dynamic>)
            .map((event) => EventModel.fromJson(event as Map<String, dynamic>))
            .toList();
        if (page == 0) {
          _pendingEvents.value = events;
        } else {
          _pendingEvents.addAll(events);
        }
        _pendingEventsController.add(_pendingEvents);
      } else {
        throw Exception('Failed to load pending events');
      }
    } catch (e) {
      print('Error fetching pending events: $e');
    }
  }

  Future<void> fetchInProgressEvents({
    required int page,
    required int size,
    required String search,
    required EventFilters filters,
  }) async {
    try {
      final response = await eventRepo.getFilteredEvents(
        page,
        size,
        search,
        filters.copyWith(status: ['IN_PROGRESS']),
      );
      if (response.statusCode == 200) {
        List<EventModel> events = (response.body as List<dynamic>)
            .map((event) => EventModel.fromJson(event as Map<String, dynamic>))
            .toList();
        if (page == 0) {
          _inProgressEvents.value = events;
        } else {
          _inProgressEvents.addAll(events);
        }
        _inProgressEventsController.add(_inProgressEvents);
      } else {
        throw Exception('Failed to load in-progress events');
      }
    } catch (e) {
      print('Error fetching in-progress events: $e');
    }
  }

  Future<void> fetchCompletedEvents({
    required int page,
    required int size,
    required String search,
    required EventFilters filters,
  }) async {
    try {
      final response = await eventRepo.getFilteredEvents(
        page,
        size,
        search,
        filters.copyWith(status: ['COMPLETED']),
      );
      if (response.statusCode == 200) {
        List<EventModel> events = (response.body as List<dynamic>)
            .map((event) => EventModel.fromJson(event as Map<String, dynamic>))
            .toList();
        if (events.isNotEmpty) {
          if (page == 0) {
            print("Completed event title" + events.first.title!);
            _completedEvents.value = events;
          } else {
            _completedEvents.addAll(events);
          }
          _completedEventsController.add(_completedEvents);
        } else {
          print('No completed events found');
        }
      } else {
        throw Exception('Failed to load completed events');
      }
    } catch (e) {
      print('Error fetching completed events: $e');
    }
  }

  void clearAllEvents() {
    _pendingEventList.clear();
    _inProgressEventList.clear();
    _completedEventList.clear();
  }

  Future<List<EventModel>> getAllFilteredEvents({
    required int page,
    required int size,
    required String status,
    required String type,
    String? search,
  }) async {
    try {
      _isLoading.value = true;

      Response response = await eventRepo.getFilteredEvents(
          page,
          size,
          search ?? '',
          EventFilters(
              eventType: 'ALL', status: [status], timeFilter: 'THIS_WEEK'));
      List<EventModel> newEvents = (response.body as List<dynamic>)
          .map((event) => EventModel.fromJson(event as Map<String, dynamic>))
          .toList();
      print(2.1);
      if (page == 0) {
        if (status == "PENDING") {
          _pendingEventList.clear();
        } else if (status == "IN_PROGRESS") {
          _inProgressEventList.clear();
        } else if (status == "COMPLETED") {
          _completedEventList.clear();
        }
        _allEventList.clear();
      }
      print(2.2);
      if (status == "PENDING") {
        _pendingEventList.addAll(newEvents);
      } else if (status == "IN_PROGRESS") {
        _inProgressEventList.addAll(newEvents);
      } else if (status == "COMPLETED") {
        _completedEventList.addAll(newEvents);
      }
      _allEventList.addAll(newEvents);
      print("GETTING ALL ORDERS" + newEvents.length.toString());
      print(2.3);
      return newEvents;
    } catch (e) {
      print(2.4);
      print('Error fetching orders: $e');
      return [];
    } finally {
      _isLoading.value = false;
    }
  }

  // Updated fetchFilteredEvents method
  Future<void> fetchFilteredEvents({
    required int page,
    required int size,
    required String search,
    required EventFilters filters,
  }) async {
    try {
      if (filters.status.contains('PENDING') || filters.status.isEmpty) {
        await fetchPendingEvents(
            page: page, size: size, search: search, filters: filters);
      }
      if (filters.status.contains('IN_PROGRESS') || filters.status.isEmpty) {
        await fetchInProgressEvents(
            page: page, size: size, search: search, filters: filters);
      }
      if (filters.status.contains('COMPLETED') || filters.status.isEmpty) {
        await fetchCompletedEvents(
            page: page, size: size, search: search, filters: filters);
      }
    } catch (e) {
      print('Error fetching filtered events: $e');
    }
  }

  // Method to handle WebSocket messages
  void onWebSocketMessage(
      String status, int page, int size, String search, EventFilters filters) {
    switch (status) {
      case 'PENDING':
        fetchPendingEvents(
            page: page, size: size, search: search, filters: filters);
        break;
      case 'IN_PROGRESS':
        fetchInProgressEvents(
            page: page, size: size, search: search, filters: filters);
        break;
      case 'COMPLETED':
        fetchCompletedEvents(
            page: page, size: size, search: search, filters: filters);
        break;
      default:
        fetchFilteredEvents(
            page: page, size: size, search: search, filters: filters);
    }
  }

  @override
  void onClose() {
    _pendingEventsController.close();
    _inProgressEventsController.close();
    _completedEventsController.close();
    super.onClose();
  }

  //Getting pending events
  Future<List<EventModel>> fetchPendingEvents2(String eventType) async {
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
  Future<List<EventModel>> fetchInProgressEvents2(String eventType) async {
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

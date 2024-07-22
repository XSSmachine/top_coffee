
import 'dart:convert';

import 'package:get/get.dart';
import 'package:team_coffee/models/event_status_model.dart';

import '../data/repository/auth_repo.dart';
import '../data/repository/event_repo.dart';
import '../data/repository/order_repo.dart';
import '../data/repository/user_repo.dart';
import '../models/event+order.dart';
import '../models/event_body_model.dart';
import '../models/event_model.dart';
import '../models/order_get_model.dart';
import '../models/order_model.dart';
import '../models/response_model.dart';
import '../models/signup_body_model.dart';

import 'package:get/get.dart';

import '../models/user_model.dart';


class EventController extends GetxController implements GetxService {
  final EventRepo eventRepo;
  final OrderRepo orderRepo;
  final UserRepo userRepo;

  EventController({
    required this.eventRepo,
    required this.orderRepo,
    required this.userRepo,
  });

  final Rx<bool> _isLoading = false.obs;
  final Rx<EventModel?> _currentEvent = Rx<EventModel?>(null);
  final RxList<EventStatusModel> _pendingEvents = <EventStatusModel>[].obs;
  final RxList<EventStatusModel> _inProgressEvents = <EventStatusModel>[].obs;
  final RxList<OrderGetModel> _currentEventOrders = <OrderGetModel>[].obs;

  bool get isLoading => _isLoading.value;
  EventModel? get currentEvent => _currentEvent.value;
  List<EventStatusModel> get pendingEvents => _pendingEvents;
  List<EventStatusModel> get inProgressEvents => _inProgressEvents;
  List<OrderGetModel> get currentEventOrders => _currentEventOrders;

  //Method for fetching event details about users and orders they made
  Future<Event> getEventDetails(String eventId) async {
    _isLoading.value = true;
    try {
      print(0);
      final eventStatus = await eventRepo.getEventById(eventId);
      print(0.5);
      final creatorName = await userRepo.getUserById(eventStatus.creator);
      print(1);
      final orders = await orderRepo.getAllOrdersForEvent(eventId);
      print(2);
      final allOrders = await orderRepo.getAllOrders();
      List<Future<String>> participantNamesFutures = allOrders
          .where((order) => eventStatus.orders.contains(order.id)) // Filter orders first
          .map<Future<String>>((order) async { // Then map to get user details
        UserModel user = await userRepo.getUserById(order.userId);
        return "${user.name} ${user.surname}";
      }).toList();
      print(2.5);

      // Wait for all futures to complete
      List<String> participants = await Future.wait(participantNamesFutures);
      print(3);
      final event = Event(
        id: eventStatus.id?? "ERROR",
        creatorId: eventStatus.creator,
          creatorName: "${creatorName.name} ${creatorName.surname}",
        status: eventStatus.status??"ERROR",
        startTime: calculateRemainingTimeInRoundedMinutes(eventStatus.startTIme!,eventStatus.pendingTime),
        participants: participants,
        orders: orders.map((order) => Order(
          userId: order.id!,
          coffeeType: order.type ?? "",
          milkQuantity: order.milkQuantity ?? 0,
          sugarQuantity: order.sugarQuantity ?? 0,
          rating: null,
        )).toList()

      );

      return event;
    } catch (e) {
      print('Error fetching event details: $e');
      throw e;
    } finally {
      _isLoading.value = false;
    }
  }

  int calculateRemainingTimeInRoundedMinutes(String ISO, int pendingTime) {
    // Parse the start time, assuming it's not null
    DateTime startTime = DateTime.parse(ISO);

    // Get the current time
    DateTime now = DateTime.now();
    print("Time im getting locally ------ "+now.toString());
    print("Time im getting from server ------ "+startTime.toString());
    // Calculate the elapsed time since the event started
    Duration elapsedTime = now.difference(startTime);

    int elapsedTimeSeconds = elapsedTime.inSeconds-(120*60);
    // Calculate the remaining time in seconds
    int remainingSeconds = (pendingTime*60)-(elapsedTimeSeconds+(pendingTime*60));

    // Convert seconds to minutes and round up
    //int remainingMinutes = (remainingSeconds) ~/ 60; // Adding 59 seconds before integer division to round up

    int timerTime = remainingSeconds + 120*60 + pendingTime*60;
    print("remainding seconds   "+remainingSeconds.toString());
    // Return the remaining rounded minutes
    return remainingSeconds;
  }

  //Method for creating event
  Future<bool?> createEvent(EventBody eventBody) async {
    _isLoading.value = true;
    try {
      final response = await eventRepo.createEvent(eventBody);
      if (response.statusCode == 200 || response.statusCode == 201) {
        if (response.body != null) {
          await eventRepo.saveEventID(response.body);
          return true; // Event created successfully
        }
      } else if (response.statusCode == 400) {
        return null; // Signal to show snackbar message
      }
    } catch (e) {
      print('Error creating event: $e');
    } finally {
      _isLoading.value = false;
    }
    return false; // Event creation failed
  }


  //Getting pending events
  Future<List<Event>> fetchPendingEvents() async {
    _isLoading.value = true;
    try {
      final eventStatusModels = await eventRepo.getPendingEvents();
      List<Event> events = await _fetchEventDetailsForStatusModels(eventStatusModels);
      print("PENDING........"+events.length.toString());
      //_pendingEvents.assignAll(events);
      return events;
    } catch (e) {
      print('Error fetching pending events: $e');
      throw e;
    } finally {
      _isLoading.value = false;
    }
  }

  //Getting in_progress events
  Future<List<Event>> fetchInProgressEvents() async {
    _isLoading.value = true;
    try {
      final eventStatusModels = await eventRepo.getInProgressEvents();
      List<Event> events = await _fetchEventDetailsForStatusModels(eventStatusModels);
      //_inProgressEvents.assignAll(events);
      return events;
    } catch (e) {
      print('Error fetching in-progress events: $e');
      throw e;
    } finally {
      _isLoading.value = false;
    }
  }

  //Getting completed events
  Future<List<Event>> fetchCompleteEvents() async {
    _isLoading.value = true;
    try {
      final eventStatusModels = await eventRepo.getCompleteEvents();
      List<Event> events = await _fetchEventDetailsForStatusModels(eventStatusModels);
      //_inProgressEvents.assignAll(events); // This should probably be _completedEvents
      return events;
    } catch (e) {
      print('Error fetching completed events: $e');
      throw e;
    } finally {
      _isLoading.value = false;
    }
  }

  Future<List<Event>> _fetchEventDetailsForStatusModels(List<EventStatusModel> models) async {
    List<Future<Event>> eventFutures = models.map((model) => getEventDetails(model.id!)).toList();
    List<Event> events = await Future.wait(eventFutures);
    return events;
  }


  //Method for fetching all orders from single event
  Future<void> fetchEventOrders(String eventId) async {
    try {
      final orders = await orderRepo.getAllOrdersForEvent(eventId);
      _currentEventOrders.assignAll(orders);
    } catch (e) {
      print('Error fetching event orders: $e');
    }
  }


  Future<EventModel> getEventById(String eventId) async {
    try {
      final orders = await eventRepo.getEventById(eventId);
      return orders;
    } catch (e) {
      print('Error fetching event orders: $e');
      return EventModel(creator: null);
    }
  }



  //Method for changing event status into "COMPLETED"
  Future<void> finishEvent() async {
    if (_currentEvent.value == null) return;

    _isLoading.value = true;
    try {
      final response = await eventRepo.finishEvent(_currentEvent.value!.creator);
      if (response.statusCode == 200) {
        _currentEvent.value = null;
        eventRepo.removeEventID();
        await fetchInProgressEvents();
      }
    } catch (e) {
      print('Error finishing event: $e');
    } finally {
      _isLoading.value = false;
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
        await userRepo.getUserById(order.id!);
      }
    } catch (e) {
      print('Error fetching order users: $e');
    }
  }

  String? getEventIDFromPrefs() {
    return eventRepo.getEventIdFromSharedPref();
  }

  // Optionally, you can also add a getter for easier access
  String? get cachedUserId => getEventIDFromPrefs();
}
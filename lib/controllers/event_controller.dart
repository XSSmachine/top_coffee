import 'package:get/get.dart';
import 'package:team_coffee/base/show_custom_snackbar.dart';

import '../data/repository/event_repo.dart';
import '../data/repository/order_repo.dart';
import '../data/repository/user_repo.dart';
import '../models/event_body_model.dart';
import '../models/event_model.dart';
import '../models/order_get_model.dart';

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
  final RxList<EventModel> _pendingEvents = <EventModel>[].obs;
  final RxList<EventModel> _inProgressEvents = <EventModel>[].obs;
  final RxList<OrderGetModel> _currentEventOrders = <OrderGetModel>[].obs;

  bool get isLoading => _isLoading.value;
  EventModel? get currentEvent => _currentEvent.value;
  List<EventModel> get pendingEvents => _pendingEvents;
  List<EventModel> get inProgressEvents => _inProgressEvents;
  List<OrderGetModel> get currentEventOrders => _currentEventOrders;

  RxString selectedEventType = "MIX".obs;

  double calculateRemainingTimeInRoundedMinutes(String ISO,
      {Duration eventDuration = const Duration(hours: 1)}) {
    // Parse the start time
    DateTime startTime = DateTime.parse(ISO);

    // Get the current time
    DateTime now = DateTime.now();

    // Calculate the remaining time
    Duration remainingTime = startTime.difference(now);

    // Convert to minutes and round
    double remainingMinutes = (remainingTime.inSeconds / 60);

    // If remaining time is negative, return 0
    return remainingMinutes > 0 ? remainingMinutes : 0;
  }

  //Method for creating event
  Future<bool?> createEvent(EventBody eventBody) async {
    _isLoading.value = true;
    try {
      print(1);
      final response = await eventRepo.createEvent(eventBody);
      print(2);
      if (response.statusCode == 200 || response.statusCode == 201) {
        if (response.body != null) {
          print(3);
          return true; // Event created successfully
        }
      } else if (response.statusCode == 400) {
        showCustomSnackBar("Error 400"); // Signal to show snackbar message
      }
    } catch (e) {
      print('Error creating event: $e');
    } finally {
      _isLoading.value = false;
    }
    return false; // Event creation failed
  }

  //Method for changing event status into "COMPLETED"
  Future<bool?> updateEvent(String eventId, String status) async {
    _isLoading.value = true;
    try {
      final response = await eventRepo.updateEvent(eventId, status);
      if (response.statusCode == 200 || response.statusCode == 201) {
        if (response.body != null) {
          return true; // Event created successfully
        }
      } else if (response.statusCode == 400) {
        showCustomSnackBar("Error 400"); // Signal to show snackbar message
      }
    } catch (e) {
      print('Error creating event: $e');
    } finally {
      _isLoading.value = false;
    }
    return false; // Event creation failed
  }

  void updateSelectedEventType(String newType) {
    selectedEventType.value = newType;
    fetchPendingEvents(newType);
    //fetchInProgressEvents(newType);
    update();
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

      _inProgressEvents.assignAll(events);
      return events;
    } catch (e) {
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

  Future<EventModel> getActiveEvent() async {
    try {
      final orders = await eventRepo.getMyActiveEvent();
      return orders;
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
}

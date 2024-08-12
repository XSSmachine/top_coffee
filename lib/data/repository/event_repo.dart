import 'dart:core';
import 'package:get/get_connect/http/src/response/response.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:team_coffee/models/event_body_model.dart';
import 'package:get/get.dart';
import '../../models/event_model.dart';
import '../../utils/app_constants.dart';
import '../api/api_client.dart';

class EventRepo {
  final ApiClient apiClient;
  final SharedPreferences sharedPreferences;

  EventRepo({required this.sharedPreferences, required this.apiClient});

  // Create event and save event id in shared pref
  Future<Response> createEvent(EventBody eventBody) async {
    final response = await apiClient.postData(
        AppConstants.EVENT_CREATE_URI, eventBody.toJson());
    if (response.statusCode == 200 || response.statusCode == 201) {
      final responseBody = response.body;
      print("TEST$responseBody");
    } else {
      print(response.statusCode);
    }
    return response;
  }

  Future<Response> updateEvent(String eventId, String status) async {
    final response = await apiClient.patchData(
        AppConstants.GET_EVENT_URI + '/update?eventId=$eventId&status=$status',
        "");
    if (response.statusCode == 200 || response.statusCode == 201) {
      final responseBody = response.body;
      print("TEST$responseBody");
    } else {
      print(response.statusCode);
    }
    return response;
  }

  // Get all events in pending and display accept/deny container or in_progress currently brewing container
  Future<List<EventModel>> getPendingEvents(String eventType) async {
    return await _getEventsBy('PENDING', eventType);
  }

  Future<List<EventModel>> getInProgressEvents(String eventType) async {
    return await _getEventsBy('IN_PROGRESS', eventType);
  }

  Future<List<EventModel>> getCompleteEvents(String eventType) async {
    return await _getEventsBy('COMPLETED', eventType);
  }

  Future<List<EventModel>> _getEventsBy(String status, String eventType) async {
    const String url = '${AppConstants.GET_EVENT_URI}/filter';
    final json = {
      "status": status,
      "eventType": eventType,
    };
    final response = await apiClient.postData(url, json);

    if (response.statusCode == 200) {
      final List<dynamic> eventsJson = response.body;
      return eventsJson.map((json) => EventModel.fromJson(json)).toList();
    } else {
      print(response.statusCode);
      print(response.body);
      throw Exception('Failed to load $status events');
    }
  }

  // Get event id from shared pref

  Future<EventModel> getEventById(String eventId) async {
    try {
      final response =
          await apiClient.getData('${AppConstants.GET_EVENT_URI}/$eventId');
      //final orderData = json.decode(response.body);
      return EventModel.fromJson(response.body);
    } catch (e) {
      throw Exception('Failed to get order: $e');
    }
  }

  Future<EventModel> getMyActiveEvent() async {
    try {
      final response =
          await apiClient.getData('${AppConstants.GET_EVENT_URI}/active');
      //final orderData = json.decode(response.body);
      return EventModel.fromJson(response.body);
    } catch (e) {
      throw Exception('Failed to get order: $e');
    }
  }
}

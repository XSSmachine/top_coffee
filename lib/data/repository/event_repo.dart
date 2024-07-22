import 'dart:convert';
import 'dart:core';
import 'package:get/get_connect/http/src/response/response.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:team_coffee/models/event_body_model.dart';
import 'package:get/get.dart';
import '../../models/event_model.dart';
import '../../models/event_status_model.dart';
import '../../models/order_model.dart';
import '../../utils/app_constants.dart';
import '../api/api_client.dart';

class EventRepo {
  final ApiClient apiClient;
  final SharedPreferences sharedPreferences;

  EventRepo({
    required this.sharedPreferences,
    required this.apiClient
  });

  // Create event and save event id in shared pref
  Future<Response> createEvent(EventBody eventBody) async {
    final response = await apiClient.postData(AppConstants.EVENT_CREATE_URI, eventBody.toJson());
    if (response.statusCode == 200 || response.statusCode == 201) {
      final responseBody = response.body;
      print("TEST"+responseBody.toString());
      if (responseBody != null) {
        await saveEventID(responseBody);
      }
    }
    return response;
  }

  // Get all events in pending and display accept/deny container or in_progress currently brewing container
  Future<List<EventStatusModel>> getPendingEvents() async {
    return await _getEventsByStatus('PENDING');
  }

  Future<List<EventStatusModel>> getInProgressEvents() async {
    return await _getEventsByStatus('IN_PROGRESS');
  }

  Future<List<EventStatusModel>> getCompleteEvents() async {
    return await _getEventsByStatus('COMPLETED');
  }

  Future<List<EventStatusModel>> _getEventsByStatus(String status) async {
    final String url = '${AppConstants.EVENTS_URI}?status=$status';
    final response = await apiClient.getData(url);

    if (response.statusCode == 200) {
      final List<dynamic> eventsJson = response.body;
      return eventsJson.map((json) => EventStatusModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load $status events');
    }
  }

  // Get event id from shared pref
  String? getEventIdFromSharedPref() {
    return sharedPreferences.getString(AppConstants.EVENT_ID);
  }

  Future<EventModel> getEventById(String eventId) async {
    try {
      final response = await apiClient.getData('${AppConstants.EVENTS_URI}/$eventId');
      //final orderData = json.decode(response.body);
      return EventModel.fromJson(response.body);
    } catch (e) {
      throw Exception('Failed to get order: $e');
    }
  }

  Future<Response> finishEvent(String creatorId) async {
    var userId = sharedPreferences.getString(AppConstants.USER_ID);
    if (userId == null) {
      throw Exception('User ID not found in SharedPreferences');
    }
    Response response = await apiClient.patchData(AppConstants.EVENT_FINISH_URI, {"creatorId": userId});
    return response;
  }

  Future<bool> saveEventID(String eventId) async {
     apiClient.userId = eventId;
    return await sharedPreferences.setString(AppConstants.EVENT_ID, eventId);
  }

  void removeEventID() {
    sharedPreferences.remove(AppConstants.EVENT_ID);
  }
}
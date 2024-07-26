import 'dart:convert';

import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:team_coffee/models/order_body_model.dart';
import 'package:team_coffee/models/order_body_rating_model.dart';

import '../../models/event_model.dart';
import '../../models/order_get_model.dart';
import '../../models/order_model.dart';
import '../../utils/app_constants.dart';
import '../api/api_client.dart';

class OrderRepo {
  final ApiClient apiClient;
  final SharedPreferences sharedPreferences;

  OrderRepo({required this.apiClient,required this.sharedPreferences});

  // Get all orders for an event
  Future<List<OrderGetModel>> getAllOrdersForEvent(String eventId) async {
    if (eventId == null) {
      throw Exception('Invalid event ID: event ID is null');
    }
    try {
      final eventResponse = await apiClient.getData('${AppConstants.EVENT_ID}/$eventId');
      if (eventResponse.body == null) {
        throw Exception('No data received for event ID: $eventId');
      }
      final eventData = jsonDecode(jsonEncode(eventResponse.body));
      EventModel eventModel = EventModel.fromJson(eventData);

      List<OrderGetModel> orders = [];
      for (String orderId in eventModel.orders) {
        if (orderId == null) {
          continue; // Skip null order IDs
        }
        OrderGetModel order = await getSingleOrder(orderId);
        orders.add(order);
      }

      return orders;
    } catch (e) {
      throw Exception('Failed to get orders for event: $e');
    }
  }



  // Create new order and add it to event
  Future<Response> createOrder(OrderBody orderBody) async {
    try {
      final response = await apiClient.postData(AppConstants.ORDER_CREATE_URI, orderBody);

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Assuming the response body is in JSON format
        final responseBody = json.decode(response.body);

        // Assuming the user ID is in the response with the key 'userId'
        // Adjust this key based on your actual API response structure
        if (responseBody['userId'] != null) {
          String orderId = responseBody['userId'];

          // Save the user ID to SharedPreferences
          await sharedPreferences.setString(AppConstants.ORDER_ID, orderId);
        }
      }

      return response;
    } catch (e) {
      throw Exception('Failed to create order: $e');
    }
  }

  // Get single order by id
  Future<OrderGetModel> getSingleOrder(String orderId) async {
    if (orderId == null) {
      throw Exception('Invalid order ID: order ID is null');
    }
    try {
      final response = await apiClient.getData('${AppConstants.ALL_ORDERS_URI}/$orderId');
      if (response.body == null) {
        throw Exception('No data received for order ID: $orderId');
      }
      final orderData = response.body;
      return OrderGetModel.fromJson(orderData);
    } catch (e) {
      throw Exception('Failed to get order: $e');
    }
  }
  // Patch RATE order
  Future<Response> rateOrder(OrderBodyRating rating) async {
    return await apiClient.patchData(AppConstants.ORDER_ID, rating);
  }

  Future<List<OrderModel>> getAllOrders() async {
    try {
      final response = await apiClient.getData(AppConstants.ALL_ORDERS_URI);
      if (response.body == null) {
        throw Exception('No data received');
      }
      // Assuming the response body is a JSON array of orders
      List<dynamic> orderList = response.body;
      List<OrderModel> orders = orderList.map((orderJson) => OrderModel.fromJson(orderJson)).toList();
      return orders;
    } catch (e) {
      throw Exception('Failed to get all orders: $e');
    }
  }



}
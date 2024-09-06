import 'dart:convert';

import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:team_coffee/models/my_orders_model.dart';
import 'package:team_coffee/models/order_body_model.dart';
import '../../models/monthly_summary.dart';
import '../../models/order_get_model.dart';
import '../../models/order_model.dart';
import '../../utils/app_constants.dart';
import '../api/api_client.dart';

class OrderRepo {
  final ApiClient apiClient;
  final SharedPreferences sharedPreferences;

  OrderRepo({required this.apiClient, required this.sharedPreferences});

  final Map<String, String> labelTranslations = {
    'SVE': 'ALL',
    'KAVA': 'COFFEE',
    'HRANA': 'FOOD',
    'PIĆE': 'BEVERAGE',
  };

  // Create new order and add it to event
  Future<Response> createOrder(OrderBody orderBody) async {
    try {
      final response = await apiClient.postData(
          AppConstants.ORDER_CREATE_URI, orderBody.toJson());

      if (response.statusCode == 200 || response.statusCode == 201) {
        return response;
      } else {
        return response;
      }
    } catch (e) {
      throw Exception('Failed to create order: $e');
    }
  }

  Future<Response> updateSingleOrder(String orderId, String status) async {
    try {
      final response = await apiClient.patchData(
          AppConstants.ALL_ORDERS_URI +
              '/update?orderId=$orderId&status=$status',
          "");

      if (response.statusCode == 200 || response.statusCode == 201) {
        return response;
      } else {
        print(response.statusCode);
        return response;
      }
    } catch (e) {
      throw Exception('Failed to create order: $e');
    }
  }

  Future<Response> rateSingleOrder(String orderId, int rating) async {
    try {
      final response = await apiClient.patchData(
          AppConstants.ALL_ORDERS_URI + '/rate?orderId=$orderId&rating=$rating',
          "");

      if (response.statusCode == 200 || response.statusCode == 201) {
        return response;
      } else {
        print(response.statusCode);
        return response;
      }
    } catch (e) {
      throw Exception('Failed to create order: $e');
    }
  }

  Future<Response> updateAllOrders(String eventId, String status) async {
    try {
      final response = await apiClient.patchData(
          AppConstants.ALL_ORDERS_URI +
              '/update/all?eventId=$eventId&status=$status',
          "");

      if (response.statusCode == 200 || response.statusCode == 201) {
        return response;
      } else {
        print(response.statusCode);
        return response;
      }
    } catch (e) {
      throw Exception('Failed to create order: $e');
    }
  }

  // Get single order by id
  Future<OrderGetModel> getSingleOrder(String orderId) async {
    try {
      final response =
          await apiClient.getData('${AppConstants.ALL_ORDERS_URI}/$orderId');
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

  Future<MyOrdersModel> getAllOrdersForMyEvent(String eventId) async {
    try {
      final response = await apiClient
          .getData(AppConstants.ALL_ORDERS_URI + '/event/' + eventId);
      if (response.body == null) {
        throw Exception('No data received');
      }
      // Assuming the response body is a JSON array of orders
      final myOrdersModel = MyOrdersModel.fromJson(response.body);
      return myOrdersModel;
    } catch (e) {
      throw Exception('Failed to get all orders: $e');
    }
  }

  Future<List<OrderModel>> getAllMyOrdersByStatus(bool isActive) async {
    try {
      print(isActive.toString());
      final response = await apiClient.postData(
          "${AppConstants.ALL_ORDERS_URI}/activity?isActive=$isActive", "");
      if (response.body == null) {
        throw Exception('No data received');
      }
      // Assuming the response body is a JSON array of orders
      List<dynamic> orderList = response.body;
      List<OrderModel> orders =
          orderList.map((orderJson) => OrderModel.fromJson(orderJson)).toList();
      return orders;
    } catch (e) {
      throw Exception('Failed to get all orders: $e');
    }
  }

  Future<List<OrderModel>> getFilteredOrders(
      {int? page,
      int? size,
      String? status,
      String? rating,
      String? type,
      String? search}) async {
    try {
      print('${labelTranslations[type] ?? type}');
      final response = await apiClient.getData(
          "${AppConstants.ALL_ORDERS_URI}/all?page=$page&size=$size&rating=$rating&status=$status&search=$search&eventType=${labelTranslations[type] ?? type}");
      if (response.body == null) {
        throw Exception('No data received');
      }

      List<dynamic> orderList;
      if (response.body is List) {
        print("lista");
        orderList = response.body;
      } else if (response.body is Map) {
        print("mapa");
        // Extract the list of orders from the JSON object
        print(response.body.toString());
        orderList = response.body[""] ?? [];
      } else {
        throw Exception('Unexpected response format');
      }

      List<OrderModel> orders =
          orderList.map((orderJson) => OrderModel.fromJson(orderJson)).toList();
      return orders;
    } catch (e) {
      throw Exception('Failed to get all orders: $e');
    }
  }

  Future<List<MonthlySummary>> fetchOrdersStats() async {
    final response =
        await apiClient.getData("${AppConstants.MONTHLY_STATS}/orders");
    if (response.statusCode == 200) {
      List<dynamic> jsonData = response.body;
      return jsonData.map((data) => MonthlySummary.fromJson(data)).toList();
    } else {
      throw Exception('Failed to load orders stats data');
    }
  }

  Future<Response> fetchOrderPieData() async {
    try {
      final response = await apiClient.getData(AppConstants.ORDERS_STATS);
      if (response.statusCode == 200) {
        return response;
      } else {
        throw Exception('Failed to load data: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching data: $e');
      throw Exception('Failed to fetch order data: $e');
    }
  }
}

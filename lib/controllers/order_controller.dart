import 'dart:convert';

import 'package:get/get.dart';
import '../data/repository/order_repo.dart';
import '../models/my_orders_model.dart';
import '../models/order_body_model.dart';
import '../models/order_get_model.dart';
import '../models/order_model.dart';
import '../models/response_model.dart';

class OrderController extends GetxController implements GetxService {
  final OrderRepo orderRepo;

  OrderController({required this.orderRepo});

  final RxBool _isLoading = false.obs;
  final Rx<OrderGetModel?> _currentOrder = Rx<OrderGetModel?>(null);
  final RxList<MyOrder> _eventOrders = <MyOrder>[].obs;

  final RxList<OrderModel> _allOrders = <OrderModel>[].obs;
  final RxList<OrderModel> _activeOrders = <OrderModel>[].obs;
  final RxList<OrderModel> _completedOrders = <OrderModel>[].obs;

  bool get isLoading => _isLoading.value;
  OrderGetModel? get currentOrder => _currentOrder.value;
  List<MyOrder> get eventOrders => _eventOrders;

  List<OrderModel> get allOrders => _allOrders;
  List<OrderModel> get activeOrders => _activeOrders;
  List<OrderModel> get completedOrders => _completedOrders;

  void resetAllValues() {
    _currentOrder.value = null;
    _eventOrders.clear();
    _allOrders.clear();
    _activeOrders.clear();
    _completedOrders.clear();
    _isLoading.value = false;
  }

  //Method for creating new order in db
  Future<ResponseModel> createOrder(OrderBody orderBody) async {
    _isLoading.value = true;
    late ResponseModel responseModel;
    try {
      final response = await orderRepo.createOrder(orderBody);
      if (response.statusCode == 200 || response.statusCode == 201) {
        final String responseBody = response.body.toString();
        print("Creating new order was successful! + $responseBody.");
        return responseModel = ResponseModel(true, responseBody);
      } else {
        print(response.statusCode);
        return responseModel =
            ResponseModel(false, response.statusCode.toString());
      }
    } catch (e) {
      print('Error creating order: $e');
      return responseModel = ResponseModel(false, e.toString());
    } finally {
      _isLoading.value = false;
    }
  }

  Future<ResponseModel> rateOrder(String orderId, int rating) async {
    _isLoading.value = true;
    late ResponseModel responseModel;
    try {
      final response = await orderRepo.rateSingleOrder(orderId, rating);
      if (response.statusCode == 200 || response.statusCode == 201) {
        final String responseBody = response.body.toString();
        print("Creating new order was successful! + $responseBody.");
        return responseModel = ResponseModel(true, responseBody);
      } else {
        print(response.statusCode);
        return responseModel =
            ResponseModel(false, response.statusCode.toString());
      }
    } catch (e) {
      throw Exception('Failed to create order: $e');
      return responseModel = ResponseModel(false, e.toString());
    } finally {
      _isLoading.value = false;
    }
  }

  //Method for fetching all orders for same event
  Future<List<MyOrder>> getAllOrdersForMyEvent(String eventId) async {
    _isLoading.value = true;
    try {
      final orders = await orderRepo.getAllOrdersForMyEvent(eventId);
      _eventOrders.assignAll(orders.orders);
      return eventOrders;
    } catch (e) {
      print('Error fetching orders for event: $e');
      return eventOrders;
    } finally {
      _isLoading.value = false;
    }
  }

  //Getting all orders in the db
  Future<List<OrderModel>> getAllOrders() async {
    _isLoading.value = true;
    try {
      //final List<OrderModel>orders = await orderRepo.getAllOrders();
      //_allOrders.assignAll(orders);
      return allOrders;
    } catch (e) {
      print('Error fetching orders for event: $e');
      return allOrders;
    } finally {
      _isLoading.value = false;
    }
  }

  Future<List<OrderModel>> getAllMyOrdersByStatus(bool isActive) async {
    _isLoading.value = true;
    try {
      final List<OrderModel> orders =
          await orderRepo.getAllMyOrdersByStatus(isActive);
      if (isActive) {
        _activeOrders.assignAll(orders);
        return activeOrders;
      } else {
        _completedOrders.assignAll(orders);
        return completedOrders;
      }
    } catch (e) {
      print('Error fetching orders for event: $e');
      if (isActive) {
        return activeOrders;
      } else {
        return completedOrders;
      }
    } finally {
      _isLoading.value = false;
    }
  }

  //getting single order by ID
  Future<void> getSingleOrder(String orderId) async {
    _isLoading.value = true;
    try {
      final order = await orderRepo.getSingleOrder(orderId);
      _currentOrder.value = order;
    } catch (e) {
      print('Error fetching single order: $e');
    } finally {
      _isLoading.value = false;
    }
  }

  Future<void> updateOrderStatus(String orderId, String status) async {
    try {
      print(
          'Attempting to update order status: OrderID=$orderId, NewStatus=$status');

      // Assuming orderRepo.updateSingleOrder returns a response
      final response = await orderRepo.updateSingleOrder(orderId, status);

      // Check if the response indicates success (you might need to adjust this based on your actual response structure)
      if (response.isOk) {
        print(
            'Order status updated successfully: OrderID=$orderId, NewStatus=$status');
      } else {
        print(
            'Failed to update order status: OrderID=$orderId, NewStatus=$status');
        print('Error: ${response.body}');
        throw Exception('Failed to update order status: ${response.body}');
      }
    } catch (e) {
      print('Error occurred while updating order status: $e');
      print('OrderID=$orderId, AttemptedNewStatus=$status');
      throw Exception('Error updating order status: $e');
    }
  }

//Patch method for defining order rating

  //Accessing orderID from shared prefs
}

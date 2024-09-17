import 'dart:convert';

import 'package:get/get.dart';
import '../data/repository/order_repo.dart';
import '../models/monthly_summary.dart';
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
  final RxList<OrderModel> _cancelledOrders = <OrderModel>[].obs;

  bool get isLoading => _isLoading.value;
  OrderGetModel? get currentOrder => _currentOrder.value;
  List<MyOrder> get eventOrders => _eventOrders;

  List<OrderModel> get allOrders => _allOrders;
  List<OrderModel> get activeOrders => _activeOrders;
  List<OrderModel> get completedOrders => _completedOrders;
  List<OrderModel> get cancelledOrders => _cancelledOrders;

  RxBool isActive = true.obs;
  RxBool showCurrentEvent = false.obs;
  RxInt currentPage = 0.obs;
  RxBool isLoadingScreen = false.obs;
  RxBool hasMore = true.obs;
  RxInt pageSize = 10.obs;
  RxString searchQuery = ''.obs;
  RxString filterRating = ''.obs;
  RxString filterType = ''.obs;
  RxBool showFilters = false.obs;
  RxBool showCancelledOrders = false.obs;

  RxList<String> ratingOptions = ['ANY', '1', '2', '3', '4', '5'].obs;
  RxInt currentRatingIndex = 0.obs;
  RxList<String> typeOptionsEnglish = ['ALL', 'COFFEE', 'FOOD', 'BEVERAGE'].obs;

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
      print("STATUS " + order.status!);
      print("RATING " + order.rating.toString());
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

  Future<List<OrderModel>> getFilteredOrders({
    int? page,
    int? size,
    String? status,
    String? rating,
    String? type,
    String? search,
  }) async {
    try {
      _isLoading.value = true;
      final List<OrderModel> newOrders = await orderRepo.getFilteredOrders(
        page: page,
        size: size,
        status: status,
        rating: rating,
        type: type,
        search: search,
      );
      print(2.1);
      if (page == 0) {
        _allOrders.clear();
      }
      print(2.2);
      _allOrders.addAll(newOrders);
      print("GETTING ALL ORDERS" + newOrders.length.toString());
      print(2.3);
      return newOrders;
    } catch (e) {
      print(2.4);
      print('Error fetching orders: $e');
      return [];
    } finally {
      _isLoading.value = false;
    }
  }

  List<OrderModel> filterOrdersByStatus(List<String> statuses) {
    return _allOrders
        .where((order) => statuses.contains(order.status))
        .toList();
  }

  void clearOrders() {
    _allOrders.clear();
    _activeOrders.clear();
    _completedOrders.clear();
    _cancelledOrders.clear();
  }

  Future<List<MonthlySummary>> fetchOrdersStatistics() async {
    final response = await orderRepo.fetchOrdersStats();
    if (response.isNotEmpty) {
      return response;
    } else {
      throw Exception('Failed to get orders statistic data');
    }
  }

  Future<List<dynamic>> fetchOrderPieData() async {
    try {
      final response = await orderRepo.fetchOrderPieData();
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

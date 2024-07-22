import 'dart:convert';

import 'package:get/get.dart';
import '../data/repository/order_repo.dart';
import '../models/order_body_model.dart';
import '../models/order_body_rating_model.dart';
import '../models/order_get_model.dart';
import '../models/order_model.dart';
import '../utils/app_constants.dart';

class OrderController extends GetxController implements GetxService {
  final OrderRepo orderRepo;

  OrderController({required this.orderRepo});

  //late List<OrderModel> _allOrders = <OrderModel>[].obs;
  //List<OrderModel> get allOrders => _allOrders;

  final RxBool _isLoading = false.obs;
  final Rx<OrderGetModel?> _currentOrder = Rx<OrderGetModel?>(null);
  final RxList<OrderGetModel> _eventOrders = <OrderGetModel>[].obs;

  final RxList<OrderModel> _allOrders = <OrderModel>[].obs;

  bool get isLoading => _isLoading.value;
  OrderGetModel? get currentOrder => _currentOrder.value;
  List<OrderGetModel> get eventOrders => _eventOrders;
  List<OrderModel> get allOrders => _allOrders;

  //Method for creating new order in db
  Future<void> createOrder(OrderBody orderBody) async {
    _isLoading.value = true;
    try {
      final response = await orderRepo.createOrder(orderBody);
      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseBody = json.decode(response.body);
        if (responseBody['orderId'] != null) {
          await getSingleOrder(responseBody['orderId']);
        }
      }
    } catch (e) {
      print('Error creating order: $e');
    } finally {
      _isLoading.value = false;
    }
  }

  //Method for fetching all orders for same event
  Future<List<OrderGetModel>> getAllOrdersForEvent(String eventId) async {
    _isLoading.value = true;
    try {
      final orders = await orderRepo.getAllOrdersForEvent(eventId);
      _eventOrders.assignAll(orders);
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
      final List<OrderModel>orders = await orderRepo.getAllOrders();
      _allOrders.assignAll(orders);
      return allOrders;
    } catch (e) {
      print('Error fetching orders for event: $e');
      return allOrders;
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

  //Patch method for defining order rating
  Future<void> rateOrder(OrderBodyRating rating) async {
    _isLoading.value = true;
    try {
      final response = await orderRepo.rateOrder(rating);
      if (response.statusCode == 200) {
        // Optionally, you can update the current order or refetch it
        await getSingleOrder(_currentOrder.value!.id!);
      }
    } catch (e) {
      print('Error rating order: $e');
    } finally {
      _isLoading.value = false;
    }
  }

  //Accessing orderID from shared prefs
  String? getOrderIdFromSharedPreferences() {
    return orderRepo.sharedPreferences.getString(AppConstants.ORDER_ID);
  }
}
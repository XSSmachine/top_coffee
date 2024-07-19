import 'dart:convert';

import 'package:get/get.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:team_coffee/models/user_model.dart';
import '../../utils/app_constants.dart';
import '../api/api_client.dart';

class UserRepo{
  final ApiClient apiClient;
  final SharedPreferences sharedPreferences;
  UserRepo({
    required this.apiClient,
    required this.sharedPreferences
});

  Future<Map<String, dynamic>>getUserId(String token) async {
    Map<String, dynamic> decodedToken = JwtDecoder.decode(token);

    return decodedToken;
  }

  Future<Response>getUserInfo(String userId) async {
    return await apiClient.getData(AppConstants.USER_INFO+"/$userId");
  }

  Future<bool> saveUserID(String userId) async {
    return await sharedPreferences.setString(AppConstants.USER_ID,userId);
  }

  String? getUserIDFromPrefs() {
    return sharedPreferences.getString(AppConstants.USER_ID);
  }

  Future<Response>getAllUsers() async {
    print("getting called");
    Response response = await apiClient.getData(AppConstants.USERS_URI);
    print(response.body);
    return response;
  }

  Future<UserModel> getUserById(String userId) async {
    try {
      final response = await apiClient.getData('${AppConstants.USERS_URI}/$userId');
      final orderData = response.body;
      return UserModel.fromJson(orderData);
    } catch (e) {
      throw Exception('Failed to get order: $e');
    }
  }

}
import 'dart:io';

import 'package:get/get.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:team_coffee/models/user_model.dart';
import '../../models/update_profile_model.dart';
import '../../utils/app_constants.dart';
import '../api/api_client.dart';
import 'package:http/http.dart' as http;

class UserRepo {
  final ApiClient apiClient;
  final SharedPreferences sharedPreferences;
  UserRepo({required this.apiClient, required this.sharedPreferences});

  Future<Map<String, dynamic>> getUserId(String token) async {
    Map<String, dynamic> decodedToken = JwtDecoder.decode(token);

    return decodedToken;
  }

  Future<Response> getUserInfo() async {
    return await apiClient.getData(AppConstants.FETCH_ME_URI);
  }

  Future<http.Response> getProfilePhoto() async {
    return await apiClient
        .getPhoto(AppConstants.BASE_URL + AppConstants.USER_PHOTO);
  }

  Future<http.Response> editProfile(UpdateProfileModel body,
      {File? imageFile}) async {
    return await apiClient.patchMultipart(
        AppConstants.BASE_URL + AppConstants.USER_PROFILE + "/edit", body,
        imageFile: imageFile);
  }

  Future<Response> getAllUsers() async {
    print("getting called");
    Response response = await apiClient.getData(AppConstants.USERS_URI);
    print(response.body);
    return response;
  }

  Future<Response> getGroupLeaderboard() async {
    print("leaderboard");
    Response response = await apiClient.getData(AppConstants.LEADERBOARD);
    print(response.body);
    return response;
  }

  Future<UserModel> getUserById(String userId) async {
    try {
      final response =
          await apiClient.getData('${AppConstants.USER_PROFILE}/$userId');
      final orderData = response.body;
      return UserModel.fromJson(orderData);
    } catch (e) {
      throw Exception('Failed to get order: $e');
    }
  }
}

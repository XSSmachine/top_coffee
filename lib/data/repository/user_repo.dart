import 'dart:convert';
import 'dart:io';

import 'package:get/get.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:team_coffee/models/password_change_model.dart';
import 'package:team_coffee/models/user_model.dart';
import '../../models/order_status_count.dart';
import '../../models/update_group_model.dart';
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

  Future<Response> kickUserByUserProfileId(String userProfileId) async {
    return await apiClient.deleteData(
        AppConstants.KICK_GROUP_URI + "?userProfileId=$userProfileId");
  }

  Future<Response> promoteUserByUserProfileId(
      String userProfileId, String role) async {
    print(
      AppConstants.PROMOTE_GROUP_URI +
          "?userProfileId=$userProfileId&role=$role",
    );
    return await apiClient.postData(
        AppConstants.PROMOTE_GROUP_URI +
            "?userProfileId=$userProfileId&role=$role",
        "");
  }

  Future<Response> getGroupById(String id) async {
    return await apiClient.getData(AppConstants.GROUP_URI + '/$id');
  }

  Future<Response> getUserProfileDetails(String id) async {
    return await apiClient.getData(AppConstants.USER_PROFILE + '/$id');
  }

  Future<String> getGroupId() async {
    return await sharedPreferences.getString(AppConstants.ACTIVE_GROUP) ??
        "None";
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

  Future<http.Response> editGroup(UpdateGroupModel body,
      {File? imageFile}) async {
    print("NOVO Ime grupe" + body.name);
    return await apiClient.patchMultipart2(
        AppConstants.BASE_URL + AppConstants.GROUP_URI + "/edit", body,
        imageFile: imageFile);
  }

  Future<Response> getAllUsers() async {
    print("getting called");
    Response response = await apiClient.getData(AppConstants.USERS_URI);
    print(response.body);
    return response;
  }

  Future<Response> getGroupLeaderboard(
      {required String sort, required int page, required int limit}) async {
    print("leaderboard");
    Response response = await apiClient.getData(AppConstants.LEADERBOARD +
        "?sortCondition=$sort&page=$page&size=$limit");
    print(response.body);
    return response;
  }

  Future<void> calculateScores() async {
    await apiClient.patchData(AppConstants.LEADERBOARD_SCORES, "");
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

  Future<Response> getOrderNumber() async {
    try {
      final response = await apiClient.getData('${AppConstants.ORDER_STATS}');
      return response;
    } catch (e) {
      throw Exception('Failed to get order stats: $e');
    }
  }

  Future<Response> getEventsNumber() async {
    try {
      final response = await apiClient.getData('${AppConstants.EVENTS_STATS}');
      return response;
    } catch (e) {
      throw Exception('Failed to get order stats: $e');
    }
  }

  Future<Response> changePassword(PasswordChangeModel body) async {
    return await apiClient.postData(
        AppConstants.CHANGE_PASS_URI, body.toJson());
  }

  Future<Response> getAllGroupMembers() async {
    try {
      final response =
          await apiClient.getData('${AppConstants.GROUP_URI}/members');
      return response;
    } catch (e) {
      throw Exception('Failed to get order stats: $e');
    }
  }
}

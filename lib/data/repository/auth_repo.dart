import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:team_coffee/models/group/create_group.dart';
import 'package:team_coffee/models/group/join_group.dart';
import 'package:team_coffee/models/user_profile_model.dart';
import 'package:http/http.dart' as http;
import '../../models/signup_body_model.dart';
import '../../utils/app_constants.dart';
import '../api/api_client.dart';

class AuthRepo {
  final ApiClient apiClient;
  final SharedPreferences sharedPreferences;
  AuthRepo({required this.apiClient, required this.sharedPreferences});

  Future<Response> checkEmail(String email) async {
    return await apiClient.postData(
        "${AppConstants.USERS_URI}/check?email=$email", "");
  }

  Future<Response> fetchMe() async {
    return await apiClient.getData(AppConstants.FETCH_ME_URI);
  }

  /// Methods for managing groups
  Future<Response> createGroup(CreateGroup newGroup) async {
    return await apiClient.postData(
        "${AppConstants.GROUP_URI}/create", newGroup.toJson());
  }

  Future<Response> joinGroup(JoinGroup group) async {
    return await apiClient.postData(
        "${AppConstants.GROUP_URI}/join", group.toJson());
  }

  Future<Response> getGroup(String groupId) async {
    return await apiClient.getData("${AppConstants.GROUP_URI}/$groupId");
  }

  /// Methods for managing user profile
  Future<http.Response> createProfile(UserProfileModel newProfile) async {
    return await apiClient.postMultipart(
        "${AppConstants.BASE_URL}${AppConstants.USER_PROFILE}/create",
        newProfile);
  }

  Future<Response> getProfile(String profileId) async {
    return await apiClient.getData("${AppConstants.USER_PROFILE}/$profileId");
  }

  Future<Response> registration(SignupBody signUpBody) async {
    return await apiClient.postData(
        AppConstants.REGISTRATION_URI, signUpBody.toJson());
  }

  bool userLoggedIn() {
    print(sharedPreferences.containsKey(AppConstants.TOKEN).toString());
    return sharedPreferences.containsKey(AppConstants.TOKEN);
  }

  Future<Response> login(String email, String password) async {
    return await apiClient.postData(AppConstants.LOGIN_URI, {
      "email": email,
      "password": password,
    });
  }

  /// Methods for managing userToken which i get after logging in
  Future<String> getUserToken() async {
    return sharedPreferences.getString(AppConstants.TOKEN) ?? "None";
  }

  Future<bool> saveUserToken(String token) async {
    apiClient.token = token;
    apiClient.updateHeader(token);
    return await sharedPreferences.setString(AppConstants.TOKEN, token);
  }

  /// Helper methods

  bool clearSharedData() {
    sharedPreferences.remove(AppConstants.TOKEN);
    apiClient.token = '';
    apiClient.updateHeader('');
    return true;
  }
}

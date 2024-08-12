import 'dart:async';
import 'dart:convert';

import 'package:get/get.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:team_coffee/models/group/join_group.dart';
import 'package:http/http.dart' as http;
import 'package:team_coffee/pages/auth/sign_in_page.dart';
import '../data/repository/auth_repo.dart';
import '../data/repository/user_repo.dart';
import '../models/group/create_group.dart';
import '../models/jwt_model.dart';
import '../models/response_model.dart';
import '../models/signup_body_model.dart';
import '../models/user_profile_model.dart';
import '../routes/route_helper.dart';
import 'notification_controller.dart';

class AuthController extends GetxController implements GetxService {
  final AuthRepo authRepo;
  final UserRepo userRepo;

  AuthController({required this.authRepo, required this.userRepo});

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  JwtModel? _userModel;

  String _groupId = '';
  String get groupId => _groupId;

  String _userToken = '';
  String get userToken => _userToken;

  Rx<UserProfileModel?> userProfile = Rx<UserProfileModel?>(null);

  Future<bool> checkEmail(String email) async {
    Response response = await authRepo.checkEmail(email);
    if (response.statusCode == 200) {
      return response.body['isVerified'];
    } else {
      print("BAD ${response.statusCode}");
      return true;
    }
  }

  Future<ResponseModel> fetchMe() async {
    _isLoading = true;
    update();
    Response response = await authRepo.fetchMe();
    late ResponseModel responseModel;
    if (response.statusCode == 200) {
      //await notificationController.subscribeToGroup(response.body['groupId']);
      responseModel = ResponseModel(true, jsonEncode(response.body));
      print(response.body.toString());
    } else if (response.statusCode == 400) {
      clearSharedData();
      GetPage(
          name: RouteHelper.signInPage,
          page: () {
            return const SignInPage();
          });
      responseModel = ResponseModel(false, response.statusText!);
    } else {
      responseModel = ResponseModel(false, response.statusText!);
    }
    _isLoading = false;
    update();
    return responseModel;
  }

  String getUserId() {
    print(_userToken);
    Map<String, dynamic> decodedToken = JwtDecoder.decode(_userToken);
    String userId = decodedToken["userId"];
    return userId;
  }

  Future<ResponseModel> createGroup(CreateGroup newGroup,
      NotificationController notificationController) async {
    _isLoading = true;
    update();
    Response response = await authRepo.createGroup(newGroup);
    late ResponseModel responseModel;
    if (response.statusCode == 200) {
      responseModel = ResponseModel(true, "New group created successfully");
      userProfile.value?.groupId = response.body['groupId'];
      await notificationController.subscribeToGroup(response.body['groupId']);
    } else {
      print("BAD ${response.statusCode}");
      responseModel = ResponseModel(false, response.statusText!);
    }
    _isLoading = false;
    update();
    return responseModel;
  }

  Future<ResponseModel> joinGroup(
    JoinGroup group,
    NotificationController notificationController,
  ) async {
    _isLoading = true;
    update();
    print("ude tu");
    Response response = await authRepo.joinGroup(group);
    print(response.statusCode);
    late ResponseModel responseModel;
    if (response.statusCode == 200) {
      responseModel = ResponseModel(true, "User sucessfuly joined group");
      userProfile.value?.groupId = response.body['groupId'];

      await notificationController.subscribeToGroup(response.body['groupId']);
      //saveGroupId(response.body['id']);
    } else {
      print("BAD ${response.statusCode}");
      responseModel = ResponseModel(false, response.statusText!);
    }
    _isLoading = false;
    update();
    return responseModel;
  }

  Future<ResponseModel> getGroup(String groupId) async {
    _isLoading = true;
    update();
    Response response = await authRepo.getGroup(groupId);
    late ResponseModel responseModel;
    if (response.statusCode == 200) {
      responseModel = ResponseModel(true, response.body);
      print(response.body);
    } else {
      responseModel = ResponseModel(false, response.statusText!);
    }
    _isLoading = false;
    update();
    return responseModel;
  }

  Future<void> fetchAndSetUserToken() async {
    _userToken = await authRepo.getUserToken();
    update(); // This notifies all listeners that the state has changed
  }

  // This method can be used to get the token, fetching it if its not already set
  Future<String> getUserToken() async {
    if (_userToken.isEmpty) {
      await fetchAndSetUserToken();
    }
    return _userToken;
  }

  // Call this method when you want to clear the token (on logout)
  void clearUserAuthData() {
    userProfile == Rx<UserProfileModel?>(null);
    _userToken = '';
    _groupId = '';
    update();
  }

  Future<ResponseModel> registration(SignupBody signUpBody) async {
    _isLoading = true;
    update();
    Response response = await authRepo.registration(signUpBody);
    late ResponseModel responseModel;
    if (response.statusCode == 200) {
      responseModel = ResponseModel(true, response.body["userId"]);
      userProfile.value = UserProfileModel(
        name: '',
        surname: '',
        groupId: '',
        userId: response.body["userId"],
      );
      print(response.body.toString());
    } else {
      responseModel = ResponseModel(false, response.statusText!);
    }
    _isLoading = false;
    update();
    return responseModel;
  }

  Future<ResponseModel> login(String email, String password) async {
    _isLoading = true;
    Map<String, dynamic> userEntity;
    update();
    Response response = await authRepo.login(email, password);
    late ResponseModel responseModel;
    if (response.statusCode == 200) {
      String token = response.body["accessToken"];
      //saving user token to shared pref
      print("TOKEN IS: " + token);
      authRepo.saveUserToken(token);
      await fetchAndSetUserToken();

      responseModel = ResponseModel(true, response.body["accessToken"]);
    } else if (response.statusCode == 403) {
      Response response = await authRepo.getUserIdByEmail(email);
      userProfile.value = UserProfileModel(
        name: '',
        surname: '',
        groupId: '',
        userId: response.body["userId"],
      );
      //call method to add userId: response.body["userId"],
      responseModel = ResponseModel(false, "Email is not verified.");
    } else if (response.statusCode == 404) {
      Response response = await authRepo.getUserIdByEmail(email);
      userProfile.value = UserProfileModel(
        name: '',
        surname: '',
        groupId: '',
        userId: response.body["userId"],
      );
      //call method to add userId: response.body["userId"],
      responseModel =
          ResponseModel(false, "User registration is not complete.");
    } else {
      responseModel = ResponseModel(false, response.statusText!);
    }
    _isLoading = false;
    update();
    return responseModel;
  }

  bool userLoggedIn() {
    return authRepo.userLoggedIn();
  }

  bool clearSharedData() {
    clearUserAuthData();
    return authRepo.clearSharedData();
  }

  Future<ResponseModel> createUserProfile() async {
    _isLoading = true;
    update();
    http.Response response;
    late ResponseModel responseModel;
    if (userProfile.value != null && userProfile.value!.name.isNotEmpty) {
      response = await authRepo.createProfile(userProfile.value!);
      if (response.statusCode == 200) {
        responseModel =
            ResponseModel(true, jsonEncode(jsonDecode(response.body)));
        print("GOOD ${response.body}");
      } else {
        print("BAD CREATING PROFILE${response.statusCode}");
        responseModel = ResponseModel(false, response.statusCode.toString());
      }
    } else {
      print("BAD CREATING PROFILE - userProfile data is missing");
      print(
          "Id ${userProfile.value?.userId}Name ${userProfile.value?.name}Surame ${userProfile.value?.surname}GroupId ${userProfile.value?.groupId}");
      responseModel = ResponseModel(false, "User profile data is missing");
    }
    _isLoading = false;
    update();
    return responseModel;
  }
}

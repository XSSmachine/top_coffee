import 'dart:async';
import 'dart:convert';

import 'package:get/get.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:team_coffee/controllers/event_controller.dart';
import 'package:team_coffee/controllers/order_controller.dart';
import 'package:team_coffee/controllers/user_controller.dart';
import 'package:team_coffee/models/group/join_group.dart';
import 'package:http/http.dart' as http;
import 'package:team_coffee/pages/auth/sign_in_page.dart';
import '../data/repository/auth_repo.dart';
import '../data/repository/user_repo.dart';
import '../helper/deeplink_handler.dart';
import '../models/group/create_group.dart';
import '../models/group/user_data.dart';
import '../models/group_data.dart';
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

  String? pendingGroupCode;

  UserData? _userData;
  UserData? get userData => _userData;

  List<Group>? _groupData;
  List<Group>? get groupData => _groupData;

  String _groupId = '';
  String get groupId => _groupId;

  String _userToken = '';
  String get userToken => _userToken;

  Rx<UserProfileModel?> userProfile = Rx<UserProfileModel?>(null);

  /// Checks if user email is verified
  Future<bool> checkEmail(String email) async {
    Response response = await authRepo.checkEmail(email);
    if (response.statusCode == 200) {
      return response.body['isVerified'];
    } else {
      print("BAD ${response.statusCode}");
      return false;
    }
  }

  /// Fetches current user data
  Future<ResponseModel> fetchMe() async {
    _isLoading = true;
    update();
    Response response = await authRepo.fetchMe();
    late ResponseModel responseModel;
    if (response.statusCode == 200) {
      responseModel = ResponseModel(true, jsonEncode(response.body));
    } else if (response.statusCode == 400) {
      await handleUnauthorizedAccess();
      responseModel = ResponseModel(false, response.statusText!);
    } else {
      responseModel = ResponseModel(false, response.statusText!);
    }
    _isLoading = false;
    update();
    return responseModel;
  }

  Future<void> fetchMeData() async {
    try {
      _isLoading = true;

      Response response = await authRepo.fetchMe();

      if (response.statusCode == 200) {
        _userData = UserData.fromJson(response.body);
      } else if (response.statusCode == 400) {
        await handleUnauthorizedAccess();
        throw Exception('Unauthorized access');
      } else {
        throw Exception('Failed to fetch user data: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching user data: $e');
      rethrow;
    } finally {
      _isLoading = false;
      update();
    }
  }

  Future<List<Group>> fetchAllGroups() async {
    try {
      _isLoading = true;

      Response response = await authRepo.getAllGroups();

      if (response.statusCode == 200) {
        // Parse the response body as a List<dynamic>
        List<dynamic> jsonList = response.body;

        // Convert each item in the list to a Group object
        List<Group> groups =
            jsonList.map((json) => Group.fromJson(json)).toList();

        // Store the groups in _groupData if needed
        _groupData = groups;

        return groups;
      } else if (response.statusCode == 400) {
        await handleUnauthorizedAccess();
        throw Exception('Unauthorized access');
      } else {
        throw Exception(
            'Failed to fetch all group data: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching all group data: $e');
      rethrow;
    } finally {
      _isLoading = false;
      update();
    }
  }

  Future<void> handleUnauthorizedAccess() async {
    // final userController = Get.find<UserController>();
    // final eventController = Get.find<EventController>();
    // final orderController = Get.find<OrderController>();
    //
    // userController.resetAllValues();
    // eventController.resetAllValues();
    // orderController.resetAllValues();
    await clearSharedData();

    GetPage(
        name: RouteHelper.signInPage,
        page: () {
          return const SignInPage();
        });
  }

  Future<String> fetchMeGroupId() async {
    _isLoading = true;
    update();
    Response response = await authRepo.fetchMe();
    String groupId = "";

    if (response.statusCode == 200) {
      try {
        // Extract the groupId
        groupId = response.body['groupId'];
      } catch (e) {
        print('Error parsing response: $e');
      }
    } else if (response.statusCode == 400) {
      Get.find<UserController>().resetAllValues();
      Get.find<EventController>().resetAllValues();
      Get.find<OrderController>().resetAllValues();
      clearSharedData();
      GetPage(
        name: RouteHelper.signInPage,
        page: () {
          return const SignInPage();
        },
      );
    }

    _isLoading = false;
    update();
    return groupId;
  }

  String getUserId() {
    print("USER TOKEN _> " + _userToken);
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
      //userProfile.value?.groupId = response.body['groupId'];
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
      //userProfile.value?.groupId = response.body['groupId'];
      await notificationController.subscribeToGroup(response.body['groupId']);
    } else {
      print("BAD ${response.statusCode}");
      responseModel = ResponseModel(false, response.statusText!);
    }
    _isLoading = false;
    update();
    return responseModel;
  }

  Future<Group?> joinGroupViaInvitation(
      String groupCode, NotificationController notificationController) async {
    try {
      _isLoading = true;
      update();

      print("Joining group via invitation");
      Response response = await authRepo.joinGroupViaInvitation(groupCode);
      print("RESPONSE BODY ----->>>>>  ${response.body}");

      if (response.statusCode == 200) {
        final groupData = response.body;
        final groupId = groupData['groupId'];
        final name = groupData['name'];
        final description = groupData['description'];
        final imageUrl = groupData['photoUrl'];

        //userProfile.value?.groupId = groupId;
        await notificationController.subscribeToGroup(groupId);

        //Get.snackbar('Success', 'Successfully joined the group');

        return Group(
            groupId: groupId,
            name: name,
            description: description,
            photoUrl: imageUrl);
      } else {
        throw Exception(
          'Failed to join group. Status code: ${response.statusCode}',
        );
      }
    } catch (e) {
      print("Error joining group: $e");
      if (e is Exception) {
        Get.snackbar('Error', e.toString() ?? 'Failed to join group');
      } else {
        Get.snackbar('Error', 'An unexpected error occurred');
      }
      return null;
    } finally {
      _isLoading = false;
      update();
    }
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

  Future<String> getGroupName(String groupId) async {
    _isLoading = true;
    update();
    Response response = await authRepo.getGroup(groupId);
    late String groupName;
    if (response.statusCode == 200) {
      groupName = response.body["name"];
    } else {
      groupName = response.statusCode.toString();
    }
    _isLoading = false;
    update();
    return groupName;
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

  Future<void> fetchAndSetGroupId() async {
    _groupId = await authRepo.getGroupId();
    update(); // This notifies all listeners that the state has changed
  }

  // This method can be used to get the token, fetching it if its not already set
  Future<String> getGroupId() async {
    if (_groupId.isEmpty) {
      await fetchAndSetGroupId();
    }
    return _groupId;
  }

  Future<void> saveGroupId(String groupId) async {
    await authRepo.saveGroupId(groupId);
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
        userId: response.body["userId"],
      );
      AppLinksDeepLink.instance.checkPendingGroupJoin();
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
      _userToken = token.trim();
      authRepo.saveUserToken(token);
      await fetchAndSetUserToken();
      AppLinksDeepLink.instance.checkPendingGroupJoin();
      responseModel = ResponseModel(true, response.body["accessToken"]);
    } else if (response.statusCode == 403) {
      Response response = await authRepo.getUserIdByEmail(email);
      // userProfile.value = UserProfileModel(
      //   name: '',
      //   surname: '',
      //   userId: response.body["userId"],
      // );
      //call method to add userId: response.body["userId"],
      responseModel = ResponseModel(false, "Email is not verified.");
    } else if (response.statusCode == 404) {
      Response response = await authRepo.getUserIdByEmail(email);
      userProfile.value = UserProfileModel(
        name: '',
        surname: '',
        userId: response.body["userId"],
      );
      //call method to add userId: response.body["userId"],
      responseModel =
          ResponseModel(false, "User registration is not complete.");
    } else if (response.statusCode == 401) {
      //call method to add userId: response.body["userId"],
      responseModel = ResponseModel(false, "User is unauthorized.");
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

    response = await authRepo.createProfile(userProfile.value!);
    if (response.statusCode == 200) {
      responseModel =
          ResponseModel(true, jsonEncode(jsonDecode(response.body)));
      print("GOOD ${response.body}");
    } else {
      print("BAD CREATING PROFILE${response.statusCode}");
      responseModel = ResponseModel(false, response.statusCode.toString());
    }

    _isLoading = false;
    update();
    return responseModel;
  }

  Future<String> generateInviteLink(String userProfileId) async {
    Response response = await authRepo.generateInviteLink(userProfileId);
    if (response.statusCode == 200) {
      return response.body;
    } else {
      print("BAD generate link ${response.statusCode}");
      return "";
    }
  }
}

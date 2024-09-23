import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:get/get.dart';
import 'package:team_coffee/models/jwt_model.dart';
import '../data/repository/user_repo.dart';
import '../models/event_status_count.dart';
import '../models/fetch_me_model.dart';
import '../models/group/group_member.dart';
import '../models/group_data.dart';
import '../models/order_status_count.dart';
import '../models/password_change_model.dart';
import '../models/response_model.dart';
import '../models/update_group_model.dart';
import '../models/update_profile_model.dart';
import '../models/user_model.dart';

class UserController extends GetxController implements GetxService {
  final UserRepo userRepo;

  UserController({required this.userRepo});

  RxList allUserList = <UserModel>[].obs;
  var orderStats = <StatusCount>[].obs;
  var eventStats = <EventCount>[].obs;
  JwtModel? _userModel;

  var profileImage = Rx<Uint8List?>(null);

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  final bool _isLoaded = false;
  bool get isLoaded => _isLoaded;

  JwtModel? get userModel => _userModel;

  FetchMeModel? _user;
  FetchMeModel? get user => _user;

  var _group = Rx<Group?>(null);
  Rx<Group?> get group => _group;

  UserModel? _userDetail;
  UserModel? get userDetail => _userDetail;

  RxString groupName = "".obs;
  RxString groupDesc = "".obs;

  bool hasMore = true;
  int currentPage = 0;
  final int pageSize = 7;

  RxList<GroupMember> groupMembers = <GroupMember>[].obs;

  Future<void> fetchGroupMembers() async {
    try {
      final response = await userRepo.getAllGroupMembers();
      if (response.statusCode == 200) {
        final List<dynamic> membersJson = response.body;
        groupMembers.value =
            membersJson.map((json) => GroupMember.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load group members');
      }
    } catch (e) {
      print('Error fetching group members: $e');
      // You might want to show an error message to the user here
    }
  }

  Future<void> getLeaderBoard(String filter, {bool loadMore = false}) async {
    if (!loadMore) {
      allUserList.clear();
      currentPage = 0;
      hasMore = true;
    }

    if (!hasMore) return;

    _isLoading = true;

    try {
      await userRepo.calculateScores();
      print("Current page" + currentPage.toString() + filter);
      Response response = await userRepo.getGroupLeaderboard(
        sort: filter,
        page: currentPage,
        limit: pageSize,
      );
      final List<UserModel> localList = [];
      if (response.statusCode == 200) {
        response.body.forEach((element) {
          localList.add(UserModel.fromJson(element));
        });

        if (localList.length < pageSize) {
          hasMore = false;
        }

        if (localList.isNotEmpty) {
          allUserList.addAll(localList);
          currentPage++;
        }
      } else {
        print("ERROR" + response.body);
      }
    } catch (e) {
      print('Error fetching leaderboard: $e');
    } finally {
      _isLoading = false;
      update();
    }
  }

  List<StatusCount> parseStatusCounts(List<dynamic> jsonString) {
    return jsonString.map((json) => StatusCount.fromJson(json)).toList();
  }

  List<EventCount> parseEventStatusCounts(List<dynamic> jsonString) {
    return jsonString.map((json) => EventCount.fromJson(json)).toList();
  }

  Future<void> getOrderStats() async {
    _isLoading = true;
    update();

    try {
      Response response = await userRepo.getOrderNumber();
      if (response.statusCode == 200) {
        orderStats.value = parseStatusCounts(response.body);
        update();
      } else {
        print("ERROR" + response.body);
      }
    } catch (e) {
      print('Error fetching order stats: $e');
    } finally {
      _isLoading = false;
      update();
    }
  }

  Future<void> kickUserFromGroup(String userProfileId) async {
    try {
      Response response = await userRepo.kickUserByUserProfileId(userProfileId);
      if (response.statusCode == 200) {
        print("KICKED SOME USER" + response.body);
        update();
      } else {
        print("ERROR" + response.body);
      }
    } catch (e) {
      print('Error fetching event stats: $e');
    } finally {
      _isLoading = false;
      update();
    }
  }

  Future<void> promoteUserFromGroup(String userProfileId, String role) async {
    try {
      Response response =
          await userRepo.promoteUserByUserProfileId(userProfileId, role);
      if (response.statusCode == 200) {
        update();
      } else {
        print("ERROR" + response.statusCode.toString());
      }
    } catch (e) {
      print('Error fetching event stats: $e');
    } finally {
      _isLoading = false;
      update();
    }
  }

  Future<void> getEventsStats() async {
    _isLoading = true;
    update();

    try {
      Response response = await userRepo.getEventsNumber();
      if (response.statusCode == 200) {
        eventStats.value = parseEventStatusCounts(response.body);
        update();
      } else {
        print("ERROR" + response.body);
      }
    } catch (e) {
      print('Error fetching event stats: $e');
    } finally {
      _isLoading = false;
      update();
    }
  }

  void resetAllValues() {
    // _allUserList.clear();
    groupName.value = "";
    groupDesc.value = "";
    _userModel = null;
    _user = null;
    _isLoading = false;
    profileImage.value = null;
    update();
  }

  //Getting userID from the token
  Future<String> getUserId(String token) async {
    _isLoading = true;
    Map<String, dynamic> userEntity;
    userEntity = await userRepo.getUserId(token);

    _userModel = JwtModel.fromJson(userEntity);

    _isLoading = false;
    update();
    return userEntity["userId"];
  }

  Future<Uint8List?> fetchProfilePhoto() async {
    try {
      final response = await userRepo.getProfilePhoto();

      if (response.statusCode == 200) {
        final bytes = response.bodyBytes;
        profileImage.value = bytes;
        return bytes;
      } else if (response.statusCode == 404) {
        print('Profile photo not found');
        profileImage.value = null;
        return null;
      } else {
        print(
            'Failed to load profile photo. Status code: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error fetching profile photo: $e');
      return null;
    }
  }

  Future<ResponseModel> editUserProfile(UpdateProfileModel body,
      {File? imageFile}) async {
    ResponseModel responseModel;
    try {
      final response = await userRepo.editProfile(body, imageFile: imageFile);

      if (response.statusCode == 200) {
        responseModel = ResponseModel(true, "successfully");
        return responseModel;
      } else if (response.statusCode == 404) {
        print('Profile photo not found');
        responseModel = ResponseModel(false, response.statusCode.toString());
        return responseModel;
      } else {
        print(
            'Failed to load profile photo. Status code: ${response.statusCode}');
        responseModel = ResponseModel(false, response.statusCode.toString());
        return responseModel;
      }
    } catch (e) {
      print('Error fetching profile photo: $e');
      responseModel = ResponseModel(false, e.toString());
      return responseModel;
    }
  }

  Future<ResponseModel> editGroup(UpdateGroupModel body,
      {File? imageFile}) async {
    ResponseModel responseModel;
    try {
      final response = await userRepo.editGroup(body, imageFile: imageFile);

      if (response.statusCode == 200) {
        responseModel = ResponseModel(true, "successfully");
        return responseModel;
      } else if (response.statusCode == 404) {
        print('Profile photo not found');
        responseModel = ResponseModel(false, response.statusCode.toString());
        return responseModel;
      } else {
        print(
            'Failed to load profile photo. Status code: ${response.statusCode}');
        responseModel = ResponseModel(false, response.statusCode.toString());
        return responseModel;
      }
    } catch (e) {
      print('Error fetching profile photo: $e');
      responseModel = ResponseModel(false, e.toString());
      return responseModel;
    }
  }

  //Getting single user details
  Future<ResponseModel> getUserProfile() async {
    _isLoading = true;
    Response response = await userRepo.getUserInfo();
    late ResponseModel responseModel;
    if (response.statusCode == 200) {
      _user = FetchMeModel.fromJson(response.body);

      responseModel = ResponseModel(true, "successfully");
    } else {
      responseModel = ResponseModel(false, response.statusText!);
    }
    _isLoading = false;
    update();
    return responseModel;
  }

  Future<ResponseModel> getUser() async {
    _isLoading = true;
    Response response = await userRepo.getUserInfo();
    late ResponseModel responseModel;
    if (response.statusCode == 200) {
      _user = FetchMeModel.fromJson(response.body);

      responseModel = ResponseModel(true, "successfully");
    } else {
      responseModel = ResponseModel(false, response.statusText!);
    }
    _isLoading = false;
    update();
    return responseModel;
  }

  Future<ResponseModel> getUserProfileDetails() async {
    _isLoading = true;
    String id = await getProfileId();
    Response response = await userRepo.getUserProfileDetails(id);
    late ResponseModel responseModel;
    if (response.statusCode == 200) {
      _userDetail = UserModel.fromJson(response.body);
      responseModel = ResponseModel(true, "successfully");
    } else {
      responseModel = ResponseModel(false, response.statusText!);
    }
    _isLoading = false;
    update();
    return responseModel;
  }

  Future<void> getGroupName() async {
    _isLoading = true;
    String id = await userRepo.getGroupId();
    Response response = await userRepo.getGroupById(id);
    late String responseModel;
    if (response.statusCode == 200) {
      groupName.value = response.body["name"];
      groupDesc.value = response.body["description"];
    } else {
      print("Error getting groupId");
    }
    _isLoading = false;
    update();
  }

  Future<Group> getGroupData() async {
    try {
      _isLoading = true;
      update();

      String id = await userRepo.getGroupId();
      Response response = await userRepo.getGroupById(id);

      if (response.statusCode == 200) {
        // Parse the response body to a Map
        Map<String, dynamic> jsonData = response.body;

        // Create a Group object from the JSON data
        Group group = Group.fromJson(jsonData);

        // Update the group data
        // groupName.value = group.name;
        // groupDesc.value = group.description;
        // groupPhotoUrl.value = group.photoUrl ?? ''; // Assuming you have a groupPhotoUrl observable

        // You can also store the entire Group object if needed
        _group.value = group;
        return group;
      } else {
        throw Exception("Error getting group data: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Error getting group data: $e");
    } finally {
      _isLoading = false;
      update();
    }
  }

  Future<String> getProfileId() async {
    _isLoading = true;
    Response response = await userRepo.getUserInfo();
    late String responseModel;
    if (response.statusCode == 200) {
      _user = FetchMeModel.fromJson(response.body);

      responseModel = _user!.userProfileId;
    } else {
      responseModel = "Error getting groupId";
    }
    _isLoading = false;
    update();
    return responseModel;
  }

  Future<ResponseModel> changePassword(
      String oldPassword, String newPassword) async {
    _isLoading = true;

    try {
      PasswordChangeModel passwordChangeModel =
          PasswordChangeModel(oldPassword: oldPassword, password: newPassword);

      Response response = await userRepo.changePassword(passwordChangeModel);

      _isLoading = false;

      if (response.statusCode == 200) {
        print(1);
        return ResponseModel(true, 'Password changed successfully');
      } else if (response.statusCode == 409) {
        print(2);
        return ResponseModel(
            false, 'The old password you entered is incorrect');
      } else {
        print(response.body.toString() + "${response.statusCode}");
        return ResponseModel(false, response.statusText ?? 'An error occurred');
      }
    } catch (e) {
      print(4);
      _isLoading = false;
      return ResponseModel(
          false, 'An unexpected error occurred: ${e.toString()}');
    }
  }

  void updateGroupName(String newValue) {
    groupName.value = newValue;
  }
}

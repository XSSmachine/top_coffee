import 'dart:io';
import 'dart:typed_data';

import 'package:get/get.dart';
import 'package:team_coffee/models/jwt_model.dart';

import '../data/repository/user_repo.dart';
import '../models/fetch_me_model.dart';
import '../models/response_model.dart';
import '../models/update_profile_model.dart';
import '../models/user_model.dart';

class UserController extends GetxController implements GetxService {
  final UserRepo userRepo;

  UserController({required this.userRepo});

  final RxList<UserModel> _allUserList = <UserModel>[].obs;
  List<UserModel> get allUserList => _allUserList;

  JwtModel? _userModel;

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  final bool _isLoaded = false;
  bool get isLoaded => _isLoaded;
  JwtModel? get userModel => _userModel;

  FetchMeModel? _user;
  FetchMeModel? get user => _user;

  Rx<Uint8List?> profileImage = Rx<Uint8List?>(null);

  //Getting userID from the token
  Future<String> getUserId(String token) async {
    Map<String, dynamic> userEntity;
    userEntity = await userRepo.getUserId(token);

    _userModel = JwtModel.fromJson(userEntity);

    _isLoading = true;
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

  //Getting all users in the db
  Future<void> getAllUsers() async {
    /*Response response = await userRepo.getAllUsers();
    if(response.statusCode==200){
      _allUserList=[];
      List<UserModel> localList = [];

      response.body.forEach((element) {
        localList.add(UserModel.fromJson(element));
      });
      localList.sort((a, b) => (b.score ?? 0).compareTo(a.score ?? 0));
      _allUserList = localList;
      _isLoaded=true;
      update();
    }else{
      print("ERROR"+response.body);
    }*/
  }

  Future<void> getLeaderBoard() async {
    print("fetching leaderboard ");
    Response response = await userRepo.getGroupLeaderboard();
    if (response.statusCode == 200) {
      List<UserModel> localList = [];

      response.body.forEach((element) {
        localList.add(UserModel.fromJson(element));
      });
      //localList.sort((a, b) => (b.score ?? 0).compareTo(a.score ?? 0));
      _allUserList.addAll(localList);
      update();
    } else {
      print("ERROR" + response.body);
    }
  }

  //Getting single user details
  Future<ResponseModel> getUserProfile() async {
    Response response = await userRepo.getUserInfo();
    late ResponseModel responseModel;
    if (response.statusCode == 200) {
      _user = FetchMeModel.fromJson(response.body);
      _isLoading = true;
      responseModel = ResponseModel(true, "successfully");
    } else {
      responseModel = ResponseModel(false, response.statusText!);
    }

    update();
    return responseModel;
  }

  Future<String> getGroupId() async {
    Response response = await userRepo.getUserInfo();
    late String responseModel;
    if (response.statusCode == 200) {
      _user = FetchMeModel.fromJson(response.body);
      _isLoading = true;
      responseModel = _user!.groupId;
    } else {
      responseModel = "Error getting groupId";
    }

    update();
    return responseModel;
  }

  Future<String> getProfileId() async {
    Response response = await userRepo.getUserInfo();
    late String responseModel;
    if (response.statusCode == 200) {
      _user = FetchMeModel.fromJson(response.body);
      _isLoading = true;
      responseModel = _user!.profileId;
    } else {
      responseModel = "Error getting groupId";
    }

    update();
    return responseModel;
  }
}

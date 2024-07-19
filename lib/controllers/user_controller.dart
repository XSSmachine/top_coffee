
import 'dart:convert';

import 'package:get/get.dart';
import 'package:team_coffee/models/jwt_model.dart';
import 'package:team_coffee/models/user_profile_model.dart';

import '../data/repository/user_repo.dart';
import '../models/response_model.dart';
import '../models/user_model.dart';
class UserController extends GetxController implements GetxService {
  final UserRepo userRepo;

  UserController({
    required this.userRepo
  });

  List<UserModel> _allUserList= [];
  List<UserModel> get allUserList => _allUserList;

  bool _isLoading = false;
  JwtModel? _userModel;

  bool get isLoading => _isLoading;
  bool _isLoaded = false;
  bool get isLoaded => _isLoaded;
  JwtModel? get userModel =>_userModel;

  Future<Map<String, dynamic>> getUserId(String token) async {

    Map<String, dynamic> userEntity;
    userEntity = await userRepo.getUserId(token);

    _userModel = JwtModel.fromJson(userEntity);

    userRepo.saveUserID(_userModel!.id);
    _isLoading=true;
    update();
    return userEntity;
  }



  Future<void> getAllUsers()async {
    Response response = await userRepo.getAllUsers();
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
    }
  }



  UserProfileModel? _user;
  UserProfileModel? get user =>_user;

  Future<ResponseModel> getUserInfo() async {

    print("Is this working for USER ID?" + getUserIDFromPrefs().toString());
    Response response = await userRepo.getUserInfo(getUserIDFromPrefs()!);
    late ResponseModel responseModel;
    if (response.statusCode == 200) {
      _user = UserProfileModel.fromJson(response.body);
      _isLoading=true;
      responseModel = ResponseModel(true, "successfully");
    } else {
      responseModel = ResponseModel(false, response.statusText!);
    }

    update();
    return responseModel;
  }

  String? getUserIDFromPrefs() {
    return userRepo.getUserIDFromPrefs();
  }

  // Optionally, you can also add a getter for easier access
  String? get cachedUserId => getUserIDFromPrefs();
}
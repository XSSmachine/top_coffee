
import 'dart:convert';

import 'package:get/get.dart';
import 'package:team_coffee/models/jwt_model.dart';
import 'package:team_coffee/models/user_profile_model.dart';

import '../data/repository/user_repo.dart';
import '../models/fetch_me_model.dart';
import '../models/response_model.dart';
import '../models/user_model.dart';
class UserController extends GetxController implements GetxService {
  final UserRepo userRepo;

  UserController({
    required this.userRepo
  });

  List<UserModel> _allUserList= [];
  List<UserModel> get allUserList => _allUserList;

  JwtModel? _userModel;

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  bool _isLoaded = false;
  bool get isLoaded => _isLoaded;
  JwtModel? get userModel =>_userModel;

  FetchMeModel? _user;
  FetchMeModel? get user =>_user;

  //Getting userID from the token
  Future<Map<String, dynamic>> getUserId(String token) async {

    Map<String, dynamic> userEntity;
    userEntity = await userRepo.getUserId(token);

    _userModel = JwtModel.fromJson(userEntity);

    _isLoading=true;
    update();
    return userEntity;
  }

  //Getting all users in the db
  Future<void> getAllUsers()async {
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

  //Getting single user details
  Future<ResponseModel> getUserProfile() async {

    Response response = await userRepo.getUserInfo();
    late ResponseModel responseModel;
    if (response.statusCode == 200) {
      _user = FetchMeModel.fromJson(response.body);
      _isLoading=true;
      responseModel = ResponseModel(true, "successfully");
    } else {
      responseModel = ResponseModel(false, response.statusText!);
    }

    update();
    return responseModel;
  }

}
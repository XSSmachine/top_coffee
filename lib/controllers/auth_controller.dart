
import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:team_coffee/models/group/join_group.dart';

import '../data/repository/auth_repo.dart';
import '../data/repository/user_repo.dart';
import '../models/group/create_group.dart';
import '../models/jwt_model.dart';
import '../models/response_model.dart';
import '../models/signup_body_model.dart';
import '../models/user_profile_model.dart';

class AuthController extends GetxController implements GetxService{
  final AuthRepo authRepo;
  final UserRepo userRepo;
  AuthController({
    required this.authRepo,
    required this.userRepo
});

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  JwtModel? _userModel;

  String _groupId='';
  String get groupId => _groupId;

  String _userToken = '';
  String get userToken => _userToken;

  Rx<UserProfileModel?> userProfile = Rx<UserProfileModel?>(null);


  Future<ResponseModel>createGroup(CreateGroup newGroup)async{
    _isLoading=true;
    update();
    Response response= await authRepo.createGroup(newGroup);
    late ResponseModel responseModel;
    if(response.statusCode==200){
      responseModel = ResponseModel(true, "New group created successfully");
    }else{
      print("BAD "+response.statusCode.toString());
      responseModel = ResponseModel(false, response.statusText!);
    }
    _isLoading=false;
    update();
    return responseModel;
  }

  Future<ResponseModel>joinGroup(JoinGroup group)async{
    _isLoading=true;
    update();
    print("ude tu");
    Response response= await authRepo.joinGroup(group);
    print(response.statusCode);
    late ResponseModel responseModel;
    if(response.statusCode==200){
      responseModel = ResponseModel(true, "User sucessfuly joined group");
      userProfile.value = UserProfileModel(
        name: userProfile.value?.name ?? '',
        surname: userProfile.value?.surname ?? '',
        groupId: response.body['id'],
        userId: userProfile.value?.userId ?? '',
      );
      //saveGroupId(response.body['id']);
    }else{
      print("BAD "+response.statusCode.toString());
      responseModel = ResponseModel(false, response.statusText!);
    }
    _isLoading=false;
    update();
    return responseModel;
  }

  /*void saveGroupId(String groupId) {
    final secureStorage = Get.find<FlutterSecureStorage>();
    secureStorage.write(key: 'groupId', value: groupId);
  }

  Future<String?> getGroupId() async {
    String grupId="";
    final secureStorage = Get.find<FlutterSecureStorage>();
    await secureStorage.read(key: 'groupId').then((value){
      if(value==null){
       return grupId;
      }else{
        grupId=value;
        return grupId;
      }
    });
  }*/

  Future<ResponseModel>getGroup(String groupId)async{
    _isLoading=true;
    update();
    Response response= await authRepo.getGroup(groupId);
    late ResponseModel responseModel;
    if(response.statusCode==200){
      responseModel = ResponseModel(true, response.body);
      print(response.body);
    }else{
      responseModel = ResponseModel(false, response.statusText!);
    }
    _isLoading=false;
    update();
    return responseModel;
  }

  Future<void> fetchAndSetUserToken() async {
    _userToken = await authRepo.getUserToken();
    update(); // This notifies all listeners that the state has changed
  }

  // This method can be used to get the token, fetching it if it's not already set
  Future<String> getUserToken() async {
    if (_userToken.isEmpty) {
      await fetchAndSetUserToken();
    }
    return _userToken;
  }

  // Call this method when you want to clear the token (e.g., on logout)
  void clearUserToken() {
    _userToken = '';
    update();
  }

  Future<ResponseModel>registration(SignupBody signUpBody) async{
    _isLoading=true;
    update();
    Response response= await authRepo.registration(signUpBody);
    late ResponseModel responseModel;
    if(response.statusCode==200){
      responseModel = ResponseModel(true, response.body);
      print(response.body);
    }else{
      responseModel = ResponseModel(false, response.statusText!);
    }
    _isLoading=false;
    update();
    return responseModel;

  }

  Future<ResponseModel>login(String email,String password) async{
    _isLoading=true;
    Map<String, dynamic> userEntity;
    update();
    Response response= await authRepo.login(email,password);
    late ResponseModel responseModel;
    if(response.statusCode==200){
      String token = response.body["accessToken"];
      //saving user token to shared pref
      authRepo.saveUserToken(token);

      //saving user id to shared pref
      userEntity = await userRepo.getUserId(token);
      String userId = userEntity["userId"];

      userProfile.value = UserProfileModel(
        name: userProfile.value?.name ?? '',
        surname: userProfile.value?.surname ?? '',
        groupId: userProfile.value?.groupId ?? '',
        userId: userId,
      );

      await createUserProfile();

      responseModel = ResponseModel(true, response.body["accessToken"]);
    }else{
      responseModel = ResponseModel(false, response.statusText!);
    }
    _isLoading=false;
    update();
    return responseModel;

  }

  bool userLoggedIn() {
    return authRepo.userLoggedIn();
  }

  bool clearSharedData(){
    return authRepo.clearSharedData();
  }

  Future<ResponseModel>createUserProfile() async {
    _isLoading=true;
    update();
    Response response;
    late ResponseModel responseModel;
    if(userProfile.value!.name.isNotEmpty){
      response= await authRepo.createProfile(userProfile.value!);
      if(response.statusCode==200){
        responseModel = ResponseModel(true, jsonEncode(jsonDecode(response.body)));
        print("GOOD "+response.body);
      }else{
        print("BAD CREATING PROFILE"+response.statusCode.toString());
        responseModel = ResponseModel(false, response.statusText!);
      }
    }
    responseModel = ResponseModel(false, "User already has profile");
    _isLoading=false;
    update();
    return responseModel;
  }


}
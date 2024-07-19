
import 'package:get/get.dart';

import '../data/repository/auth_repo.dart';
import '../data/repository/user_repo.dart';
import '../models/jwt_model.dart';
import '../models/response_model.dart';
import '../models/signup_body_model.dart';

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

  String _userToken = '';
  String get userToken => _userToken;

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
      _userModel = JwtModel.fromJson(userEntity);
      userRepo.saveUserID(_userModel!.id);

      responseModel = ResponseModel(true, response.body["accessToken"]);
    }else{
      responseModel = ResponseModel(false, response.statusText!);
    }
    _isLoading=false;
    update();
    return responseModel;

  }

  void saveUserData(String email,String name,String surname, String password, String coffeeMade, String rating) {
    authRepo.saveUserData(email, name, surname, password, coffeeMade, rating);
  }

  bool userLoggedIn() {
    return authRepo.userLoggedIn();
  }

  bool clearSharedData(){
    return authRepo.clearSharedData();
  }


}
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/signup_body_model.dart';
import '../../utils/app_constants.dart';
import '../api/api_client.dart';

class AuthRepo{
   final ApiClient apiClient;
   final SharedPreferences sharedPreferences;
   AuthRepo({
     required this.apiClient,
     required this.sharedPreferences
});

   Future<Response>registration(SignupBody signUpBody)async{
     return await apiClient.postData(AppConstants.REGISTRATION_URI, signUpBody.toJson());
   }
   
   Future<String> getUserToken() async {
     return await sharedPreferences.getString(AppConstants.TOKEN)??"None";
   }

   bool userLoggedIn() {
     print(sharedPreferences.containsKey(AppConstants.TOKEN).toString());
     return sharedPreferences.containsKey(AppConstants.TOKEN);
   }

   Future<Response>login(String email, String password)async{
     return await apiClient.postData(AppConstants.LOGIN_URI, {
       "email":email,
       "password":password,
     });
   }

   Future<bool> saveUserToken(String token) async {
     apiClient.token = token;
     apiClient.updateHeader(token);
     return await sharedPreferences.setString(AppConstants.TOKEN,token);
   }



   Future<void> saveUserData(String email,String name,String surname, String password, String coffeeMade, String rating) async {
     try{
       await sharedPreferences.setString(AppConstants.NAME,name);
       await sharedPreferences.setString(AppConstants.SURNAME,surname);
       await sharedPreferences.setString(AppConstants.EMAIL,email);
       await sharedPreferences.setString(AppConstants.PASSWORD,password);
       await sharedPreferences.setString(AppConstants.COFFEE_NUMBER,coffeeMade);
       await sharedPreferences.setString(AppConstants.RATING,rating);
     }catch(e){
        throw e;
     }
   }

   bool clearSharedData(){
     sharedPreferences.remove(AppConstants.TOKEN);
     sharedPreferences.remove(AppConstants.PASSWORD);
     sharedPreferences.remove(AppConstants.USER_ID);
     sharedPreferences.remove(AppConstants.EMAIL);
     sharedPreferences.remove(AppConstants.EVENT_ID);
     sharedPreferences.remove(AppConstants.ORDER_ID);
     apiClient.token='';
     apiClient.userId='';
     apiClient.eventId = '';
     apiClient.orderId='';
     apiClient.updateHeader('');
     return true;

   }
}
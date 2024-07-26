import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:team_coffee/models/group/create_group.dart';
import 'package:team_coffee/models/group/join_group.dart';
import 'package:team_coffee/models/user_profile_model.dart';

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

   /**
    * Methods for managing groups
    */
   Future<Response>createGroup(CreateGroup newGroup)async{
     return await apiClient.postData(AppConstants.GROUP_URI+"/create", newGroup.toJson());
   }

   Future<Response>joinGroup(JoinGroup group)async{
     return await apiClient.postData(AppConstants.GROUP_URI+"/join", group.toJson());
   }

   Future<Response>getGroup(String groupId)async{
     return await apiClient.getData(AppConstants.GROUP_URI+"/$groupId");
   }

   /**
    * Methods for managing user profile
    */
   Future<Response>createProfile(UserProfileModel newProfile)async{
     return await apiClient.postData(AppConstants.USER_PROFILE+"/create", newProfile.toJson());
   }

   Future<Response>getProfile(String profileId)async{
     return await apiClient.getData(AppConstants.USER_PROFILE+"/$profileId");
   }


   Future<Response>registration(SignupBody signUpBody)async{
     return await apiClient.postData(AppConstants.REGISTRATION_URI, signUpBody.toJson());
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

   /**
    * Methods for managing userToken which i get after logging in
    */
   Future<String> getUserToken() async {
     return await sharedPreferences.getString(AppConstants.TOKEN)??"None";
   }

   Future<bool> saveUserToken(String token) async {
     apiClient.token = token;
     apiClient.updateHeader(token);
     return await sharedPreferences.setString(AppConstants.TOKEN,token);
   }


   /**
    * Helper methods
    */

   bool clearSharedData(){
     sharedPreferences.remove(AppConstants.TOKEN);
     sharedPreferences.remove(AppConstants.EVENT_ID);
     sharedPreferences.remove(AppConstants.ORDER_ID);
     apiClient.token='';
     apiClient.eventId = '';
     apiClient.orderId='';
     apiClient.updateHeader('');
     return true;

   }
}
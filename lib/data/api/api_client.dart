
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../utils/app_constants.dart';

class ApiClient extends GetConnect implements GetxService{
  late String token;
  late String userId;
  late String eventId;
  late String orderId;
  final String appBaseUrl;
  late SharedPreferences sharedPreferences;

  late Map<String,String> _mainHeaders;

  ApiClient({required this.appBaseUrl, required this.sharedPreferences}){
    baseUrl = appBaseUrl;
    timeout = Duration(seconds: 30);
    token=sharedPreferences.getString(AppConstants.TOKEN)??"";
    userId=sharedPreferences.getString(AppConstants.USER_ID)??"";
    eventId=sharedPreferences.getString(AppConstants.EVENT_ID)??"";
    orderId=sharedPreferences.getString(AppConstants.ORDER_ID)??"";
    _mainHeaders={
      'Content-type':'application/json; charset=UTF-8',
      'Authorization' : 'Bearer $token',
    };
  }

  void updateHeader(String token){
    _mainHeaders={
      'Content-type':'application/json; charset=UTF-8',
      'Authorization' : 'Bearer $token',
    };
  }

  Future<Response> getData(String uri,{Map<String,String>? headers}) async {
    try{
      Response response = await get(uri,
      headers: headers??_mainHeaders
      );
          return response;
    }catch(e){
          return Response(statusCode: 1, statusText: e.toString());
    }
  }

    Future<Response> postData(String uri,dynamic body) async {
      try{
        Response response = await post(uri, body, headers:_mainHeaders);
        return response;
      }catch(e){
        print(e.toString());
        return Response(statusCode: 1, statusText: e.toString());
      }
    }

  Future<Response> patchData(String uri,dynamic body) async {
    try{
      Response response = await patch(uri, body, headers:_mainHeaders);
      return response;
    }catch(e){
      print(e.toString());
      return Response(statusCode: 1, statusText: e.toString());
    }
  }

  Future<Response> deleteData(String uri) async {
    try {
      Response response = await delete(uri, headers: _mainHeaders);
      return response;
    } catch (e) {
      print(e.toString());
      return Response(statusCode: 1, statusText: e.toString());
    }
  }
}
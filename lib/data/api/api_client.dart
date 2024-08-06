import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http_parser/http_parser.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../../models/update_profile_model.dart';
import '../../models/user_profile_model.dart';
import '../../utils/app_constants.dart';

class ApiClient extends GetConnect implements GetxService {
  late String token;
  final String appBaseUrl;
  late SharedPreferences sharedPreferences;

  late Map<String, String> _mainHeaders;
  late Map<String, String> _header;

  ApiClient({required this.appBaseUrl, required this.sharedPreferences}) {
    baseUrl = appBaseUrl;
    timeout = const Duration(seconds: 30);
    token = sharedPreferences.getString(AppConstants.TOKEN) ?? "";
    _mainHeaders = {
      'Content-type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token',
    };
    _header = {
      "Content-type": 'multipart/form-data',
      'Authorization': 'Bearer $token',
    };
  }

  void updateHeader(String token) {
    _mainHeaders = {
      'Content-type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token',
    };
  }

  Future<Response> getData(String uri, {Map<String, String>? headers}) async {
    try {
      Response response = await get(uri, headers: headers ?? _mainHeaders);
      return response;
    } catch (e) {
      return Response(statusCode: 1, statusText: e.toString());
    }
  }

  Future<http.Response> getPhoto(String uri,
      {Map<String, String>? headers}) async {
    try {
      http.Response response =
          await http.get(Uri.parse(uri), headers: headers ?? _mainHeaders);
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
      return response;
    } catch (e) {
      print('Response body: ${e.toString()}');
      return http.Response("${e}NOOB", 1);
    }
  }

  Future<Response> postData(String uri, dynamic body,
      {Map<String, String>? headers}) async {
    try {
      Response response =
          await post(uri, body, headers: headers ?? _mainHeaders);
      return response;
    } catch (e) {
      print(e.toString());
      return Response(statusCode: 1, statusText: e.toString());
    }
  }

  Future<http.Response> postMultipart(String uri, UserProfileModel body,
      {File? imageFile}) async {
    print('Sending request to: $uri');
    print(
        'User ID: ${body.userId}, Group ID: ${body.groupId}, Name: ${body.name}, Surname: ${body.surname}');

    var request = http.MultipartRequest('POST', Uri.parse(uri));

    // Add the request body as a JSON file
    var bodyJson = json.encode(body.toJson());
    var bodyBytes = utf8.encode(bodyJson);
    var bodyFile = http.MultipartFile.fromBytes(
      'body',
      bodyBytes,
      filename: 'body.json',
      contentType: MediaType('application', 'json'),
    );
    request.files.add(bodyFile);

    // Add headers
    request.headers.addAll(_header);
    request.headers['Content-Type'] = 'multipart/form-data';

    // Add image file if provided
    if (imageFile != null) {
      print('Adding image file: ${imageFile.path}');
      var multipartFile = await http.MultipartFile.fromPath(
        'file',
        imageFile.path,
      );
      request.files.add(multipartFile);
    }

    try {
      print('Sending request...');
      var streamedResponse = await request.send();
      print('Response status code: ${streamedResponse.statusCode}');

      var responseData = await streamedResponse.stream.toBytes();
      var responseString = utf8.decode(responseData);
      print('Response body: $responseString');

      return http.Response(responseString, streamedResponse.statusCode);
    } on SocketException catch (e) {
      print('Network error: ${e.toString()}');
      return http.Response('Network error occurred', 503);
    } on TimeoutException catch (e) {
      print('Request timed out: ${e.toString()}');
      return http.Response('Request timed out', 504);
    } catch (e) {
      print('Unexpected error: ${e.toString()}');
      return http.Response('Unexpected error occurred', 500);
    }
  }

  Future<http.Response> patchMultipart(String uri, UpdateProfileModel body,
      {File? imageFile}) async {
    print('Sending request to: $uri');

    var request = http.MultipartRequest('PATCH', Uri.parse(uri));

    request.fields['firstName'] = body.name;
    request.fields['lastName'] = body.surname;

    // Add headers
    request.headers.addAll(_header);

    // Add image file if provided
    if (imageFile != null) {
      print('Adding image file: ${imageFile.path}');
      var multipartFile = await http.MultipartFile.fromPath(
        'file',
        imageFile.path,
      );
      request.files.add(multipartFile);
    }

    try {
      print('Sending request...');
      var streamedResponse = await request.send();
      print('Response status code: ${streamedResponse.toString()}');

      print('Response body: $streamedResponse');

      return http.Response(
          streamedResponse.toString(), streamedResponse.statusCode);
    } on SocketException catch (e) {
      print('Network error: ${e.toString()}');
      return http.Response('Network error occurred', 503);
    } on TimeoutException catch (e) {
      print('Request timed out: ${e.toString()}');
      return http.Response('Request timed out', 504);
    } catch (e) {
      print('Unexpected error: ${e.toString()}');
      return http.Response('Unexpected error occurred', 500);
    }
  }

  Future<Response> patchData(String uri, dynamic body) async {
    try {
      Response response = await patch(uri, body, headers: _mainHeaders);
      return response;
    } catch (e) {
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

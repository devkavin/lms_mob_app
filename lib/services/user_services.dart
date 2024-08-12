import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/api_response.dart';
import 'package:http/http.dart' as http;

import '../constant.dart';

// login
Future<ApiResponse> login(String email, String password) async {
  ApiResponse apiResponse = ApiResponse();
  try {
    final response = await http.post(
      Uri.parse(loginURL),
      headers: {'Accept': 'application/json'},
      body: {
        'email': email,
        'password': password,
      },
    );
    switch (response.statusCode) {
      case 200:
        apiResponse.data = response.body;
        break;
      case 403:
        apiResponse.error = jsonDecode(response.body)['message'];
        break;
      case 422:
        final errors = jsonDecode(response.body)['errors'];
        apiResponse.error =
            errors[errors.keys.elementAt(0)][0]; // get the first error
        break;
      default:
        apiResponse.error = somethingWentWrong;
        break;
    }
  } catch (e) {
    apiResponse.error = serverError;
  }

  return apiResponse;
}

// register
Future<ApiResponse> register(String name, String email, String password) async {
  ApiResponse apiResponse = ApiResponse();
  try {
    final response = await http.post(
      Uri.parse(registerURL),
      headers: {'Accept': 'application/json'},
      body: {
        'name': name,
        'email': email,
        'password': password,
        'password_confirmation': password,
      },
    );
    switch (response.statusCode) {
      case 200:
        apiResponse.data = response.body;
        break;
      case 403:
        apiResponse.error = jsonDecode(response.body)['message'];
        break;
      case 422:
        final errors = jsonDecode(response.body)['errors'];
        apiResponse.error =
            errors[errors.keys.elementAt(0)][0]; // get the first error
        break;
      default:
        apiResponse.error = somethingWentWrong;
        break;
    }
  } catch (e) {
    apiResponse.error = serverError;
  }

  return apiResponse;
}

// user details
Future<ApiResponse> getUserDetails() async {
  ApiResponse apiResponse = ApiResponse();
  try {
    String token = await getToken();
    final response = await http.post(
      Uri.parse(userURL),
      headers: {'Accept': 'application/json', 'Authorization': 'Bearer $token'},
    );
    switch (response.statusCode) {
      case 200:
        apiResponse.data = response.body;
        break;
      case 403:
        apiResponse.error = jsonDecode(response.body)['message'];
        break;
      case 422:
        final errors = jsonDecode(response.body)['errors'];
        apiResponse.error =
            errors[errors.keys.elementAt(0)][0]; // get the first error
        break;
      default:
        apiResponse.error = somethingWentWrong;
        break;
    }
  } catch (e) {
    apiResponse.error = serverError;
  }

  return apiResponse;
}

// get token
Future<String> getToken() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  return prefs.getString('token') ?? '';
}

// get user id
Future<int> getUserId() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  return prefs.getInt('id') ?? 0;
}

// logout
Future<bool> logout() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  return await prefs.remove('token');
}

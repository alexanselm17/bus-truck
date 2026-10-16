import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart';
import '../models/userModel.dart';
import '../utils/constants.dart';

class AuthProvider with ChangeNotifier {
  Status _loggedInStatus = Status.LoggedIn;
  Status get loggedInStatus => _loggedInStatus;
  bool isLoading = false;

  Future<Map<String, dynamic>> login({String? email, String? password}) async {
    var result;

    final Map<String, dynamic> body = {
      'username': email,
      'password': password,
      'device_name': 'test'
    };
    _loggedInStatus = Status.Authenticating;
    notifyListeners();
    var url = AppConstants.baseUrl + 'app-login';

    Response response = await post(
      Uri.parse(url),
      body: json.encode(body),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json'
      },
    );
    if (response.statusCode == 200) {
      UserModel userModel = UserModel.fromJson(json.decode(response.body));

      _loggedInStatus = Status.LoggedIn;
      notifyListeners();
      result = {
        'status': true,
        'message': 'Successful',
        'userModel': userModel
      };
    } else {
      _loggedInStatus = Status.NotLoggedIn;
      notifyListeners();
      result = {'status': false, 'message': "An error has occurred"};
    }
    return result;
  }

  Future<Map<String, dynamic>> sendMessage(
      {String? name,
      String? schoolName,
      String? mobileNo,
      String? message}) async {
    var result;

    final Map<String, dynamic> body = {
      'name': name,
      'school': schoolName,
      "email": mobileNo,
      'message': message,
    };
    isLoading = true;
    notifyListeners();
    var url = AppConstants.baseUrl + 'contact-us-mobile';

    Response response = await post(
      Uri.parse(url),
      body: json.encode(body),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json'
      },
    );

    if (response.statusCode == 200) {
      isLoading = false;
      notifyListeners();
      result = {
        'status': true,
        'message': 'Successful',
      };
    } else {
      isLoading = false;
      notifyListeners();
      result = {'status': false, 'message': "An error has occurred"};
    }
    return result;
  }
}

enum Status { NotLoggedIn, LoggedIn, Authenticating, LoggedOut }

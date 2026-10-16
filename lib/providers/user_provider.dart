import 'package:flutter/material.dart';
import '../enums/operation_status.dart';
import '../models/userModel.dart';
import '../utils/dio_api_helper.dart';
import 'package:dio/dio.dart';

class UserProvider with ChangeNotifier {
  late ApiBaseHelper api;

  UserModel _userModel = UserModel();
  UserModel get user => _userModel;

  String _phoneNumber = '';

  bool _showResetFields = false;
  bool get showResetFields => _showResetFields;

  OperationStatus _initializePasswordReset = OperationStatus.Loaded;
  OperationStatus get initializePasswordReset => _initializePasswordReset;

  UserProvider() {
    api = ApiBaseHelper();
  }

  void setUser(UserModel user) {
    _userModel = user;
    notifyListeners();
  }

  void updateToken(String token) async {
    final Map<String, dynamic> body = {
      'device_token': token,
    };

    try {
      return await api.postHTTP('/api/device-token', body);
    } catch (error) {
      print(error);
    }
  }

  Future requestPasswordReset(String phone, context) async {
    final Map<String, dynamic> body = {
      'phone': phone,
    };
    _phoneNumber = phone;
    Response? response;
    _initializePasswordReset = OperationStatus.Loading;
    notifyListeners();
    try {
      response = await api.postHTTP('/initialize-password-reset', body);
      _initializePasswordReset = OperationStatus.Loaded;
      if (response!.statusCode == 200) {
        notifyListeners();
      }
      _initializePasswordReset = OperationStatus.Loaded;
      notifyListeners();
    } catch (error) {
      _initializePasswordReset = OperationStatus.Loaded;
      notifyListeners();
      print('the error is $error');
    }
    return response;
  }

  Future resendTwoFactor() async {
    final Map<String, dynamic> body = {
      'phone': _phoneNumber,
    };
    Response? response;
    _initializePasswordReset = OperationStatus.Loading;
    notifyListeners();
    try {
      response = await api.postHTTP('/initialize-password-reset', body);
      _initializePasswordReset = OperationStatus.Loaded;

      if (response!.statusCode == 200) {
        _showResetFields = true;
        notifyListeners();
      }
      notifyListeners();
    } catch (error) {
      print(error);
    }
    return response;
  }

  Future resetPassword(String twoFactor, String password) async {
    final Map<String, dynamic> body = {
      'phone': _phoneNumber,
      'two_factor': twoFactor,
      'password': password,
    };
    Response? response;
    _initializePasswordReset = OperationStatus.Loading;
    notifyListeners();
    try {
      response = await api.postHTTP('/mobile-password-reset', body);
      _initializePasswordReset = OperationStatus.Loaded;
      notifyListeners();
    } catch (error) {
      print(error);
    }

    return response;
  }

  void resetPasswordParams() {
    _phoneNumber = '';
    _showResetFields = false;
  }
}

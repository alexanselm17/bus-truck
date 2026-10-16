import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:school_tracker/utils/constants.dart';
import '../enums/operation_status.dart';
import '../models/app_user.dart';
import '../models/userModel.dart';
import '../services/NotificationService.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserPreferences with ChangeNotifier {
  late AppUser _appUser;
  AppUser get appUser => _appUser;

  late OperationStatus _fetchingUser = OperationStatus.Loaded;
  OperationStatus get fetchingUserStatus => _fetchingUser;

  UserPreferences() {
    _appUser = AppUser();
  }

  saveUser(UserModel userModel) async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();

    await preferences.setInt("userId", userModel.user!.id!);
    await preferences.setInt("schoolId", userModel.user!.schoolId ?? 0);
    await preferences.setString("name", userModel.user!.name!);
    await preferences.setString("email", userModel.user!.email!);
    await preferences.setString("phone", userModel.user!.phone!);
    await preferences.setInt("status", userModel.user!.status!);
    await preferences.setString("token", userModel.token!);
    await preferences.setString(
        "permissions", jsonEncode(userModel.user!.permissions));

    if (userModel.user!.deviceToken == null ||
        userModel.user!.deviceToken == '') {
      String fcmToken = await NotificationService().updateFcmToken();
      await preferences.setString("deviceToken", fcmToken);
    } else {
      await preferences.setString("deviceToken", userModel.user!.deviceToken);
    }
    if (userModel.user!.permissions!.app!.createTrips == true) {
      await preferences.setInt(AppConstants.ACCOUNT_TYPE, 1);
    }

    notifyListeners();
  }

  getUser() async {
    _fetchingUser = OperationStatus.Loading;
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    int userId = prefs.getInt("userId") ?? 0;
    int schoolId = prefs.getInt("schoolId") ?? 0;
    String name = prefs.getString("name") ?? '';
    String email = prefs.getString("email") ?? '';
    String phone = prefs.getString("phone") ?? '';
    int type = prefs.getInt(AppConstants.ACCOUNT_TYPE) ?? 0;
    int? status = prefs.getInt("status") ?? 0;
    String? token = prefs.getString("token") ?? '';
    String? deviceToken = prefs.getString('deviceToken') ?? '';

    String jsonStr = prefs.getString("permissions") ?? "";
    Permissions permissions;

    try {
      permissions = Permissions.fromJson(jsonDecode(jsonStr));
    } catch (e) {
      permissions = Permissions();
    }

    _fetchingUser = OperationStatus.Loaded;
    notifyListeners();
    _appUser = AppUser(
      userId: userId,
      schoolId: schoolId,
      name: name,
      email: email,
      phone: phone,
      accountType: type,
      status: status,
      token: token,
      deviceToken: deviceToken,
      permissions: permissions,
    );
    notifyListeners();
  }

  Future removeUser() async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.remove("userId");
    await preferences.remove("schoolId");
    await preferences.remove("name");
    await preferences.remove("email");
    await preferences.remove("phone");
    await preferences.remove("accountType");
    await preferences.remove("status");
    await preferences.remove("token");
    await preferences.remove("permissions");
    await preferences.remove("deviceToken");
    await preferences.remove(AppConstants.ACCOUNT_TYPE);
    await preferences.remove(AppConstants.INITIAL_LAUNCH);
    _appUser = AppUser();
    notifyListeners();
  }

  Future<String> getToken() async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    String token = preferences.getString("token") ?? "";
    notifyListeners();
    return token;
  }
}

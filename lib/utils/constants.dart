// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';

class AppConstants {
  static final MapKey = "AIzaSyBO33ijQuaASPcx0qzPEdIHD7FvQzgo8gE";

  static const Color colorPrimary = Color(0xFFFFC400);
  static const Color colorPrimaryDark = Color(0xFFE5A900);
  static const Color navy = Color(0xFF172033);
  static const Color background = Color(0xFFF7F8FA);

  static const Color colorAccent = colorPrimary;
  static const Color white = Color(0xFFFFFFFF);
  static const Color primaryOrange = colorPrimary;
  static const Color lightOrange = Color(0xFFFFF8D9);
  static const Color darkGray = Color(0xFF2D3748);

  // static String baseUrl = 'https://trackitafrica.live/';
  static String baseUrl = 'https://trackitafrica.com/';

  static String get INITIAL_LAUNCH => "initial_launch";
  static String get TOKEN_KEY => "token"; // login token
  static String get FCM_KEY => "fcm_token"; // FCM token
  static String get ACCOUNT_TYPE => "account_type";
  // FCM token
}

enum TripType { DROP, PICK }

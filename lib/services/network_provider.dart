import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class NetworkController extends GetxController {
  final RxInt connectionStatus = 0.obs;

  final Connectivity _connectivity = Connectivity();

  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;

  @override
  void onInit() {
    super.onInit();

    initConnectivity();

    _connectivitySubscription = _connectivity.onConnectivityChanged.listen(
      _updateConnectionStatus,
    );
  }

  @override
  void onClose() {
    _connectivitySubscription.cancel();
    super.onClose();
  }

  Future<void> initConnectivity() async {
    List<ConnectivityResult> results;

    try {
      results = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      debugPrint(
        'Could not check connectivity status: $e',
      );
      return;
    }

    _updateConnectionStatus(results);
  }

  void _updateConnectionStatus(
    List<ConnectivityResult> results,
  ) {
    // No network connection
    if (results.isEmpty || results.contains(ConnectivityResult.none)) {
      connectionStatus.value = 0;

      _showNoInternetSnackbar();

      return;
    }

    // Mobile network
    if (results.contains(ConnectivityResult.mobile)) {
      connectionStatus.value = 2;

      _closeNoInternetSnackbar();

      return;
    }

    // Wi-Fi or any other valid network connection
    if (results.contains(ConnectivityResult.wifi) ||
        results.contains(ConnectivityResult.ethernet) ||
        results.contains(ConnectivityResult.vpn) ||
        results.contains(ConnectivityResult.bluetooth) ||
        results.contains(ConnectivityResult.other)) {
      connectionStatus.value = 1;

      _closeNoInternetSnackbar();

      return;
    }

    // Fallback
    connectionStatus.value = 0;

    Get.snackbar(
      'Network Error',
      'Failed to connect to a network',
    );
  }

  void _showNoInternetSnackbar() {
    // Prevent multiple identical snackbars
    if (Get.isSnackbarOpen) {
      return;
    }

    Get.rawSnackbar(
      messageText: const Text(
        'PLEASE CONNECT TO INTERNET',
        style: TextStyle(
          color: Colors.white,
          fontSize: 14,
        ),
      ),
      isDismissible: false,
      duration: const Duration(days: 1),
      backgroundColor: Colors.red.shade400,
      icon: const Icon(
        Icons.wifi_off,
        color: Colors.white,
        size: 35,
      ),
      margin: EdgeInsets.zero,
      snackStyle: SnackStyle.GROUNDED,
    );
  }

  void _closeNoInternetSnackbar() {
    if (Get.isSnackbarOpen) {
      Get.closeCurrentSnackbar();
    }
  }
}

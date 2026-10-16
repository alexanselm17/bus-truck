import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import '../utils/dio_api_helper.dart';
import '../utils/permision_helper.dart';

class LocationProvider with ChangeNotifier {
  late Position _currentPosition;
  double? latitude, longitude;
  late ApiBaseHelper api;

  Position get userCurrentLocation => _currentPosition;

  LocationProvider() {
    _currentPosition = Position(
      accuracy: 1,
      latitude: 2,
      altitude: 0,
      longitude: 0,
      timestamp: DateTime.now(),
      heading: 0.0,
      speed: 0.0,
      speedAccuracy: 0.0,
      altitudeAccuracy: 0.0,
      headingAccuracy: 0.0,
    );
    setUpPositionLocator();
    api = ApiBaseHelper();
  }

  setUpPositionLocator() async {
    PermissionHelper.permissionForLocation().then((value) {
      Geolocator.getPositionStream(
          locationSettings: LocationSettings(
        accuracy: LocationAccuracy.bestForNavigation,
        distanceFilter: 10,
      )).listen((Position position) {
        _currentPosition = position;
        notifyListeners();
      });
    });
  }

  Future<void> updateTripVehicleLocation({required int vehicleId}) async {
    final Map<String, dynamic> body = {
      'vehicle_id': vehicleId,
      'latitude': _currentPosition.latitude,
      'longitude': _currentPosition.longitude,
    };

    try {
      return await api.postHTTP("/api/driver-current-location", body);
    } catch (e) {
      print(e);
    }
  }
}

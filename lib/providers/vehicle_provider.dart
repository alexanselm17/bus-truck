import 'package:flutter/material.dart';
import '../models/vehicle_list.dart';
import '../models/vehicle_location.dart';
import '../utils/dio_api_helper.dart';
import 'package:dio/dio.dart';

class VehicleProvider with ChangeNotifier {
  List<Vehicle> _vehicles = [];
  List<Vehicle> get vehicles => _vehicles;

  late ApiBaseHelper api;
  VehicleProvider() {
    api = ApiBaseHelper();
  }

  Future getVehicle() async {
    try {
      Response response = await api.getHTTP("/api/vehicles");
      if (response.statusCode == 200) {
        VehicleList vehicleList = VehicleList.fromJson(response.data);
        _vehicles = vehicleList.data!;
        notifyListeners();
      }
    } catch (e) {
      print("catch error $e");
      notifyListeners();
    }
  }

  Future getVehicleLocations(vehicles) async {
    var payload = {
      'vehicles': vehicles,
    };
    try {
      Response response = await api.postHTTP("/api/vehicle-locations", payload);
      if (response.statusCode == 200) {
        return VehicleLocation.fromJson(response.data);
      }
    } catch (e) {}
  }
}

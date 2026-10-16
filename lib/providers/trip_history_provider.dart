import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../enums/operation_status.dart';
import '../models/trip_history.dart';
import '../utils/dio_api_helper.dart';

class TripHistory with ChangeNotifier {
  late ApiBaseHelper api;

  TripHistory() {
    api = ApiBaseHelper();
  }

  late OperationStatus _tripHistoryLoadingStatus;
  OperationStatus get tripHstoryStatus => _tripHistoryLoadingStatus;

  List<History> _tripHistory = [];
  List<History> get getTripHistory => _tripHistory;

  Future fetchTrips(int studentId) async {
    _tripHistoryLoadingStatus = OperationStatus.Loading;

    try {
      Response response = await api.getHTTP(
          '/api/student-trips?filters[]=student_id,eq,$studentId&include=trip.vehicle,trip.driver');
      _tripHistoryLoadingStatus = OperationStatus.Loaded;

      notifyListeners();
      if (response.statusCode == 200) {
        TripHistoryModel history = TripHistoryModel.fromJson(response.data);
        _tripHistory = history.history!;
        notifyListeners();
      }
    } catch (e) {
      print("api response error $e");
      _tripHistoryLoadingStatus = OperationStatus.Error;
      notifyListeners();
    }
  }
}

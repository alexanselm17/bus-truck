import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../enums/operation_status.dart';
import '../models/driver_trip.dart';
import '../models/pending_students.dart';
import '../models/school_list.dart';
import '../utils/dio_api_helper.dart';
import '../utils/strings.dart';

class DriverProvider with ChangeNotifier {
  List<Trip> _driverTrip = [];

  List<Trip> get driverTrips => _driverTrip;
  late OperationStatus _getDriverTripStatus;
  OperationStatus get getDriverTripStatus => _getDriverTripStatus;

  late OperationStatus _tripCreationStatus;
  OperationStatus get tripCreationStatus => _tripCreationStatus;

  List<PendingStudents> _pendingStudents = [];
  List<PendingStudents> get pendingStudents => _pendingStudents;

  List<PendingStudents> _pendingStudent = [];
  List<PendingStudents> get pendingStudent => _pendingStudent;

  late int _pageNumber = 1;
  int get pageNumber => _pageNumber;

  late OperationStatus _pendingStudentLoadingStatus;
  OperationStatus get pendingStudentLoadingStatus =>
      _pendingStudentLoadingStatus;

  late OperationStatus _dispatchRefresh;
  OperationStatus get dispatchRefresh => _dispatchRefresh;

  late OperationStatus _dropStudenStatus;
  OperationStatus get dropStudentStatus => _dropStudenStatus;

  late OperationStatus _pickStudentStatus;
  OperationStatus get pickStudentStatus => _pickStudentStatus;

  late bool _hasMoreStudentsOnTrip = false;
  bool get hasMoreStudentsOnTrip => _hasMoreStudentsOnTrip;

  late OperationStatus _endTripStatus;
  OperationStatus get endTripStatus => _endTripStatus;

  late OperationStatus _searchingPendingStudent;
  OperationStatus get searchingPendingStudent => _searchingPendingStudent;

  late OperationStatus _fetchingSchoolStatus;
  OperationStatus get fetchingSchoolStatus => _fetchingSchoolStatus;

  late Schools _school = Schools();
  Schools get school => _school;
  late ApiBaseHelper api;

  DriverProvider() {
    api = ApiBaseHelper();
    _searchingPendingStudent = OperationStatus.Loaded;
    _endTripStatus = OperationStatus.Loaded;
    _tripCreationStatus = OperationStatus.Loaded;
    _fetchingSchoolStatus = OperationStatus.Loaded;
    _pickStudentStatus = OperationStatus.Loaded;
    _dropStudenStatus = OperationStatus.Loaded;
    _getDriverTripStatus = OperationStatus.Loaded;
    _dispatchRefresh = OperationStatus.Loaded;
    _pendingStudentLoadingStatus = OperationStatus.Loaded;
  }

  Future getPendingStudents({int? tripId}) async {
    _pendingStudentLoadingStatus = OperationStatus.Loading;
    notifyListeners();
    try {
      Response response =
          await api.getHTTP("/api/trip-pending-students/$tripId");

      if (response.statusCode == 200) {
        PendingStudentModel res = PendingStudentModel.fromJson(response.data);
        _pendingStudents = res.pendingStudents!.data!;
        _pendingStudent = res.pendingStudents!.data!;
        _pendingStudentLoadingStatus = OperationStatus.Loaded;
        notifyListeners();
      }
    } catch (e) {
      _pendingStudentLoadingStatus = OperationStatus.Error;
      notifyListeners();
    }
  }

  Future<void> getPendingStudentsPaginated({int? tripId}) async {
    _dispatchRefresh = OperationStatus.Loading;
    notifyListeners();
    try {
      Response response = await api.getHTTP(
          "/api/trip-pending-students/$tripId?perPage=25&page=$_pageNumber");
      print(response.data);
      if (response.statusCode == 200) {
        print(response.data);
        PendingStudentModel res = PendingStudentModel.fromJson(response.data);
        _pendingStudent = res.pendingStudents!.data!;
        _dispatchRefresh = OperationStatus.Loaded;
        _pageNumber = _pageNumber + 1;
        notifyListeners();
        if (pageNumber > response.data['last_page']) {
          _hasMoreStudentsOnTrip = false;
        }
        notifyListeners();
      }
    } catch (e) {
      _dispatchRefresh = OperationStatus.Error;
      notifyListeners();
    }
  }

  Future searchPendingStudents(
      {required dynamic searchQuery, required int tripId}) async {
    _searchingPendingStudent = OperationStatus.Loading;
    notifyListeners();
    try {
      Response response =
          await api.getHTTP("/api/trip-pending-students/$tripId/$searchQuery");

      if (response.statusCode == 200) {
        PendingStudentModel res = PendingStudentModel.fromJson(response.data);
        _pendingStudent = res.pendingStudents!.data!;
        _searchingPendingStudent = OperationStatus.Loaded;

        notifyListeners();
      }
    } catch (e) {
      _searchingPendingStudent = OperationStatus.Error;
      notifyListeners();
      notifyListeners();
    }
  }

  Future<bool> endTrip({
    int? tripId,
  }) async {
    bool result = false;
    _endTripStatus = OperationStatus.Loading;
    notifyListeners();
    final Map<String, dynamic> body = {
      'end_at': AppStrings.currentTime().toString()
    };

    try {
      _endTripStatus = OperationStatus.Loaded;
      notifyListeners();
      Response response = await api.putHTTP("/api/trips/$tripId", body);
      if (response.statusCode == 200) {
        result = true;
        // getDriverTrips();
      } else {
        result = false;
      }
    } catch (e) {
      print('am catch $e');
      _endTripStatus = OperationStatus.Error;
    }
    return result;
  }

  Future<bool> dropStudent(
      {double? lat, double? long, int? studentId, int? tripId}) async {
    _dropStudenStatus = OperationStatus.Loading;
    notifyListeners();
    bool result = false;
    final Map<String, dynamic> body = {
      'latitude': lat,
      'longitude': long,
      'trip_id': tripId
    };

    try {
      Response response =
          await api.putHTTP("/api/driver-drop-student/$studentId", body);
      _dropStudenStatus = OperationStatus.Loaded;
      notifyListeners();
      if (response.statusCode == 200) {
        int index =
            _pendingStudents.indexWhere((element) => element.id == studentId);
        if (index >= 0) {
          _pendingStudents.removeAt(index);
          notifyListeners();
        }
        result = true;
      } else {
        result = false;
      }
    } catch (e) {
      _dropStudenStatus = OperationStatus.Error;
      notifyListeners();
      print('am catch $e');
    }
    return result;
  }

  Future<bool> pickStudent(
      {double? lat, double? long, int? studentId, int? tripId}) async {
    _pickStudentStatus = OperationStatus.Loading;
    notifyListeners();
    bool result = false;
    final Map<String, dynamic> body = {
      'latitude': lat,
      'longitude': long,
      'trip_id': tripId
    };

    try {
      Response response =
          await api.putHTTP("/api/driver-pick-student/$studentId", body);
      _pickStudentStatus = OperationStatus.Loaded;
      notifyListeners();
      if (response.statusCode == 200) {
        int index =
            _pendingStudents.indexWhere((element) => element.id == studentId);
        if (index >= 0) {
          _pendingStudents.removeAt(index);
          notifyListeners();
        }
        result = true;
      } else {
        result = false;
      }
    } catch (e) {
      print('am catch $e');
      _pickStudentStatus = OperationStatus.Error;
      notifyListeners();
    }
    return result;
  }

  Future<bool> skipStudent(
      {double? lat,
      double? long,
      int? studentId,
      int? tripId,
      String? reason}) async {
    _pickStudentStatus = OperationStatus.Loading;
    notifyListeners();
    bool result = false;
    final Map<String, dynamic> body = {
      'reason': reason,
      'latitude': lat,
      'longitude': long,
      'trip_id': tripId
    };

    try {
      Response response =
          await api.putHTTP("/api/driver-skip-student/$studentId", body);
      if (response.statusCode == 200) {
        int index =
            _pendingStudents.indexWhere((element) => element.id == studentId);
        if (index >= 0) {
          _pendingStudents.removeAt(index);
          notifyListeners();
        }
        result = true;
      } else {
        result = false;
      }
      _pickStudentStatus = OperationStatus.Loaded;
      notifyListeners();
    } catch (e) {
      print('am catch $e');
      _pickStudentStatus = OperationStatus.Error;
      notifyListeners();
    }
    return result;
  }

  Future<Response> createTrip(
      {int? vehicleId,
      int? dispatchId,
      int? driverId,
      double? latitude,
      double? longitude,
      int? type}) async {
    Response? response;
    final Map<String, dynamic> body = {
      'vehicle_id': vehicleId,
      'dispatch_id': dispatchId,
      'driver_id': driverId,
      'start_at': AppStrings.currentTime().toString(),
      'latitude': latitude,
      'longitude': longitude,
      'type': type
    };

    _tripCreationStatus = OperationStatus.Loading;
    notifyListeners();
    try {
      response = await api.postHTTP("/api/trips", body);

      notifyListeners();
    } catch (e) {
      print(e);
    } finally {
      _tripCreationStatus = OperationStatus.Loaded;
      notifyListeners();
    }
    return response!;
  }

  Future getDriverTrips(int driverId) async {
    _getDriverTripStatus = OperationStatus.Loading;
    notifyListeners();

    try {
      final Response response = await api.getHTTP(
          "/api/trips?filters[]=driver_id,eq,$driverId&sort=-created_at&include=dispatch,vehicle&page=1&perPage=2");
      if (response.statusCode == 200) {
        DriverTripModel driverTripModel =
            DriverTripModel.fromJson(response.data);
        _driverTrip = driverTripModel.trip!;
      }
      _getDriverTripStatus = OperationStatus.Loaded;
    } catch (e) {
      print(e);
      _getDriverTripStatus = OperationStatus.Error;
    } finally {
      notifyListeners();
    }
  }

  Future getAttachedSchool() async {
    _fetchingSchoolStatus = OperationStatus.Loading;
    notifyListeners();
    try {
      final Response response =
          await api.getHTTP("/api/driver-attached-school");
      if (response.statusCode == 200) {
        Schools school = Schools.fromJson(response.data['data']);
        _school = school;
      }
      _fetchingSchoolStatus = OperationStatus.Loaded;
    } catch (e) {
      print(e);
      _fetchingSchoolStatus = OperationStatus.Error;
    } finally {
      notifyListeners();
    }
  }
}

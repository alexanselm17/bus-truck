import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:school_tracker/models/guardian_model.dart';
import '../enums/operation_status.dart';
import '../models/LocationPendingApproval.dart';
import '../models/parent/my_student_list.dart';
import '../utils/dio_api_helper.dart';

class StudentProvider with ChangeNotifier {
  late Student _selected;
  Student get selected => _selected;

  Data? _studentGuardians;
  Data? get studentGuardian => _studentGuardians;

  late LocationPendingApproval _pendingLocation;
  LocationPendingApproval get pendingLocation => _pendingLocation;

  late OperationStatus _guardianLoadingStatus;
  OperationStatus get guardianLoadingStatus => _guardianLoadingStatus;

  late OperationStatus _removingGuardian;
  OperationStatus get removingGuardianStatus => _removingGuardian;

  late OperationStatus _updateStudentLocationStatus;
  OperationStatus get updateStudentLocationStatus =>
      _updateStudentLocationStatus;
  late ApiBaseHelper api;

  StudentProvider() {
    _updateStudentLocationStatus = OperationStatus.Loaded;
    _pendingLocation = LocationPendingApproval();
    api = ApiBaseHelper();
  }
  void setSelected(Student student) {
    _selected = student;
    notifyListeners();
    fetchStudentGuardian();
  }

  Future fetchStudent(int id) async {
    Response? response;
    try {
      response =
          await api.getHTTP("/api/students/$id?includes[]=parent,guardians");
    } catch (error) {
      print(error);
    }
    return response;
  }

  Future fetchStudentGuardian() async {
    _guardianLoadingStatus = OperationStatus.Loading;
    try {
      Response response =
          await api.getHTTP('/api/students/${selected.id}?include=guardians');
      _guardianLoadingStatus = OperationStatus.Loaded;
      notifyListeners();
      if (response.statusCode == 200) {
        GuardianModel guardianModel = GuardianModel.fromJson(response.data);
        _studentGuardians = guardianModel.data!;
        notifyListeners();
      }
    } catch (e) {
      _guardianLoadingStatus = OperationStatus.Error;
      notifyListeners();
    }
  }

  Future removeGuardian(int guardianId) async {
    _removingGuardian = OperationStatus.Loading;
    notifyListeners();
    final Map<String, dynamic> body = {
      'guardian_id': guardianId,
      'student_id': selected.id,
    };
    try {
      Response response =
          await api.postHTTP("/api/student-detach-guardian", body);
      if (response.statusCode == 200) {
        _studentGuardians!.guardians
            .removeWhere((item) => item.id == guardianId);
        notifyListeners();

        _removingGuardian = OperationStatus.Loaded;
        notifyListeners();

        return true;
      } else {
        return false;
      }
    } catch (e) {
      print('am catch $e');
    }
  }

  Future toggleStatus(int guardianId) async {
    _removingGuardian = OperationStatus.Loading;
    notifyListeners();
    final Map<String, dynamic> body = {
      'guardian_id': guardianId,
      'student_id': selected.id,
    };
    try {
      Response response =
          await api.postHTTP("/api/student-toggle-guardian", body);
      if (response.statusCode == 200) {
        //Todo just toggle the guardian in selected, look at delete guardian!!
        fetchStudentGuardian();

        return true;
      } else {
        return false;
      }
    } catch (e) {
      print('am catch $e');
    }
  }

  Future<Response> addGuardian({
    String? name,
    String? email,
    String? phoneNumber,
    String? relation,
  }) async {
    Response? _response;
    final Map<String, dynamic> body = {
      'name': name,
      'email': email,
      'phone': phoneNumber,
      'student_id': selected.id,
      'relation': relation,
      'account_type': 5
    };
    _guardianLoadingStatus = OperationStatus.Loading;
    notifyListeners();
    try {
      _response = await api.postHTTP("/api/guardians", body);
      _guardianLoadingStatus = OperationStatus.Loaded;
      notifyListeners();

      if (_response!.statusCode == 200) {
        // Todo use back end response and add to list instead of refetching!!
        fetchStudentGuardian();
      }
      return _response;
    } catch (e) {
      print('am catch $e');
    } finally {
      _guardianLoadingStatus = OperationStatus.Loaded;
      notifyListeners();
    }
    return _response!;
  }

  Future<bool> updateStudentLocation({
    Student? student,
    double? latitude,
    double? longitude,
    String? locationName,
    int? userId,
  }) async {
    bool? result;
    final Map<String, dynamic> body = {
      'student_id': student!.id,
      'location_name': locationName ?? student.locationName,
      'latitude': latitude,
      'longitude': longitude,
      'requester_id': userId,
    };
    _updateStudentLocationStatus = OperationStatus.Loading;
    notifyListeners();

    try {
      Response response = await api.postHTTP("/api/student-locations", body);
      _updateStudentLocationStatus = OperationStatus.Loaded;
      notifyListeners();
      if (response.statusCode == 200 || response.statusCode == 201) {
        getLocationPendingApproval();
        result = true;
      } else {
        result = false;
      }
    } catch (e) {
      print('am catch $e');
    }
    return result!;
  }

  Future getLocationPendingApproval() async {
    try {
      Response response = await api.getHTTP(
          "/api/student-locations?filters[]=student_id,eq," +
              selected.id.toString() +
              "&sort=-id");
      if (response.data['data'] != null) {
        LocationPendingApproval studentNewLocation =
            LocationPendingApproval.fromJson(response.data['data'][0]);
        _pendingLocation = studentNewLocation;
        notifyListeners();
      }
    } catch (e) {
      print(e);
    }
  }
}

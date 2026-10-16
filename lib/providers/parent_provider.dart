import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import '../enums/operation_status.dart';
import '../models/parent/active_student_model.dart';
import '../models/parent/my_student_list.dart';
import '../models/school_list.dart';
import '../models/student_guardian.dart';
import '../utils/dio_api_helper.dart';

class ParentProvider with ChangeNotifier {
  List<Student> _myStudent = [];
  List<Student> get myStudents => _myStudent;

  late OperationStatus _myStudentLoadingStatus;
  OperationStatus get myStudentLoadingStatus => _myStudentLoadingStatus;

  List<ActiveStudents> _activeStudents = [];
  List<ActiveStudents> get myActiveStudents => _activeStudents;

  List<ActiveStudents> _activeStudent = [];
  List<ActiveStudents> get myActiveStudent => _activeStudent;

//TYPE anotation required here
  var _guardians = [];
  List get getGuardians => _guardians;

  late OperationStatus _guardianLoadingStatus;
  OperationStatus get guardianLoadingStatus => _guardianLoadingStatus;

  late OperationStatus _guardianPickingStudentStatus;
  OperationStatus get guardianPickingStudentLoadingStatus =>
      _guardianPickingStudentStatus;

  late OperationStatus _activeStudentLoadingStatus;
  OperationStatus get activeStudentLoadingStatus => _activeStudentLoadingStatus;

  late OperationStatus _gettingSchools;
  OperationStatus get gettingSchools => _gettingSchools;

  List<Schools> _schools = [];
  List<Schools> get parentSchools => List<Schools>.from(_schools);

  bool _isThereStudentsOnRout = false;
  bool get onRoute => _isThereStudentsOnRout;

  late ApiBaseHelper api;

  ParentProvider() {
    _guardianPickingStudentStatus = OperationStatus.Loaded;
    api = ApiBaseHelper();
  }

  Future getMyStudents() async {
    _myStudentLoadingStatus = OperationStatus.Loading;
    try {
      Response response = await api.getHTTP("/api/students?include=guardians");
      _myStudentLoadingStatus = OperationStatus.Loaded;
      notifyListeners();
      if (response.statusCode == 200) {
        MyStudentModel res = MyStudentModel.fromJson(response.data);
        _myStudent = res.data!;
        notifyListeners();
      }
    } catch (e) {
      print("catch error mee $e");
      _myStudentLoadingStatus = OperationStatus.Error;
      notifyListeners();
    }
  }

  Future fetchStudentGuardian(int studentId) async {
    _guardianLoadingStatus = OperationStatus.Loading;
    notifyListeners();
    try {
      Response response =
          await api.getHTTP('/api/students/$studentId?include=guardians');
      _guardianLoadingStatus = OperationStatus.Loaded;
      notifyListeners();
      if (response.statusCode == 200) {
        StudentGuardian studentdetails =
            StudentGuardian.fromJson(response.data);
        _guardians = studentdetails.data!.guardians!;
        notifyListeners();
      }
    } catch (e) {
      print("api response error $e");
      _guardianLoadingStatus = OperationStatus.Error;
      notifyListeners();
    }
  }

  Future getParentSchools() async {
    _gettingSchools = OperationStatus.Loading;
    notifyListeners();
    try {
      Response response = await api.getHTTP('/api/parent-schools');
      SchoolList schools = SchoolList.fromJson(response.data);
      _schools = schools.schools!;
      notifyListeners();
    } catch (e) {
      print(e);
    } finally {
      _gettingSchools = OperationStatus.Loaded;
      notifyListeners();
    }
  }

  getMyActiveStudents({int? dispatchId}) async {
    _activeStudentLoadingStatus = OperationStatus.Loading;
    // try {
    Response response = await api.getHTTP("/api/active-trips");
    _activeStudentLoadingStatus = OperationStatus.Loaded;
    notifyListeners();
    if (response.statusCode == 200) {
      ActiveStudentModel res = ActiveStudentModel.fromJson(response.data);
      _activeStudents = res.data!;
      // Logger().i(response.data.toString());

      notifyListeners();
    }
    // } catch (e) {23
    //   print("catch error mee $e");
    //   _activeStudentLoadingStatus = OperationStatus.Error;
    //   notifyListeners();
    // }
  }

  Future isThereStudentsOnRoute() async {
    try {
      Response response = await api.getHTTP("/api/active-trips");
      Logger().i(response.data);
      if (response.statusCode == 200) {
        ActiveStudentModel res = ActiveStudentModel.fromJson(response.data);
        _activeStudent = res.data!;
        notifyListeners();
      }
    } catch (e) {
      print("catch error mee $e");
    }
  }

  Future<Response> pickMyStudent({
    int? studentId,
    double? pickedLocationLatitude,
    double? pickedLocationLongitude,
    int? tripId,
  }) async {
    Response? response;
    final Map<String, dynamic> body = {
      'latitude': pickedLocationLatitude,
      'longitude': pickedLocationLongitude,
      'trip_id': tripId,
    };

    _guardianPickingStudentStatus = OperationStatus.Loading;
    notifyListeners();
    try {
      response =
          await api.putHTTP("/api/guardian-pick-student/$studentId", body);

      notifyListeners();
    } catch (e) {
      print(e);
    } finally {
      _guardianPickingStudentStatus = OperationStatus.Loaded;
      notifyListeners();
    }
    return response!;
  }
}

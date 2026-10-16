import 'package:flutter/material.dart';
import '../models/dispatch_model.dart';
import '../utils/dio_api_helper.dart';
import 'package:dio/dio.dart';

class DispatchProvider with ChangeNotifier {
  List<Dispatch> _dispatch = [];
  List<Dispatch> get dispatches => _dispatch;
  late ApiBaseHelper api;

  DispatchProvider() {
    api = ApiBaseHelper();
  }

  Future getDispatches() async {
    print("getting dispatches called");
    try {
      Response response = await api.getHTTP("/api/dispatches");
      if (response.statusCode == 200) {
        DispatchModel dispatch = DispatchModel.fromJson(response.data);
        _dispatch = dispatch.data!;
        notifyListeners();
      }
    } catch (e) {
      print("catch error $e");
      notifyListeners();
    }
  }
}

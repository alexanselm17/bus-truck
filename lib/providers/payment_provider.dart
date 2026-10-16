import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../enums/operation_status.dart';
import '../models/payment_history_model.dart';
import '../models/payment_plans_model.dart';
import '../utils/dio_api_helper.dart';

class PaymentProvider with ChangeNotifier {
  late ApiBaseHelper api;

  List<Plan> paymentPlan = [];

  late OperationStatus paymentPlanStatus;

  late OperationStatus _makePaymentStatus;
  OperationStatus get makePaymentStatus => _makePaymentStatus;

  List<Data?> _paymentHistory = [];
  List<Data?> get paymentHistory => _paymentHistory;

  PaymentProvider() {
    api = ApiBaseHelper();
    _makePaymentStatus = OperationStatus.Loaded;
  }
  Future getPaymentPlans() async {
    paymentPlanStatus = OperationStatus.Loading;
    try {
      Response response = await api.getHTTP('/api/plans');
      notifyListeners();
      print(response.data);

      if (response.statusCode == 200) {
        paymentPlanStatus = OperationStatus.Loaded;
        PaymentPlanModel paymentPlanModel =
            PaymentPlanModel.fromJson(response.data);
        paymentPlan = paymentPlanModel.plan!;
        print("length  ${paymentPlan.length}");
        notifyListeners();
      }
    } catch (e) {
      paymentPlanStatus = OperationStatus.Error;
      print("api response error $e");
      notifyListeners();
    }
  }

  Future<bool> makePayment({int? studentId, int? planId}) async {
    _makePaymentStatus = OperationStatus.Loading;
    notifyListeners();
    bool result = false;
    final Map<String, dynamic> body = {
      'plan_id': planId,
      'student_id': studentId,
    };

    try {
      Response response = await api.postHTTP("/api/make-payment", body);
      if (response.statusCode == 200) {
        result = true;
      } else {
        result = false;
      }
    } catch (e) {
      print('am catch $e');
    } finally {
      _makePaymentStatus = OperationStatus.Loaded;
      notifyListeners();
    }
    return result;
  }

  Future<Response?> getPaymentHistory() async {
    _makePaymentStatus = OperationStatus.Loading;
    Response? response;
    try {
      response = await api.getHTTP("/api/transactions");
      PaymentHistoryModel paymentData =
          PaymentHistoryModel.fromJson(response!.data["data"]);
      _paymentHistory = paymentData.data!;
    } catch (e) {
      print(e);
    } finally {
      _makePaymentStatus = OperationStatus.Loaded;
      notifyListeners();
    }
    return response;
  }
}

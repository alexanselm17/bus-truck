import 'package:flutter/material.dart';

class AppState extends ChangeNotifier {
  int selectedPlanId = 0;

  void updateSelectedPlanId(int planId) {
    this.selectedPlanId = planId;
    notifyListeners();
  }
}

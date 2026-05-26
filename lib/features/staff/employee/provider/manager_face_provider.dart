import 'package:flutter/material.dart';

import '../model/manager_employee_detail_model.dart';
import '../repo/manager_face_repo.dart';

class ManagerFaceProvider extends ChangeNotifier {
  final ManagerFaceRepo repo = ManagerFaceRepo();

  bool isLoading = false;

  ManagerEmployeeDetailModel? detailModel;

  int currentStep = 1;

  int? selectedUid;

  // Future<void> getEmployeeDetail(
  //   int uid,
  // ) async {
  //   try {
  //     isLoading = true;
  //
  //     selectedUid = uid;
  //
  //     notifyListeners();
  //
  //     detailModel = await repo.getEmployeeDetail(
  //       uid,
  //     );
  //   } finally {
  //     isLoading = false;
  //     notifyListeners();
  //   }
  // }

  void nextStep() {
    currentStep++;
    notifyListeners();
  }

  void previousStep() {
    currentStep--;
    notifyListeners();
  }
}

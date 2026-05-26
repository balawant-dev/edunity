import 'package:flutter/material.dart';

import '../model/onbehalf_employee_model.dart';
import '../repo/onbehalf_employee_repository.dart';

class OnBehalfEmployeeProvider extends ChangeNotifier {
  final OnBehalfEmployeeRepository repository = OnBehalfEmployeeRepository();

  bool isLoading = false;

  OnBehalfEmployeeModel? employeeModel;

  Future<void> getActiveEmployees() async {
    try {
      isLoading = true;
      notifyListeners();

      employeeModel = await repository.getActiveEmployees();
    } catch (e) {
      debugPrint(
        e.toString(),
      );
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}

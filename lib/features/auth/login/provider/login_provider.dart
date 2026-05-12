
import 'package:flutter/material.dart';

import '../../../../core/services/local_storage_service.dart';
import '../../../../core/utils/app_toast.dart';

import '../../college_code/model/college_code_model.dart';

import '../model/login_model.dart';
import '../repo/login_repo.dart';


class LoginProvider extends ChangeNotifier {

  final TextEditingController
  userIdController =
  TextEditingController();

  final TextEditingController
  dobController =
  TextEditingController();

  final TextEditingController
  passwordController =
  TextEditingController();

  final LoginRepository repository =
  LoginRepository();
  bool obscureCurrent = true;
  bool isLoading = false;

  LoginModel? loginModel;

  CollegeModel? collegeData;

  void toggleCurrent(){

    obscureCurrent = !obscureCurrent;
    notifyListeners();
  }

  void setCollegeData(
      CollegeModel data){

    collegeData = data;

    notifyListeners();
  }

  Future<void> selectDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
    );

    if (pickedDate != null) {
      // UI ke liye: DD-MM-YYYY
      String formattedUI = "${pickedDate.day.toString().padLeft(2, '0')}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.year}";

      dobController.text = formattedUI;
      notifyListeners();
    }
  }

  Future<void> login(
      BuildContext context) async {

    try{

      isLoading = true;

      notifyListeners();
      List<String> parts = dobController.text.split('-');
      String apiDob = "${parts[2]}-${parts[1]}-${parts[0]}"; // YYYY-MM-DD
      loginModel =
      await repository.login(

        collegeId:
        collegeData?.data.name ?? "",

        userId:
        userIdController.text.trim(),

        dob:
        apiDob,

        password:
        passwordController.text.trim(),
      );

      /// SAVE TOKEN
      await LocalStorageService
          .saveToken(
        loginModel?.accessToken ?? "",
      );

      AppToast.show(
        "Login Success",
        backgroundColor: Colors.green,
      );

    }catch(e){

      AppToast.show(
        e.toString(),
        backgroundColor: Colors.red,
      );

    }finally{

      isLoading = false;

      notifyListeners();
    }
  }

  @override
  void dispose() {

    userIdController.dispose();

    dobController.dispose();

    passwordController.dispose();

    super.dispose();
  }
}
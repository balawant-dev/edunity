
import 'package:flutter/material.dart';

import '../../../../core/routes/app_routes.dart';
import '../../../../core/utils/app_toast.dart';

import '../model/change_password_model.dart';
import '../repo/change_password_repo.dart';
// import '../repo/reset_password_repository.dart';

class ChangePasswordProvider
    extends ChangeNotifier {
    final TextEditingController currentPasswordController =
  TextEditingController();

  final TextEditingController
  newPasswordController =
  TextEditingController();

  final TextEditingController
  confirmPasswordController =
  TextEditingController();

  final ChangePasswordRepository
  repository =
  ChangePasswordRepository();
  bool obscureCurrent = true;
  bool obscureNew = true;

  bool obscureConfirm = true;

  bool isLoading = false;

  String userId = "";

  String otp = "";

    ChangePasswordModel?
  changePasswordModel;
  void toggleCurrent(){

    obscureCurrent = !obscureCurrent;
    notifyListeners();
  }

  void toggleNew(){

    obscureNew = !obscureNew;
    notifyListeners();
  }

  void toggleConfirm(){

    obscureConfirm = !obscureConfirm;
    notifyListeners();
  }
  void setData({

    required String userId,

    required String otp,

  }){

    this.userId = userId;

    this.otp = otp;
  }

  Future<void> resetPassword(
      BuildContext context) async {

    if(newPasswordController.text !=
        confirmPasswordController.text){

      AppToast.show(
        "Password not matched",
        backgroundColor: Colors.red,
      );

      return;
    }

    try{

      isLoading = true;

      notifyListeners();

      changePasswordModel =
      await repository
          .resetPassword(

        currentPassword: currentPasswordController.text.trim(),



        newPassword:
        newPasswordController.text
            .trim(),

        confirmPassword:
        confirmPasswordController
            .text
            .trim(),
      );

      AppToast.show(

        changePasswordModel?.message
            ??
            "",

        backgroundColor:
        Colors.green,
      );

      // if(context.mounted){
      //
      //   Navigator.pushNamedAndRemoveUntil(
      //
      //     context,
      //
      //     AppRoutes.collegeCode,
      //
      //         (route) => false,
      //   );
      // }

    }catch(e){
      print("Exception error");
      print(e.toString(),);

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

    newPasswordController.dispose();

    confirmPasswordController.dispose();

    super.dispose();
  }
}
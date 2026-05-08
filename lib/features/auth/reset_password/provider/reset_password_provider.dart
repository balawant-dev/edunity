import 'package:flutter/material.dart';

class ResetPasswordProvider extends ChangeNotifier {

  final TextEditingController currentPasswordController =
  TextEditingController();

  final TextEditingController newPasswordController =
  TextEditingController();

  final TextEditingController confirmPasswordController =
  TextEditingController();

  bool obscureCurrent = true;

  bool obscureNew = true;

  bool obscureConfirm = true;

  bool isLoading = false;

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

  Future<void> resetPassword(
      BuildContext context,
      ) async {

    if(newPasswordController.text !=
        confirmPasswordController.text){

      _showMessage(
        context,
        "Password does not match",
      );

      return;
    }

    try{

      isLoading = true;
      notifyListeners();

      await Future.delayed(
        const Duration(seconds: 2),
      );

      _showMessage(
        context,
        "Password Updated Successfully",
      );

    }catch(e){

      _showMessage(context, e.toString());

    }finally{

      isLoading = false;
      notifyListeners();
    }
  }

  void _showMessage(
      BuildContext context,
      String message,
      ){

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  void dispose() {

    currentPasswordController.dispose();

    newPasswordController.dispose();

    confirmPasswordController.dispose();

    super.dispose();
  }
}
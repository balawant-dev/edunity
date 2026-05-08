import 'package:flutter/material.dart';

import '../../../../core/routes/app_routes.dart';

class ForgotPasswordProvider extends ChangeNotifier {

  final TextEditingController idController =
  TextEditingController();

  final TextEditingController emailPhoneController =
  TextEditingController();

  final TextEditingController aadhaarController =
  TextEditingController();

  bool isLoading = false;

  Future<void> sendOtp(BuildContext context) async {

    if(idController.text.trim().isEmpty){
      _showMessage(context, "Please enter your ID");
      return;
    }

    if(emailPhoneController.text.trim().isEmpty){
      _showMessage(context, "Please enter email or phone");
      return;
    }

    if(aadhaarController.text.trim().isEmpty){
      _showMessage(context, "Please enter Aadhaar number");
      return;
    }

    try{

      isLoading = true;
      notifyListeners();

      await Future.delayed(const Duration(seconds: 2));

      if(context.mounted){
        Navigator.pushNamed(context, AppRoutes.otp);

      //  Navigator.pushNamed(context, "/otp");
      }

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

    idController.dispose();

    emailPhoneController.dispose();

    aadhaarController.dispose();

    super.dispose();
  }
}
// import 'dart:async';
//
// import 'package:flutter/material.dart';
//
// import '../../../../core/routes/app_routes.dart';
//
// class OtpProvider extends ChangeNotifier {
//
//   final List<TextEditingController> otpControllers =
//   List.generate(
//     6,
//         (_) => TextEditingController(),
//   );
//
//   bool isLoading = false;
//
//   int seconds = 59;
//
//   Timer? _timer;
//
//   OtpProvider(){
//     startTimer();
//   }
//
//   void startTimer(){
//
//     seconds = 59;
//
//     _timer?.cancel();
//
//     _timer = Timer.periodic(
//       const Duration(seconds: 1),
//           (timer){
//
//         if(seconds > 0){
//
//           seconds--;
//
//           notifyListeners();
//
//         }else{
//
//           timer.cancel();
//         }
//       },
//     );
//   }
//
//   Future<void> verifyOtp(BuildContext context) async {
//
//     String otp = otpControllers
//         .map((e) => e.text)
//         .join();
//
//     if(otp.length != 6){
//
//       _showMessage(
//         context,
//         "Please enter valid OTP",
//       );
//
//       return;
//     }
//
//     try{
//
//       isLoading = true;
//       notifyListeners();
//
//       await Future.delayed(
//         const Duration(seconds: 2),
//       );
//
//       if(context.mounted){
//
//         Navigator.pushNamed(
//           context,
//           AppRoutes.resetPassword,
//         );
//       }
//
//     }catch(e){
//
//       _showMessage(context, e.toString());
//
//     }finally{
//
//       isLoading = false;
//       notifyListeners();
//     }
//   }
//
//   void resendOtp(BuildContext context){
//
//     startTimer();
//
//     _showMessage(context, "OTP Resent");
//   }
//
//   void _showMessage(
//       BuildContext context,
//       String message,
//       ){
//
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text(message)),
//     );
//   }
//
//   @override
//   void dispose() {
//
//     for(var controller in otpControllers){
//       controller.dispose();
//     }
//
//     _timer?.cancel();
//
//     super.dispose();
//   }
// }



/// ===============================
/// 9. OTP PROVIDER
/// ===============================

import 'dart:async';

import 'package:flutter/material.dart';

import '../../../../core/routes/app_routes.dart';
import '../../../../core/utils/app_toast.dart';

import '../../forgot_password/model/forgot_password_model.dart';

import '../model/otp_model.dart';
import '../repo/otp_repo.dart';
// import '../repo/otp_repository.dart';

class OtpProvider
    extends ChangeNotifier {

  final OtpRepository repository =
  OtpRepository();

  final List<TextEditingController>
  otpControllers =

  List.generate(
    6,
        (_) => TextEditingController(),
  );

  bool isLoading = false;

  int seconds = 59;

  Timer? _timer;

  ForgotPasswordModel?
  forgotData;

  OtpModel? otpModel;

  void setForgotData(
      ForgotPasswordModel data){

    forgotData = data;
  }

  OtpProvider(){
    startTimer();
  }

  void startTimer(){

    seconds = 59;

    _timer?.cancel();

    _timer = Timer.periodic(

      const Duration(seconds: 1),

          (timer){

        if(seconds > 0){

          seconds--;

          notifyListeners();

        }else{

          timer.cancel();
        }
      },
    );
  }

  Future<void> verifyOtp(
      BuildContext context) async {

    String otp =
    otpControllers
        .map((e) => e.text)
        .join();

    if(otp.length != 6){

      AppToast.show(
        "Please enter valid OTP",
      );

      return;
    }

    try{

      isLoading = true;

      notifyListeners();

      otpModel =
      await repository.verifyOtp(

        userId:
        forgotData?.userId ?? "",

        otp: otp,
      );

      AppToast.show(

        otpModel?.message ?? "",

        backgroundColor:
        Colors.green,
      );

      if(context.mounted){

        Navigator.pushNamed(

          context,

          AppRoutes.resetPassword,

          arguments: {

            "user_id":
            forgotData?.userId,

            "otp": otp,
          },
        );
      }

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

    for(var controller
    in otpControllers){

      controller.dispose();
    }

    _timer?.cancel();

    super.dispose();
  }
}
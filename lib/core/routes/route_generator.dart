// import 'package:flutter/material.dart';
//
// import '../../features/auth/forgot_password/screen/forgot_password_screen.dart';
// import '../../features/auth/login/screen/login_screen.dart';
// import '../../features/onboarding/screen/onboarding_screen.dart';
// import '../../features/splash/screen/splash_screen.dart';
// import 'app_routes.dart';
//
// class RouteGenerator {
//
//   static Route<dynamic> generateRoute(
//       RouteSettings settings) {
//
//     switch(settings.name){
//
//       case AppRoutes.splash:
//
//         return MaterialPageRoute(
//           builder: (_) => const SplashScreen(),
//         );
//
//       case AppRoutes.onboarding:
//
//         return MaterialPageRoute(
//           builder: (_) => const OnboardingScreen(),
//         );
//
//       case AppRoutes.login:
//
//         return MaterialPageRoute(
//           builder: (_) => LoginScreen(),
//         );
//
//       case AppRoutes.forgotPassword:
//
//         return MaterialPageRoute(
//           builder: (_) =>
//           const ForgotPasswordScreen(),
//         );
//
//       default:
//
//         return MaterialPageRoute(
//
//           builder: (_) => Scaffold(
//
//             body: Center(
//
//               child: Text(
//                 "No Route Found",
//               ),
//             ),
//           ),
//         );
//     }
//   }
// }


import 'package:flutter/material.dart';

import '../../features/auth/college_code/screen/college_code_screen.dart';
import '../../features/auth/forgot_password/screen/forgot_password_screen.dart';
import '../../features/auth/login/screen/login_screen.dart';
import '../../features/auth/otp/screen/otp_screen.dart';
import '../../features/auth/reset_password/screen/reset_password_screen.dart';
import '../../features/onboarding/screen/onboarding_screen.dart';
import '../../features/splash/screen/splash_screen.dart';

import 'app_routes.dart';

class RouteGenerator {

  static Route<dynamic> generateRoute(
      RouteSettings settings) {

    switch(settings.name){

      case AppRoutes.splash:

        return MaterialPageRoute(
          builder: (_) => const SplashScreen(),
        );

      case AppRoutes.onboarding:

        return MaterialPageRoute(
          builder: (_) => const OnboardingScreen(),
        );

      case AppRoutes.login:

        return MaterialPageRoute(
          builder: (_) => LoginScreen(),
        );

      case AppRoutes.forgotPassword:

        return MaterialPageRoute(
          builder: (_) =>
          const ForgotPasswordScreen(),
        );

      case AppRoutes.otp:

        return MaterialPageRoute(
          builder: (_) => const OtpScreen(),
        );

      case AppRoutes.resetPassword:

        return MaterialPageRoute(
          builder: (_) =>
          const ResetPasswordScreen(),
        );

      case AppRoutes.collegeCode:

        return MaterialPageRoute(
          builder: (_) =>
              CollegeCodeScreen(),
        );

      default:

        return MaterialPageRoute(

          builder: (_) => const Scaffold(

            body: Center(
              child: Text("No Route Found"),
            ),
          ),
        );
    }
  }
}
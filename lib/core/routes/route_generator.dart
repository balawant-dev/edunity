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

import '../../features/attendance/screen/face_attendance_screen.dart';
import '../../features/attendence_summary/screen/attendanceHomeScreen.dart';
import '../../features/attendence_summary/screen/monthlySummaryScreen.dart';
import '../../features/attendence_summary/screen/punch_screen.dart';
import '../../features/attendence_summary/screen/quickAccessScreen.dart';
import '../../features/auth/change_password/screen/change_password_screen.dart';
import '../../features/auth/college_code/model/college_code_model.dart';
import '../../features/auth/college_code/screen/college_code_screen.dart';
import '../../features/auth/forgot_password/model/forgot_password_model.dart';
import '../../features/auth/forgot_password/screen/forgot_password_screen.dart';
import '../../features/auth/login/screen/login_screen.dart';
import '../../features/auth/otp/screen/otp_screen.dart';
import '../../features/auth/reset_password/screen/reset_password_screen.dart';
import '../../features/bottomBar/bottomBar.dart';
import '../../features/cms/screen/about_us_screen.dart';
import '../../features/cms/screen/campus_connect_screen.dart';
import '../../features/cms/screen/privacy_policy_screen.dart';
import '../../features/cms/screen/terms_condition_screen.dart';
import '../../features/home/screen/home_screen.dart';
import '../../features/onboarding/screen/onboarding_screen.dart';
import '../../features/profile/screen/profile_screen.dart';
import '../../features/splash/screen/splash_screen.dart';

import 'app_routes.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.splash:
        // return MaterialPageRoute(builder: (_) => const HomeScreen());
        return MaterialPageRoute(builder: (_) => const SplashScreen());

      case AppRoutes.onboarding:
        return MaterialPageRoute(builder: (_) => const OnboardingScreen());

      /// =============================
      /// 6. ROUTE GENERATOR
      /// =============================

      case AppRoutes.login:
        final college = settings.arguments as CollegeModel;

        return MaterialPageRoute(
          builder: (_) => LoginScreen(collegeModel: college),
        );

      case AppRoutes.forgotPassword:
        return MaterialPageRoute(builder: (_) => const ForgotPasswordScreen());
      case AppRoutes.profile:
        return MaterialPageRoute(
          builder: (_) => const ProfileScreen(isBack: true),
        );
      case AppRoutes.changePassword:
        return MaterialPageRoute(builder: (_) => const ChangePasswordScreen());
        case AppRoutes.attendanceSummary:
        return MaterialPageRoute(builder: (_) => const PunchesScreen());
        case AppRoutes.monthlySummary:
        return MaterialPageRoute(builder: (_) => const MonthlySummaryScreen());
        case AppRoutes.attendanceHome:
        return MaterialPageRoute(builder: (_) => const AttendanceHomeScreen());     case AppRoutes.quickAccess:
        return MaterialPageRoute(builder: (_) => const QuickAccessScreen());
      case AppRoutes.faceAttendance:
        return MaterialPageRoute(
          builder: (_) => const FaceAttendanceScreen(isBack: true),
        );

      case AppRoutes.otp:
        final forgotData = settings.arguments as ForgotPasswordModel;

        return MaterialPageRoute(
          builder: (_) => OtpScreen(forgotData: forgotData),
        );

      case AppRoutes.resetPassword:
        final data = settings.arguments as Map<String, dynamic>;

        return MaterialPageRoute(
          builder: (_) =>
              ResetPasswordScreen(userId: data["user_id"], otp: data["otp"]),
        );

      case AppRoutes.collegeCode:
        return MaterialPageRoute(builder: (_) => CollegeCodeScreen());
      case AppRoutes.home:
        return MaterialPageRoute(builder: (_) => MainScreen(currentIndex: 0));

      case AppRoutes.privacyPolicy:
        return MaterialPageRoute(builder: (_) => const PrivacyPolicyScreen());

      case AppRoutes.aboutUs:
        return MaterialPageRoute(builder: (_) => const AboutUsScreen());

      case AppRoutes.termsCondition:
        return MaterialPageRoute(builder: (_) => const TermsConditionScreen());

      case AppRoutes.campusConnect:
        return MaterialPageRoute(builder: (_) => const CampusConnectScreen());

      // case AppRoutes.home:
      // return MaterialPageRoute(builder: (_) => HomeScreen());

      default:
        return MaterialPageRoute(
          builder: (_) =>
              const Scaffold(body: Center(child: Text("No Route Found"))),
        );
    }
  }
}

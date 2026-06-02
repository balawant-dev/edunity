import 'package:edunity/features/auth/otp/provider/otp_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import 'core/network/internet_provider.dart';
import 'core/network/network_wrapper.dart';
import 'core/routes/app_routes.dart';
import 'core/routes/route_generator.dart';
import 'core/services/navigation_service.dart';
import 'features/attendance/provider/attendance_provider.dart';
import 'features/attendance/service/face_recognition_service.dart';
import 'features/attendence_summary/provider/attendance_report_provider.dart';
import 'features/auth/change_password/provider/change_password_provider.dart';
import 'features/auth/college_code/provider/college_provider.dart';
import 'features/auth/forgot_password/provider/forgot_password_provider.dart';

import 'features/auth/login/provider/login_provider.dart';
import 'features/auth/reset_password/provider/reset_password_provider.dart';
import 'features/cms/provider/cms_provider.dart';
import 'features/home/provider/home_provider.dart';
import 'features/onboarding/provider/onboarding_provider.dart';

import 'features/profile/provider/profile_provider.dart';
import 'features/splash/provider/splash_provider.dart';
import 'features/staff/employee/provider/manager_face_provider.dart';
import 'features/staff/employee/provider/onbehalf_employee_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await FaceRecognitionService.instance.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SplashProvider()),
        ChangeNotifierProvider(create: (_) => OnboardingProvider()),
        ChangeNotifierProvider(create: (_) => ForgotPasswordProvider()),
        ChangeNotifierProvider(create: (_) => OtpProvider()),
        ChangeNotifierProvider(create: (_) => ResetPasswordProvider()),
        ChangeNotifierProvider(create: (_) => HomeProvider()),
        ChangeNotifierProvider(create: (_) => CollegeProvider()),
        ChangeNotifierProvider(create: (_) => LoginProvider()),
        ChangeNotifierProvider(create: (_) => ChangePasswordProvider()),
        ChangeNotifierProvider(create: (_) => ProfileProvider()),
        ChangeNotifierProvider(create: (_) => InternetProvider()),
        ChangeNotifierProvider(create: (_) => AttendanceProvider()),
        ChangeNotifierProvider(create: (_) => AttendanceReportProvider()),
        ChangeNotifierProvider(create: (_) => CMSProvider()),
        ChangeNotifierProvider(create: (_) => ManagerFaceProvider()),
        ChangeNotifierProvider(
          create: (_) => OnBehalfEmployeeProvider(),
        ),
      ],
      child: ScreenUtilInit(
        designSize: const Size(375, 812),
        builder: (context, child) {
          return MaterialApp(
            navigatorKey: NavigationService.navigatorKey,
            debugShowCheckedModeBanner: false,
            initialRoute: AppRoutes.splash,
            onGenerateRoute: RouteGenerator.generateRoute,
            builder: (context, child) {
              return NetworkWrapper(
                child: child!,
              );
            },
          );
        },
      ),
    );
  }
}

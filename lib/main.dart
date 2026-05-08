import 'package:edunity/features/auth/otp/provider/otp_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import 'core/routes/app_routes.dart';
import 'core/routes/route_generator.dart';
import 'features/auth/forgot_password/provider/forgot_password_provider.dart';

import 'features/auth/reset_password/provider/reset_password_provider.dart';
import 'features/onboarding/provider/onboarding_provider.dart';

import 'features/splash/provider/splash_provider.dart';
//git code


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {

    return MultiProvider(

      providers: [

        ChangeNotifierProvider(
          create: (_) => SplashProvider(),
        ),

        ChangeNotifierProvider(
          create: (_) => OnboardingProvider(),

        ),
        ChangeNotifierProvider(
          create: (_) => ForgotPasswordProvider(),
        ),

        ChangeNotifierProvider(
          create: (_) => OtpProvider(),
        ),  ChangeNotifierProvider(
          create: (_) => ResetPasswordProvider(),
        ),

      ],
      child: ScreenUtilInit(
        designSize: const Size(375, 812),

        builder: (context, child) {

          return MaterialApp(

            debugShowCheckedModeBanner: false,

            initialRoute: AppRoutes.splash,
            onGenerateRoute: RouteGenerator.generateRoute,
          );
        },
      ),
    );
  }
}
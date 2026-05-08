import 'dart:async';

import 'package:flutter/material.dart';

import '../../../core/routes/app_routes.dart';

class SplashProvider extends ChangeNotifier {

  Future<void> initializeApp(BuildContext context) async {

    await Future.delayed(const Duration(seconds: 3));

    /// TODO:
    /// Check Token / Login State Here

    bool isLoggedIn = false;

    if(context.mounted){

      Navigator.pushReplacementNamed(
        context,
        isLoggedIn
            ? AppRoutes.home
            : AppRoutes.onboarding,
      );
    }
  }
}
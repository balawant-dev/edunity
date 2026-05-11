import 'package:flutter/material.dart';

import '../services/navigation_service.dart';

class AppToast {

  static void show(
      String message, {
        Color backgroundColor = Colors.black,
        Color textColor = Colors.white,
      }) {

    final context =
        NavigationService
            .navigatorKey
            .currentContext;

    if(context == null) return;

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()

      ..showSnackBar(

        SnackBar(

          content: Text(
            message,
            style: TextStyle(
              color: textColor,
            ),
          ),

          backgroundColor: backgroundColor,

          behavior: SnackBarBehavior.floating,

          margin: const EdgeInsets.all(16),

          duration: const Duration(seconds: 2),
        ),
      );
  }
}
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

//
// class AppToast {
//   static void show(
//       String message, {
//         Color backgroundColor = Colors.black,
//         Color textColor = Colors.white,
//       }) {
//     final context = NavigationService.navigatorKey.currentContext;
//
//     if (context == null) return;
//
//     final mediaQuery = MediaQuery.of(context);
//
//     ScaffoldMessenger.of(context)
//       ..hideCurrentSnackBar()
//       ..showSnackBar(
//         SnackBar(
//           content: Text(
//             message,
//             textAlign: TextAlign.center, // Text center mein premium lagta hai
//             style: TextStyle(
//               color: textColor,
//               fontWeight: FontWeight.w500,
//             ),
//           ),
//           backgroundColor: backgroundColor,
//           behavior: SnackBarBehavior.floating,
//           duration: const Duration(seconds: 2),
//           // Margin logic to push it to the top
//           margin: EdgeInsets.only(
//             bottom: mediaQuery.size.height - 100, // Screen height ke hisab se top par push karega
//             left: 20,
//             right: 20,
//           ),
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(12),
//           ),
//         ),
//       );
//   }
// }
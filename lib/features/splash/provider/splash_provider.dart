// /// =============================
// /// 8. SPLASH PROVIDER
// /// =============================
//
// import 'dart:async';
//
// import 'package:flutter/material.dart';
//
// import '../../../core/routes/app_routes.dart';
//
// import '../../../core/services/local_storage_service.dart';
//
// class SplashProvider
//     extends ChangeNotifier {
//
//   Future<void> initializeApp(
//       BuildContext context) async {
//
//     await Future.delayed(
//       const Duration(seconds: 3),
//     );
//
//     final token =
//     await LocalStorageService
//         .getToken();
//
//     bool isLoggedIn =
//         token != null &&
//             token.isNotEmpty;
//
//     if(context.mounted){
//       print("Api token>>>>>>>>>   ${token}");
//       print(token);
//
//       Navigator.pushReplacementNamed(
//
//         context,
//
//         isLoggedIn
//             ? AppRoutes.home
//             : AppRoutes.onboarding,
//       );
//     }
//   }
// }


import 'package:edunity/features/token/repo/token_repo.dart';
import 'package:flutter/material.dart';



import '../../../core/routes/app_routes.dart';

import '../../../core/services/local_storage_service.dart';


class SplashProvider
    extends ChangeNotifier {

  final TokenRepository repository =
  TokenRepository();

  Future<void> initializeApp(
      BuildContext context,
      ) async {

    await Future.delayed(
      const Duration(seconds: 2),
    );

    try{

      final token =
      await LocalStorageService
          .getToken();
      print("API Token>>>>>>>>>>>>   ${token}");
      /// NO TOKEN
      if(token == null){


        if(context.mounted){

          Navigator.pushReplacementNamed(

            context,

            AppRoutes.onboarding,
          );
        }

        return;
      }

      /// TOKEN CHECK
      final response =
      await repository.tokenCheck();

      /// VALID TOKEN
      if(response["status"] == true){

        if(context.mounted){

          Navigator.pushReplacementNamed(

            context,

            AppRoutes.home,
          );
        }

        return;
      }

      /// TOKEN EXPIRED
      if(response["action"] ==
          "refresh_required"){

        await _refreshToken(
          context,
        );
      }

    }catch(e){

      await LocalStorageService
          .clearSession();

      if(context.mounted){

        Navigator.pushReplacementNamed(

          context,

          AppRoutes.onboarding,
        );
      }
    }
  }

  /// REFRESH TOKEN
  Future<void> _refreshToken(
      BuildContext context,
      ) async {

    try{

      final refreshToken =
      await LocalStorageService
          .getRefreshToken();

      if(refreshToken == null){

        await LocalStorageService
            .clearSession();

        if(context.mounted){

          Navigator.pushReplacementNamed(

            context,

            AppRoutes.onboarding,
          );
        }

        return;
      }

      final response =
      await repository
          .refreshToken(

        refreshToken:
        refreshToken,
      );

      if(response["status"] == true){

        await LocalStorageService
            .saveToken(

          response["access_token"],
        );

        if(context.mounted){

          Navigator.pushReplacementNamed(

            context,

            AppRoutes.home,
          );
        }

      }else{

        await LocalStorageService
            .clearSession();

        if(context.mounted){

          Navigator.pushReplacementNamed(

            context,

            AppRoutes.onboarding,
          );
        }
      }

    }catch(e){

      await LocalStorageService
          .clearSession();

      if(context.mounted){

        Navigator.pushReplacementNamed(

          context,

          AppRoutes.onboarding,
        );
      }
    }
  }
}
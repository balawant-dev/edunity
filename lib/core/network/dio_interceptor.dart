// import 'package:dio/dio.dart';
//
// import '../routes/app_routes.dart';
// import '../services/local_storage_service.dart';
// import '../services/navigation_service.dart';
//
// class DioInterceptor extends Interceptor {
//
//   @override
//   void onRequest(
//       RequestOptions options,
//       RequestInterceptorHandler handler,
//       ) async {
//
//     final token =
//     await LocalStorageService.getToken();
//
//     if(token != null){
//
//       options.headers["Authorization"] =
//       "Bearer $token";
//     }
//
//     super.onRequest(options, handler);
//   }
//
//   @override
//   void onError(
//       DioException err,
//       ErrorInterceptorHandler handler,
//       ) async {
//
//     /// TOKEN EXPIRED
//     if(err.response?.statusCode == 401){
//
//       await LocalStorageService.clearSession();
//
//       NavigationService
//           .navigatorKey
//           .currentState
//           ?.pushNamedAndRemoveUntil(
//         AppRoutes.login,
//             (route) => false,
//       );
//     }
//
//     super.onError(err, handler);
//   }
// }


import 'dart:convert';

import 'package:dio/dio.dart';

import '../routes/app_routes.dart';
import '../services/local_storage_service.dart';
import '../services/navigation_service.dart';

class DioInterceptor extends Interceptor {

  @override
  void onRequest(
      RequestOptions options,
      RequestInterceptorHandler handler,
      ) async {

    final token =
    await LocalStorageService.getToken();

    /// TOKEN ADD
    if(token != null){

      options.headers["Authorization"] =
      "Bearer $token";
    }

    /// API LOG START
    print(
        "================ API REQUEST ================");

    print("METHOD => ${options.method}");

    print("URL => ${options.baseUrl}${options.path}");

    print("TOKEN => $token");

    print("HEADERS => ${options.headers}");

    print("QUERY => ${options.queryParameters}");

    print(
      "BODY => ${jsonEncode(options.data)}",
    );

    print(
        "============================================");

    super.onRequest(options, handler);
  }

  @override
  void onResponse(
      Response response,
      ResponseInterceptorHandler handler,
      ) {

    /// RESPONSE LOG
    print(
        "================ API RESPONSE ================");

    print(
      "URL => ${response.requestOptions.baseUrl}${response.requestOptions.path}",
    );

    print(
      "STATUS CODE => ${response.statusCode}",
    );

    print(
      "RESPONSE => ${jsonEncode(response.data)}",
    );

    print(
        "==============================================");

    super.onResponse(response, handler);
  }

  @override
  void onError(
      DioException err,
      ErrorInterceptorHandler handler,
      ) async {

    /// ERROR LOG
    print(
        "================ API ERROR =================");

    print(
      "URL => ${err.requestOptions.baseUrl}${err.requestOptions.path}",
    );

    print(
      "STATUS CODE => ${err.response?.statusCode}",
    );

    print(
      "ERROR => ${err.message}",
    );

    print(
      "ERROR RESPONSE => ${err.response?.data}",
    );

    print(
        "============================================");

    /// TOKEN EXPIRED
    if(err.response?.statusCode == 401){

      await LocalStorageService.clearSession();

      NavigationService
          .navigatorKey
          .currentState
          ?.pushNamedAndRemoveUntil(
        AppRoutes.login,
            (route) => false,
      );
    }

    super.onError(err, handler);
  }
}
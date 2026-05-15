// import 'dart:convert';
//
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
//     /// TOKEN
//     if (token != null) {
//
//       options.headers["Authorization"] =
//       "Bearer $token";
//     }
//
//     /// LOG START
//     print(
//         "================ API REQUEST ================");
//
//     print(
//         "METHOD => ${options.method}");
//
//     print(
//         "URL => ${options.baseUrl}${options.path}");
//
//     print(
//         "TOKEN => $token");
//
//     print(
//         "HEADERS => ${options.headers}");
//
//     print(
//         "QUERY => ${options.queryParameters}");
//
//     /// SAFE BODY LOG
//     if (options.data != null) {
//
//       /// MULTIPART
//       if (options.data is FormData) {
//
//         final formData =
//         options.data as FormData;
//
//         print(
//             "BODY => MULTIPART FORM DATA");
//
//         print(
//             "FIELDS => ${formData.fields}");
//
//         print(
//             "FILES COUNT => ${formData.files.length}");
//
//         for (var file in formData.files) {
//
//           print(
//               "FILE => ${file.key}");
//         }
//
//       } else {
//
//         /// NORMAL JSON
//         print(
//           "BODY => ${jsonEncode(options.data)}",
//         );
//       }
//     }
//
//     print(
//         "============================================");
//
//     return handler.next(options);
//   }
//
//   @override
//   void onResponse(
//       Response response,
//       ResponseInterceptorHandler handler,
//       ) {
//
//     print(
//         "================ API RESPONSE ================");
//
//     print(
//       "URL => ${response.requestOptions.baseUrl}${response.requestOptions.path}",
//     );
//
//     print(
//       "STATUS CODE => ${response.statusCode}",
//     );
//
//     try {
//
//       print(
//         "RESPONSE => ${jsonEncode(response.data)}",
//       );
//
//     } catch (e) {
//
//       print(
//         "RESPONSE => ${response.data}",
//       );
//     }
//
//     print(
//         "==============================================");
//
//     return handler.next(response);
//   }
//
//   @override
//   void onError(
//       DioException err,
//       ErrorInterceptorHandler handler,
//       ) async {
//
//     print(
//         "================ API ERROR =================");
//
//     print(
//       "URL => ${err.requestOptions.baseUrl}${err.requestOptions.path}",
//     );
//
//     print(
//       "STATUS CODE => ${err.response?.statusCode}",
//     );
//
//     print(
//       "ERROR => ${err.message}",
//     );
//
//     print(
//       "ERROR RESPONSE => ${err.response?.data}",
//     );
//
//     print(
//         "============================================");
//
//     /// TOKEN EXPIRED
//     if (err.response?.statusCode == 401) {
//
//       await LocalStorageService.clearSession();
//
//       NavigationService
//           .navigatorKey
//           .currentState
//           ?.pushNamedAndRemoveUntil(
//
//         AppRoutes.login,
//
//             (route) => false,
//       );
//     }
//
//     return handler.next(err);
//   }
// }



import 'dart:convert';

import 'package:dio/dio.dart';

import '../network/api_endpoints.dart';
import '../routes/app_routes.dart';
import '../services/local_storage_service.dart';
import '../services/navigation_service.dart';

class DioInterceptor extends Interceptor {

  final Dio dio;

  DioInterceptor(this.dio);

  bool isRefreshing = false;

  @override
  void onRequest(
      RequestOptions options,
      RequestInterceptorHandler handler,
      ) async {

    final token =
    await LocalStorageService.getToken();

    /// ACCESS TOKEN ADD
    if(token != null){

      options.headers["Authorization"] =
      "Bearer $token";
    }

    /// LOG REQUEST
    print(
        "================ API REQUEST ================");

    print(
        "METHOD => ${options.method}");

    print(
        "URL => ${options.baseUrl}${options.path}");

    print(
        "TOKEN => $token");

    print(
        "HEADERS => ${options.headers}");

    print(
        "QUERY => ${options.queryParameters}");

    if(options.data != null){

      try{

        print(
          "BODY => ${jsonEncode(options.data)}",
        );

      }catch(e){

        print("BODY => ${options.data}");
      }
    }

    print(
        "============================================");

    return handler.next(options);
  }


  @override
  void onResponse(
      Response response,
      ResponseInterceptorHandler handler,
      ) async {

    print(
        "================ API RESPONSE ================");

    print(
      "URL => ${response.requestOptions.baseUrl}${response.requestOptions.path}",
    );

    print(
      "STATUS CODE => ${response.statusCode}",
    );

    try {

      print(
        "RESPONSE => ${jsonEncode(response.data)}",
      );

    } catch (e) {

      print(
        "RESPONSE => ${response.data}",
      );
    }

    print(
        "==============================================");

    /// TOKEN EXPIRED HANDLE FROM RESPONSE BODY

    final data = response.data;

    final isTokenExpired =

        response.statusCode == 401 ||

            (
                data is Map &&
                    data["status"] == false &&
                    data["message"]
                        .toString()
                        .toLowerCase()
                        .contains("expired token")
            ) ||

            (
                data is Map &&
                    data["status"] == false &&
                    data["message"]
                        .toString()
                        .toLowerCase()
                        .contains("invalid or expired token")
            );

    if(isTokenExpired && !isRefreshing){

      isRefreshing = true;

      try {

        final refreshToken =
        await LocalStorageService
            .getRefreshToken();

        /// NO REFRESH TOKEN

        if(refreshToken == null){

          await _logout();

          return handler.next(response);
        }

        /// REFRESH API

        final refreshResponse = await dio.post(

          ApiEndpoints.refreshToken,

          data: {

            "refresh_token": refreshToken,
          },

          options: Options(

            headers: {

              "Authorization": null,
            },
          ),
        );
        print( "TTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTT🔑🔑🔑🔑🔑🔑🔑🔑🔑🔑🔑🔑🔑🔑🔑🔑🔑🔑🔑🔑🔑🔑🔑🔑🔑🔑🔑TTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTREFRESH TOKEN RESPONSE => ${response.data}");
        print(
            "REFRESH RESPONSE => ${refreshResponse.data}");

        /// SUCCESS

        if(refreshResponse.data["status"] == true){

          final newAccessToken =
          refreshResponse.data["access_token"];
          print("New Access Token genarte Hua: ${newAccessToken}");
          /// SAVE TOKEN

          await LocalStorageService
              .saveToken(
            newAccessToken,
          );

          /// RETRY OLD API

          final requestOptions =
              response.requestOptions;

          requestOptions.headers["Authorization"] =
          "Bearer $newAccessToken";

          final retryResponse =
          await dio.fetch(
            requestOptions,
          );

          isRefreshing = false;

          return handler.resolve(
            retryResponse,
          );
        }

        /// FAILED

        else {

          isRefreshing = false;

          await _logout();

          return handler.next(response);
        }

      } catch (e) {

        isRefreshing = false;

        await _logout();

        return handler.next(response);
      }
    }

    return handler.next(response);
  }

  /// LOGOUT
  Future<void> _logout() async {

    await LocalStorageService
        .clearSession();

    NavigationService
        .navigatorKey
        .currentState
        ?.pushNamedAndRemoveUntil(

      AppRoutes.login,

          (route) => false,
    );
  }
}
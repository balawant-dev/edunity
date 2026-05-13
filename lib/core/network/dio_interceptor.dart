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

    /// TOKEN
    if (token != null) {

      options.headers["Authorization"] =
      "Bearer $token";
    }

    /// LOG START
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

    /// SAFE BODY LOG
    if (options.data != null) {

      /// MULTIPART
      if (options.data is FormData) {

        final formData =
        options.data as FormData;

        print(
            "BODY => MULTIPART FORM DATA");

        print(
            "FIELDS => ${formData.fields}");

        print(
            "FILES COUNT => ${formData.files.length}");

        for (var file in formData.files) {

          print(
              "FILE => ${file.key}");
        }

      } else {

        /// NORMAL JSON
        print(
          "BODY => ${jsonEncode(options.data)}",
        );
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
      ) {

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

    return handler.next(response);
  }

  @override
  void onError(
      DioException err,
      ErrorInterceptorHandler handler,
      ) async {

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
    if (err.response?.statusCode == 401) {

      await LocalStorageService.clearSession();

      NavigationService
          .navigatorKey
          .currentState
          ?.pushNamedAndRemoveUntil(

        AppRoutes.login,

            (route) => false,
      );
    }

    return handler.next(err);
  }
}
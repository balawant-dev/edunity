import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../error/no_internet_screen.dart';
import '../error/server_error_screen.dart';
import '../services/navigation_service.dart';
import 'api_endpoints.dart';
import 'api_exception.dart';
import 'dio_interceptor.dart';
import 'network_info.dart';

class ApiClient {

  late Dio dio;

  ApiClient(){

    dio = Dio(

      BaseOptions(

        baseUrl: ApiEndpoints.baseUrl,

        connectTimeout:
        const Duration(seconds: 60),

        receiveTimeout:
        const Duration(seconds: 60),

        sendTimeout:
        const Duration(seconds: 60),

        headers: {
          "Accept": "application/json",
        },
        /// IMPORTANT
        validateStatus: (status) {

          return status != null &&
              status < 500;
        },
      ),
    );
    dio.interceptors.add(
      DioInterceptor(dio),
    );
    // dio.interceptors.add(DioInterceptor());
  }

  /// GET API
  Future<Response> get(
      String url,
      ) async {

    try{

      bool isConnected =
      await NetworkInfo.isConnected();

      if(!isConnected){
        //
        // NavigationService
        //     .navigatorKey
        //     .currentState
        //     ?.push(
        //   MaterialPageRoute(
        //     builder: (_) =>
        //     const NoInternetScreen(),
        //   ),
        // );

        throw ApiException("No Internet");
      }

      return await dio.get(url);

    } on DioException catch(e){

      _handleError(e);

      rethrow;
    }
  }

  /// POST API
  Future<Response> post(
      String url, {
        dynamic data,
      }) async {

    try{

      bool isConnected =
      await NetworkInfo.isConnected();

      if(!isConnected){

        NavigationService
            .navigatorKey
            .currentState
            ?.push(
          MaterialPageRoute(
            builder: (_) =>
            const NoInternetScreen(),
          ),
        );

        throw ApiException("No Internet");
      }

      return await dio.post(
        url,
        data: data,
      );

    } on DioException catch(e){

      _handleError(e);

      rethrow;
    }
  }

  /// DELETE API
  Future<Response> delete(
      String url,
      ) async {

    try{

      return await dio.delete(url);

    } on DioException catch(e){

      _handleError(e);

      rethrow;
    }
  }

  /// PATCH API
  Future<Response> patch(
      String url, {
        dynamic data,
      }) async {

    try{

      return await dio.patch(
        url,
        data: data,
      );

    } on DioException catch(e){

      _handleError(e);

      rethrow;
    }
  }

  /// MULTIPART API
  Future<Response> multipartPost(
      String url, {
        required FormData data,
      }) async {

    try{

      return await dio.post(
        url,
        data: data,
      );

    } on DioException catch(e){

      _handleError(e);

      rethrow;
    }
  }

  void _handleError(DioException e){

    if(e.response?.statusCode == 500){

      NavigationService
          .navigatorKey
          .currentState
          ?.push(
        MaterialPageRoute(
          builder: (_) =>
          const ServerErrorScreen(),
        ),
      );
    }
  }
}
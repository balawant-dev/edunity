import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_endpoints.dart';
import '../model/faceImagesModel.dart';
import '../model/face_registration_model.dart';
import '../model/face_status_model.dart';
import '../model/new_face_match_model.dart';
import '../model/punch_response_model.dart';
import '../model/today_attendance_model.dart';

class AttendanceRepo {
  final ApiClient apiClient = ApiClient();

  /// FACE STATUS
  Future<FaceStatusModel> getFaceStatus() async {
    final response = await apiClient.get(
      ApiEndpoints.faceStatus,
    );

    return FaceStatusModel.fromJson(
      response.data,
    );
  }

  /// TODAY ATTENDANCE
  Future<TodayAttendanceModel> getTodayAttendance() async {
    final response = await apiClient.get(
      ApiEndpoints.todayAttendance,
    );

    return TodayAttendanceModel.fromJson(
      response.data,
    );
  }

  /// TODAY ATTENDANCE
  Future<FaceImagesModel> getFaceImages() async {
    final response = await apiClient.get(
      ApiEndpoints.faceImages,
    );

    return FaceImagesModel.fromJson(
      response.data,
    );
  }

  ///%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  /// SUB DOMAIN CODE
  Future<NewFaceMatchModel> newFaceMatchApi({
    required File newImage,
    required File oldImage,
  }) async {
    final dio = Dio();

    try {
      /// 🔥 FORM DATA BUILD
      FormData formData = FormData.fromMap({
        "image2": await MultipartFile.fromFile(
          newImage.path,
          filename: newImage.path.split('/').last,
        ),
        "image1": await MultipartFile.fromFile(
          oldImage.path,
          filename: oldImage.path.split('/').last,
        ),
      });

      /// 🧾 PRINT REQUEST INFO
      print("========== FACE MATCH REQUEST ==========");
      print("URL: http://168.144.116.189:5001/match");

      print("👉 newImage path: ${newImage.path}");
      print("👉 oldImage path: ${oldImage.path}");

      print("👉 Request Files:");
      print("   newimage: ${newImage.path.split('/').last}");
      print("   images: ${oldImage.path.split('/').last}");

      print("========================================");

      /// 🚀 API CALL
      final response = await dio.post(
        "http://168.144.116.189:5001/match",
        data: formData,
        options: Options(
          contentType: "multipart/form-data",
        ),
      );

      /// 📡 RESPONSE LOG
      print("========== FACE MATCH RESPONSE ==========");
      print("Status Code: ${response.statusCode}");
      print("Response Data: ${response.data}");
      print("========================================");

      return NewFaceMatchModel.fromJson(response.data);
    } on DioException catch (e) {
      /// ❌ DIO ERROR LOG
      print("========== FACE MATCH ERROR ==========");
      print("Error Message: ${e.message}");
      print("Status Code: ${e.response?.statusCode}");
      print("Error Response: ${e.response?.data}");
      print("=======================================");

      rethrow;
    } catch (e) {
      /// ❌ UNKNOWN ERROR
      print("========== UNKNOWN ERROR ==========");
      print(e.toString());
      print("===================================");

      rethrow;
    }
  }

  ///%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  /// REGISTER FACE
  /// REGISTER FACE
  Future<FaceRegistrationModel> registerFace({
    required List<File> primaryImages,
    required List<File> images,
  }) async {
    FormData formData = FormData();

    /// PRIMARY IMAGE
    for (var file in primaryImages) {
      debugPrint(
        "PRIMARY IMAGE => ${file.path}",
      );

      formData.files.add(
        MapEntry(
          "primary_images",
          await MultipartFile.fromFile(
            file.path,
            filename: file.path.split('/').last,
          ),
        ),
      );
    }

    /// FACE IMAGES
    for (var file in images) {
      // for (var file in primaryImages) {

      debugPrint(
        "FACE IMAGE => ${file.path}",
      );

      formData.files.add(
        MapEntry(
          "images[]",
          await MultipartFile.fromFile(
            file.path,
            filename: file.path.split('/').last,
          ),
        ),
      );
    }

    /// ===========================
    /// PRINT BODY DATA
    /// ===========================

    debugPrint(
      "PRIMARY IMAGES COUNT => ${primaryImages.length}",
    );

    debugPrint(
      "FACE IMAGES COUNT => ${images.length}",
    );

    for (var element in formData.files) {
      debugPrint(
        "KEY => ${element.key}",
      );

      debugPrint(
        "FILE NAME => ${element.value.filename}",
      );
    }

    final response = await apiClient.multipartPost(
      ApiEndpoints.registerFace,
      data: formData,
    );

    return FaceRegistrationModel.fromJson(
      response.data,
    );
  }
  // Future<FaceStatusModel> registerFace({
  //   required List<File> primaryImages,
  //   required List<File> images,
  // }) async {
  //
  //   FormData formData = FormData();
  //
  //   /// PRIMARY IMAGE (usually 1 file)
  //   for (var file in primaryImages) {
  //     formData.files.add(
  //       MapEntry(
  //         "primary_images",
  //         await MultipartFile.fromFile(
  //           file.path,
  //           filename: file.path.split('/').last,
  //         ),
  //       ),
  //     );
  //   }
  //
  //   /// FACE SCAN IMAGES (20+)
  //   for (var file in images) {
  //     formData.files.add(
  //       MapEntry(
  //         "images",
  //         await MultipartFile.fromFile(
  //           file.path,
  //           filename: file.path.split('/').last,
  //         ),
  //       ),
  //     );
  //   }
  //
  //   final response = await apiClient.multipartPost(
  //     ApiEndpoints.registerFace,
  //     data: formData,
  //   );
  //
  //   return FaceStatusModel.fromJson(response.data);
  // }

  /// EMPLOYEE PUNCH
  Future<PunchResponseModel> employeePunch({
    required String locationId,
    required File punchImage,
    required double lat,
    required double lng,
    required String action,
    required String breakId,
    String? note,
    String? lateCause,
  }) async {
    FormData formData = FormData.fromMap({
      "location_id": locationId,
      "note": note,
      "lat": lat.toString(),
      "lng": lng.toString(),
      "action": action,
      "late_cause": lateCause,
      "shift_break_id": breakId,
      "punch_image": await MultipartFile.fromFile(
        punchImage.path,
      ),
    });

    // ==================== DEBUG PRINT START ====================
    print("---------- Employee Punch Request ----------");
    // Saari normal fields print karne ke liye
    for (var field in formData.fields) {
      print("Field: ${field.key} = ${field.value}");
    }
    print("ACTION => $action");
    print("LAT => $lat");
    print("LNG => $lng");
    // Image details print karne ke liye
    for (var file in formData.files) {
      print("File: ${file.key} = ${file.value.filename}");
      print("Local Path: ${punchImage.path}");
    }
    print("--------------------------------------------");
    // ===================== DEBUG PRINT END =====================

    final response = await apiClient.multipartPost(
      ApiEndpoints.employeePunch,
      data: formData,
    );

    return PunchResponseModel.fromJson(
      response.data,
    );
  }

  /// STUDENT PUNCH
  Future<PunchResponseModel> studentPunch({
    required String locationId,
    required File punchImage,
    required double lat,
    required double lng,
    required String action,
    String? note,
    String? lateCause,
  }) async {
    FormData formData = FormData.fromMap({
      "location_id": locationId,
      "lat": lat.toString(),
      "lng": lng.toString(),
      "action": action,
      "note": note,
      "late_cause": lateCause,
      "punch_image": await MultipartFile.fromFile(
        punchImage.path,
      ),
    });

    // ==================== PRINT LOGIC START ====================
    print("--- FormData Body STUDENT PUNCH ---");
    for (var field in formData.fields) {
      print("${field.key}: ${field.value}");
    }
    for (var file in formData.files) {
      print(
          "${file.key}: [FILE] ${file.value.filename} (Path: ${punchImage.path})");
    }
    print("----------------------");
    // ===================== PRINT LOGIC END =====================

    final response = await apiClient.multipartPost(
      ApiEndpoints.studentPunch,
      data: formData,
    );

    return PunchResponseModel.fromJson(
      response.data,
    );
  }

  ///manager part26.5
  Future<FaceRegistrationModel> managerRegisterEmployeeFace({
    required int uid,
    required List<File> primaryImages,
    required List<File> images,
  }) async {
    FormData formData = FormData();

    /// UID
    formData.fields.add(
      MapEntry(
        "uid",
        uid.toString(),
      ),
    );

    /// PRIMARY
    for (var file in primaryImages) {
      formData.files.add(
        MapEntry(
          "primary_images[]",
          await MultipartFile.fromFile(
            file.path,
            filename: file.path.split('/').last,
          ),
        ),
      );
    }

    /// FACE IMAGES
    for (var file in images) {
      formData.files.add(
        MapEntry(
          "images[]",
          await MultipartFile.fromFile(
            file.path,
            filename: file.path.split('/').last,
          ),
        ),
      );
    }

    final response = await apiClient.multipartPost(
      ApiEndpoints.managerRegisterFace,
      data: formData,
    );

    return FaceRegistrationModel.fromJson(
      response.data,
    );
  }

  Future<TodayAttendanceModel> managerEmployeeTodayAttendance(
    int uid,
  ) async {
    final response = await apiClient.get(
      "${ApiEndpoints.managerTodayAttendance}?uid=$uid",
    );

    return TodayAttendanceModel.fromJson(
      response.data,
    );
  }

  Future<PunchResponseModel> managerEmployeePunch({
    required int uid,
    required String locationId,
    required File punchImage,
    String note = "Marked by manager",
  }) async {
    FormData formData = FormData.fromMap({
      "uid": uid.toString(),
      "location_id": locationId,
      "note": note,
      "punch_image": await MultipartFile.fromFile(
        punchImage.path,
      ),
    });

    final response = await apiClient.multipartPost(
      ApiEndpoints.managerEmployeePunch,
      data: formData,
    );

    return PunchResponseModel.fromJson(
      response.data,
    );
  }
}

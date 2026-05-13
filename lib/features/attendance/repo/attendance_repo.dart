import 'dart:io';

import 'package:dio/dio.dart';

import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_endpoints.dart';
import '../model/face_status_model.dart';
import '../model/punch_response_model.dart';
import '../model/today_attendance_model.dart';

class AttendanceRepo {

  final ApiClient apiClient =
  ApiClient();

  /// FACE STATUS
  Future<FaceStatusModel>
  getFaceStatus() async {

    final response =
    await apiClient.get(
      ApiEndpoints.faceStatus,
    );

    return FaceStatusModel.fromJson(
      response.data,
    );
  }

  /// TODAY ATTENDANCE
  Future<TodayAttendanceModel>
  getTodayAttendance() async {

    final response =
    await apiClient.get(
      ApiEndpoints.todayAttendance,
    );

    return TodayAttendanceModel.fromJson(
      response.data,
    );
  }

  /// REGISTER FACE
  Future<FaceStatusModel> registerFace({
    required List<File> primaryImages,
    required List<File> images,
  }) async {

    FormData formData = FormData();

    /// PRIMARY IMAGE (usually 1 file)
    for (var file in primaryImages) {
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

    /// FACE SCAN IMAGES (20+)
    for (var file in images) {
      formData.files.add(
        MapEntry(
          "images",
          await MultipartFile.fromFile(
            file.path,
            filename: file.path.split('/').last,
          ),
        ),
      );
    }

    final response = await apiClient.multipartPost(
      ApiEndpoints.registerFace,
      data: formData,
    );

    return FaceStatusModel.fromJson(response.data);
  }

  /// EMPLOYEE PUNCH
  Future<PunchResponseModel>
  employeePunch({
    required String locationId,
    required File punchImage,
    String? note,
    String? lateCause,
  }) async {

    FormData formData =
    FormData.fromMap({

      "location_id": locationId,

      "note": note,

      "late_cause": lateCause,

      "punch_image":
      await MultipartFile.fromFile(
        punchImage.path,
      ),
    });

    final response =
    await apiClient.multipartPost(
      ApiEndpoints.employeePunch,
      data: formData,
    );

    return PunchResponseModel.fromJson(
      response.data,
    );
  }

  /// STUDENT PUNCH
  Future<PunchResponseModel>
  studentPunch({
    required String locationId,
    required File punchImage,
    String? note,
    String? lateCause,
  }) async {

    FormData formData =
    FormData.fromMap({

      "location_id": locationId,

      "note": note,

      "late_cause": lateCause,

      "punch_image":
      await MultipartFile.fromFile(
        punchImage.path,
      ),
    });

    final response =
    await apiClient.multipartPost(
      ApiEndpoints.studentPunch,
      data: formData,
    );

    return PunchResponseModel.fromJson(
      response.data,
    );
  }
}
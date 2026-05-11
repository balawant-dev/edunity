

import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_endpoints.dart';
import '../../../../core/network/api_exception.dart';

import '../model/otp_model.dart';

class OtpRepository {

  final ApiClient apiClient =
  ApiClient();

  Future<OtpModel> verifyOtp({

    required String userId,

    required String otp,

  }) async {

    final response =
    await apiClient.post(

      ApiEndpoints.verifyOtp,

      data: {

        "user_id": userId,

        "otp": otp,
      },
    );

    if(response.data["status"] == false){

      throw ApiException(
        response.data["message"] ??
            "Invalid OTP",
      );
    }

    return OtpModel.fromJson(
      response.data,
    );
  }
}
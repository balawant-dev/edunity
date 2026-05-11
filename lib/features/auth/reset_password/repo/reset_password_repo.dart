

import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_endpoints.dart';
import '../../../../core/network/api_exception.dart';

import '../model/reset_password_model.dart';

class ResetPasswordRepository {

  final ApiClient apiClient =
  ApiClient();

  Future<ResetPasswordModel>
  resetPassword({

    required String userId,

    required String otp,

    required String newPassword,

    required String confirmPassword,

  }) async {

    final response =
    await apiClient.post(

      ApiEndpoints.resetPassword,

      data: {

        "user_id": userId,

        "otp": otp,

        "new_password":
        newPassword,

        "confirm_password":
        confirmPassword,
      },
    );

    if(response.data["status"] == false){

      throw ApiException(
        response.data["message"] ??
            "Reset password failed",
      );
    }

    return ResetPasswordModel
        .fromJson(response.data);
  }
}
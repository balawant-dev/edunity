

import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_endpoints.dart';
import '../../../../core/network/api_exception.dart';

import '../model/change_password_model.dart';

class ChangePasswordRepository {

  final ApiClient apiClient =
  ApiClient();

  Future<ChangePasswordModel>
  resetPassword({

    required String currentPassword,



    required String newPassword,

    required String confirmPassword,

  }) async {

    final response =
    await apiClient.post(

      ApiEndpoints.changePassword,

      data: {

        "current_password": currentPassword,



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

    return ChangePasswordModel
        .fromJson(response.data);
  }
}
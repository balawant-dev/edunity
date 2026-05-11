
import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_endpoints.dart';
import '../../../../core/network/api_exception.dart';

import '../model/forgot_password_model.dart';

class ForgotPasswordRepository {

  final ApiClient apiClient =
  ApiClient();

  Future<ForgotPasswordModel>
  forgotPassword({

    required String userId,

    required String contact,

    required String aadhar,

  }) async {

    final response =
    await apiClient.post(

      ApiEndpoints.forgotPassword,

      data: {

        "user_id": userId,

        "contact": contact,

        "aadhar": aadhar,
      },
    );

    if(response.data["status"] == false){

      throw ApiException(
        response.data["message"] ??
            "Something went wrong",
      );
    }

    return ForgotPasswordModel.fromJson(
      response.data,
    );
  }
}
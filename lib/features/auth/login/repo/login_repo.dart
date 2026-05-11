/// =============================
/// 3. LOGIN REPOSITORY
/// =============================

import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_endpoints.dart';
import '../../../../core/network/api_exception.dart';

import '../model/login_model.dart';

class LoginRepository {

  final ApiClient apiClient =
  ApiClient();

  Future<LoginModel> login({

    required String collegeId,

    required String userId,

    required String dob,

    required String password,

  }) async {

    final response =
    await apiClient.post(

      ApiEndpoints.login,

      data: {

        "college_id": collegeId,

        "user_id": userId,

        "dob": dob,

        "password": password,
      },
    );

    if(response.data["status"] == false){

      throw ApiException(
        response.data["message"] ??
            "Login failed",
      );
    }

    return LoginModel.fromJson(
      response.data,
    );
  }
}
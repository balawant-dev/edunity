import '../../../core/network/api_client.dart';
import '../../../core/network/api_endpoints.dart';

class TokenRepository {

  final ApiClient apiClient =
  ApiClient();

  /// TOKEN CHECK
  Future<dynamic> tokenCheck()
  async {

    final response =
    await apiClient.get(

      ApiEndpoints.tokenCheck,
    );

    return response.data;
  }

  /// REFRESH TOKEN
  Future<dynamic> refreshToken({
    required String refreshToken,
  }) async {

    final response =
    await apiClient.post(

      ApiEndpoints.refreshToken,

      data: {

        "refresh_token":
        refreshToken,
      },
    );

    return response.data;
  }

  /// LOGOUT
  Future<dynamic> logout({
    required String refreshToken,
  }) async {

    final response =
    await apiClient.post(

      ApiEndpoints.logout,

      data: {

        "refresh_token":
        refreshToken,
      },
    );

    return response.data;
  }
}
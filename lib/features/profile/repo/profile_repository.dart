import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_endpoints.dart';
import '../model/profile_model.dart';

class ProfileRepository {

  final ApiClient apiClient =
  ApiClient();

  Future<ProfileModel>
  getProfile() async {

    final response =
    await apiClient.get(

      ApiEndpoints.myProfile,
    );

    return ProfileModel.fromJson(
      response.data,
    );
  }
}
import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_endpoints.dart';
import '../../../../core/network/api_exception.dart';

import '../model/college_code_model.dart';

class CollegeRepository {

  final ApiClient apiClient = ApiClient();

  Future<CollegeModel> findCollege(
      String collegeId) async {

    final response =
    await apiClient.post(

      ApiEndpoints.findCollege,

      data: {
        "college_id": collegeId,
      },
    );

    /// API FAILURE
    if(response.data["status"] == false){

      throw ApiException(
        response.data["message"] ??
            "Something went wrong",
      );
    }

    return CollegeModel.fromJson(
      response.data,
    );
  }
}
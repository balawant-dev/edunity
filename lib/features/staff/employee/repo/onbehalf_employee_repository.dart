import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_endpoints.dart';
import '../model/onbehalf_employee_model.dart';

class OnBehalfEmployeeRepository {
  final ApiClient apiClient = ApiClient();

  Future<OnBehalfEmployeeModel> getActiveEmployees() async {
    final response = await apiClient.get(
      ApiEndpoints.activeEmployees,
    );

    return OnBehalfEmployeeModel.fromJson(
      response.data,
    );
  }
}

import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_endpoints.dart';
import '../model/manager_employee_detail_model.dart';

class ManagerFaceRepo {
  final ApiClient apiClient = ApiClient();

  // Future<ManagerEmployeeDetailModel> getEmployeeDetail(
  //   int uid,
  // ) async {
  //   final response = await apiClient.get(
  //     "${ApiEndpoints.managerEmployeeAttendance}?uid=$uid",
  //   );
  //
  //   return ManagerEmployeeDetailModel.fromJson(
  //     response.data,
  //   );
  // }
}

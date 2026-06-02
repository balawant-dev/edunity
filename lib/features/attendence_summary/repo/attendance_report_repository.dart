import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_endpoints.dart';
import '../model/attendance_report_model.dart';

class AttendanceReportRepository {
  final ApiClient apiClient = ApiClient();

  Future<AttendanceReportModel> getAttendanceReport({
    required String fromDate,
    required String toDate,
  }) async {
    final response = await apiClient.get(
      "${ApiEndpoints.attendanceReport}"
      "?from_date=$fromDate"
      "&to_date=$toDate",
    );

    return AttendanceReportModel.fromJson(
      response.data,
    );
  }
}

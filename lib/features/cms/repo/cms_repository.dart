import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_endpoints.dart';
import '../model/about_us_model.dart';
import '../model/campus_connect_model.dart';
import '../model/privacy_policy_model.dart';
import '../model/terms_condition_model.dart';

class CMSRepository {
  final ApiClient apiClient = ApiClient();

  Future<PrivacyPolicyModel> getPrivacyPolicy() async {
    final response = await apiClient.get(ApiEndpoints.privacyPolicy);
    return PrivacyPolicyModel.fromJson(response.data);
  }

  Future<AboutUsModel> getAboutUs() async {
    final response = await apiClient.get(ApiEndpoints.aboutUs);
    return AboutUsModel.fromJson(response.data);
  }

  Future<TermsConditionModel> getTermsCondition() async {
    final response = await apiClient.get(ApiEndpoints.termsCondition);
    return TermsConditionModel.fromJson(response.data);
  }

  Future<CampusConnectModel> getCampusConnect() async {
    final response = await apiClient.get(ApiEndpoints.campusConnect);
    return CampusConnectModel.fromJson(response.data);
  }
}
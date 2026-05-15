import 'package:flutter/material.dart';
import '../model/about_us_model.dart';
import '../model/campus_connect_model.dart';
import '../model/privacy_policy_model.dart';
import '../model/terms_condition_model.dart';
import '../repo/cms_repository.dart';


class CMSProvider extends ChangeNotifier {
  final CMSRepository _repository = CMSRepository();

  bool isLoading = false;

  // Data
  PrivacyPolicyModel? privacyData;
  AboutUsModel? aboutUsData;
  TermsConditionModel? termsData;
  CampusConnectModel? campusData;

  Future<void> getPrivacyPolicy() async {
    await _getData(() async => privacyData = await _repository.getPrivacyPolicy());
  }

  Future<void> getAboutUs() async {
    await _getData(() async => aboutUsData = await _repository.getAboutUs());
  }

  Future<void> getTermsCondition() async {
    await _getData(() async => termsData = await _repository.getTermsCondition());
  }

  Future<void> getCampusConnect() async {
    await _getData(() async => campusData = await _repository.getCampusConnect());
  }

  Future<void> _getData(Future<void> Function() fetch) async {
    try {
      isLoading = true;
      notifyListeners();
      await fetch();
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
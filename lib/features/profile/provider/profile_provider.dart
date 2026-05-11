import 'package:flutter/material.dart';

import '../../profile/model/profile_model.dart';
import '../../profile/repo/profile_repository.dart';

class ProfileProvider extends ChangeNotifier {

  final ProfileRepository
  repository =
  ProfileRepository();

  bool isLoading = false;

  ProfileModel? profileModel;

  Future<void> getProfile() async {

    try{

      isLoading = true;

      notifyListeners();

      profileModel =
      await repository.getProfile();

    }catch(e){

      debugPrint(
        e.toString(),
      );

    }finally{

      isLoading = false;

      notifyListeners();
    }
  }
}
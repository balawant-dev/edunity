// import 'package:flutter/material.dart';
//
// import '../../../../core/utils/app_toast.dart';
// import '../model/college_code_model.dart';
//
// import '../repo/college_repository.dart';
//
// class CollegeProvider extends ChangeNotifier {
//
//   final TextEditingController codeController =
//   TextEditingController();
//
//   final CollegeRepository repository =
//   CollegeRepository();
//
//   bool isLoading = false;
//
//   CollegeModel? collegeModel;
//
//   Future<void> findCollege(
//       BuildContext context) async {
//
//     try{
//
//       isLoading = true;
//
//       notifyListeners();
//
//       collegeModel =
//       await repository.findCollege(
//         codeController.text.trim(),
//       );
//
//       AppToast.show(
//         collegeModel?.data.fullName ?? "",
//       );
//
//     }catch(e){
//
//       AppToast.show(e.toString());
//
//     }finally{
//
//       isLoading = false;
//
//       notifyListeners();
//     }
//   }
// }


import 'package:flutter/material.dart';

import '../../../../core/utils/app_toast.dart';

import '../model/college_code_model.dart';
import '../repo/college_repository.dart';

class CollegeProvider extends ChangeNotifier {

  final TextEditingController codeController =
  TextEditingController();

  final CollegeRepository repository =
  CollegeRepository();

  bool isLoading = false;

  CollegeModel? collegeModel;

  Future<void> findCollege(
      BuildContext context,
      ) async {

    try{

      isLoading = true;

      notifyListeners();

      collegeModel =
      await repository.findCollege(
        codeController.text.trim(),
      );

      AppToast.show(
        collegeModel?.data.fullName ?? "",
        backgroundColor: Colors.green,
      );

    }catch(e){

      AppToast.show(
        e.toString(),
        backgroundColor: Colors.red,
      );

    }finally{

      isLoading = false;

      notifyListeners();
    }
  }

  @override
  void dispose() {

    codeController.dispose();

    super.dispose();
  }
}
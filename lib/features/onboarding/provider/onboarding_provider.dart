import 'package:flutter/material.dart';

import '../../../core/routes/app_routes.dart';

class OnboardingProvider extends ChangeNotifier {

  final PageController pageController = PageController();

  int currentIndex = 0;

  void onPageChanged(int index) {
    currentIndex = index;
    notifyListeners();
  }

  Future<void> nextPage(BuildContext context) async {

    if(currentIndex < 2){

      await pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );

    }else{

      if(context.mounted){
        Navigator.pushReplacementNamed(context, AppRoutes.collegeCode);
      }
    }
  }

  void skip(BuildContext context){

    Navigator.pushReplacementNamed(context, AppRoutes.collegeCode);
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }
}
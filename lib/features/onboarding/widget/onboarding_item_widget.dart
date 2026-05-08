import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/theme/text_styles.dart';
import '../model/onboarding_model.dart';

class OnboardingItemWidget extends StatelessWidget {

  final OnboardingModel model;

  const OnboardingItemWidget({
    super.key,
    required this.model,
  });

  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),

      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,

        children: [

          /// IMAGE
          Image.asset(
            model.image,
            height: 320.h,
            fit: BoxFit.contain,
          ),

          SizedBox(height: 50.h),

          /// TITLE
          Text(
            model.title,
            textAlign: TextAlign.center,

            style: AppTextStyles.bold(
              size: 30.sp,
              color: AppColors.white,
            ),
          ),

          SizedBox(height: 18.h),

          /// SUBTITLE
          Text(
            model.subtitle,
            textAlign: TextAlign.center,

            style: AppTextStyles.regular(
              size: 15.sp,
              color: AppColors.grey,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}
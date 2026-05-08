import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/theme/text_styles.dart';

class OnboardingBottomWidget extends StatelessWidget {

  final int currentIndex;
  final VoidCallback onTap;

  const OnboardingBottomWidget({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),

      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,

        children: [

          /// INDICATOR
          Row(
            children: List.generate(
              3,
                  (index){

                bool isActive = currentIndex == index;

                return AnimatedContainer(

                  duration: const Duration(milliseconds: 300),

                  margin: EdgeInsets.only(right: 8.w),

                  height: 10.h,

                  width: isActive ? 28.w : 10.w,

                  decoration: BoxDecoration(
                    color: isActive
                        ? AppColors.border
                        : AppColors.grey.withOpacity(0.6),

                    borderRadius: BorderRadius.circular(100.r),
                  ),
                );
              },
            ),
          ),

          /// BUTTON
          GestureDetector(

            onTap: onTap,

            child: Container(

              height: 58.h,
              width: 58.w,

              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(18.r),
              ),

              child: Icon(
                Icons.arrow_forward_ios_rounded,
                color: AppColors.primary,
                size: 20.sp,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
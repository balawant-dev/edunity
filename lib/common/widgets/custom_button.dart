import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../core/constants/app_colors.dart';
import '../../core/theme/text_styles.dart';

class CustomButton extends StatelessWidget {

  final String text;
  final VoidCallback onTap;
  final bool isLoading;

  const CustomButton({
    super.key,
    required this.text,
    required this.onTap,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {

    return GestureDetector(

      onTap: isLoading ? null : onTap,

      child: Container(

        height: 50.h,
        decoration: ShapeDecoration(
          gradient: LinearGradient(
            begin: Alignment(0.00, 0.50),
            end: Alignment(1.00, 0.50),
            colors: [const Color(0xFF0128A1), const Color(0xFF404DAB)],
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
        ),

        // decoration: BoxDecoration(
        //
        //   borderRadius: BorderRadius.circular(14.r),
        //
        //   gradient: const LinearGradient(
        //     colors: [
        //       AppColors.primary,
        //       AppColors.secondary,
        //     ],
        //   ),
        // ),

        child: Center(

          child: isLoading

              ? SizedBox(
            height: 30.h,
                width: 30.w,
                child: const CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 3,


                          ),
              )

              : Text(
            text,
            style: AppTextStyles.semiBold(
              size: 16,
              color: AppColors.white,
            ),
          ),
        ),
      ),
    );
  }
}
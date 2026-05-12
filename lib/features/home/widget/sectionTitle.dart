import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../model/home_model.dart';
class SectionTitle extends StatelessWidget {

  final String title;
  final String buttonText;

  const SectionTitle({
    super.key,
    required this.title,
    required this.buttonText,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [

        Text(
          title,
          style:  TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.w600,
            color: AppColors2.textDark,
          ),
        ),

        const Spacer(),

        Text(
          buttonText,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            color: AppColors2.blue,
          ),
        ),

         SizedBox(width: 4.w),

         Icon(
          Icons.arrow_forward_ios,
          size: 14.sp,
          color: AppColors2.blue,
        ),
      ],
    );
  }
}
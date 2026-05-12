import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../model/home_model.dart';
class QuickActionCard extends StatelessWidget {

  final QuickActionModel model;

  const QuickActionCard({
    super.key,
    required this.model,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        margin:  EdgeInsets.only(right: 8.w),
        padding:  EdgeInsets.symmetric(
          vertical: 14.h,
          horizontal: 8.w,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14.r),
        ),

        child: Column(
          children: [

            Icon(
              model.icon,
              color: model.color,
            ),

             SizedBox(height: 8.h),

            Text(
              model.title,
              style: TextStyle(
                fontSize: 11.sp,
                color: Colors.grey.shade600,
              ),
            ),

             SizedBox(height: 6.h),

            Text(
              model.value,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: model.color,
              ),
            ),

             SizedBox(height: 4.h),

            Text(
              model.status,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 10.sp,
                color: Colors.grey.shade500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
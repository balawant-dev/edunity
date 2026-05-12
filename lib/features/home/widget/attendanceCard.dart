import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../model/home_model.dart';
class AttendanceCard extends StatelessWidget {

  final AttendanceCardModel model;

  const AttendanceCard({
    super.key,
    required this.model,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        height: 125.h,
        padding:  EdgeInsets.all(10.r),
        margin:  EdgeInsets.only(right: 8.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14.r),
        ),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Row(
              children: [

                CircleAvatar(
                  radius: 12.r,
                  backgroundColor: Colors.green.withOpacity(0.08),
                  child: Icon(
                    model.icon,
                    size: 16.sp,
                    color: model.color,
                  ),
                ),

                const SizedBox(width: 4),

                Text(
                  model.title,
                  style: TextStyle(
                    fontSize: 11.sp,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),

             SizedBox(height: 10.h),

            Text(
              model.value,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: model.color,
              ),
            ),

             SizedBox(height: 6.h),

            Text(
              model.subtitle,
              style:  TextStyle(fontSize: 11.sp),
            ),

             SizedBox(height: 8.h),

            if(model.bottomText.isNotEmpty)
              Text(
                model.bottomText,
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
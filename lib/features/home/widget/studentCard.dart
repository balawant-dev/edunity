import 'package:edunity/core/constants/app_images.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../model/home_model.dart';
class StudentCard extends StatelessWidget {

  final String name;

  final String course;

  final String userId;

  final String image;

  const StudentCard({
    super.key,

    required this.name,

    required this.course,

    required this.userId,

    required this.image,
  });

  @override
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          margin: EdgeInsets.only(left: 4.w),
          height: 120.h,
          width: 50.w,
          decoration: BoxDecoration(
            color: AppColors2.primary,
            borderRadius: BorderRadius.circular(20.r),
          ),
        ),

        // 2. Main White Card
        Container(
          height: 120,
          margin:  EdgeInsets.only(left: 10.w),
          padding:  EdgeInsets.all(14.r),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(.04),
                blurRadius: 10.r,
              ),
            ],
          ),
          child: Row(
            children: [
              // Purani accent line hata di hai kyunki piche wala container wahi kaam kar raha hai

              ClipRRect(
                borderRadius: BorderRadius.circular(14.r),
                child: Image.network(
                  image,
                  height: 80.h,
                  width: 80.w,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Image.asset(AppImages.logoNotFound, height: 80.h, width: 80.w, fit: BoxFit.cover);
                  },
                ),
              ),

              // --- Pehli Vertical Line ---
               SizedBox(width: 8.w),
              Container(width: 1.w, height: 70.h, color: Colors.grey.shade200),
               SizedBox(width: 8.w),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      name,
                      style:  TextStyle(fontWeight: FontWeight.bold, fontSize: 14.sp),
                    ),
                     SizedBox(height: 4.h),
                    Text(
                      "ID : $userId",
                      style:  TextStyle(fontWeight: FontWeight.w600, color: AppColors2.blue, fontSize: 12.sp),
                    ),
                     SizedBox(height: 4.h),
                    Row(
                      children: [
                         Icon(Icons.school, size: 14.sp, color: AppColors2.textGrey),
                         SizedBox(width: 4.w),
                        Text("$course", style:  TextStyle(color: AppColors2.textGrey, fontSize: 11.sp)),
                      ],
                    ),
                  ],
                ),
              ),

              // --- Dusri Vertical Line ---
              // const SizedBox(width: 8),
              // Container(width: 1, height: 70, color: Colors.grey.shade200),
              // const SizedBox(width: 8),
              //
              // Column(
              //   mainAxisSize: MainAxisSize.min,
              //   children: [
              //     Container(
              //       padding: const EdgeInsets.all(8),
              //       decoration: BoxDecoration(
              //         color: AppColors2.purple.withOpacity(.1),
              //         borderRadius: BorderRadius.circular(10),
              //       ),
              //       child: const Icon(Icons.calendar_month, color: AppColors2.purple, size: 20),
              //     ),
              //     const SizedBox(height: 4),
              //     Text("Session", style: TextStyle(color: Colors.grey.shade500, fontSize: 10)),
              //     Text("student.session", style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors2.primary, fontSize: 12)),
              //   ],
              // ),
            ],
          ),
        ),
      ],
    );
  }
}
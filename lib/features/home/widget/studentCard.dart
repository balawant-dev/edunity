import 'package:edunity/core/constants/app_images.dart';
import 'package:flutter/material.dart';

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
          margin: EdgeInsets.only(left: 4),
          height: 120,
          width: 50,
          decoration: BoxDecoration(
            color: AppColors2.primary,
            borderRadius: BorderRadius.circular(20),
          ),
        ),

        // 2. Main White Card
        Container(
          height: 120,
          margin: const EdgeInsets.only(left: 10),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(.04),
                blurRadius: 10,
              ),
            ],
          ),
          child: Row(
            children: [
              // Purani accent line hata di hai kyunki piche wala container wahi kaam kar raha hai

              ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: Image.network(
                  image,
                  height: 80,
                  width: 80,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Image.asset(AppImages.logoNotFound, height: 80, width: 80, fit: BoxFit.cover);
                  },
                ),
              ),

              // --- Pehli Vertical Line ---
              const SizedBox(width: 8),
              Container(width: 1, height: 70, color: Colors.grey.shade200),
              const SizedBox(width: 8),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "ID : $userId",
                      style: const TextStyle(fontWeight: FontWeight.w600, color: AppColors2.blue, fontSize: 12),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                         Icon(Icons.school, size: 14, color: AppColors2.textGrey),
                        const SizedBox(width: 4),
                        Text("$course", style: const TextStyle(color: AppColors2.textGrey, fontSize: 11)),
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
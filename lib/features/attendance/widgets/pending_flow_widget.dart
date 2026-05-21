import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_images.dart';
import '../../../core/routes/app_routes.dart';
import '../provider/attendance_provider.dart';

class PendingFlowWidget extends StatelessWidget {
  const PendingFlowWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            AppImages.illustration,
            scale: 5,
            //height: 200,
            fit: BoxFit.contain,
          ),
          const SizedBox(height: 40),
          const Text(
            "Verification Under Review",
            style: TextStyle(
              color: Colors.black,
              fontSize: 26,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.8,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            "We are currently reviewing your face verification. This usually takes a few hours. We'll notify you once it's done.",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.black.withOpacity(0.6),
              // Light grey feel on dark theme
              fontSize: 15,
              height: 1.5, // Better readability for multiline text
            ),
          ),
          const SizedBox(height: 50),
          // Ek secondary "Got it" ya "Refresh" button bhi de sakte hain professional feel ke liye
          OutlinedButton(
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.primary,
              side: const BorderSide(color: AppColors.primary),
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            onPressed: () async {

              final provider =
              context.read<AttendanceProvider>();

              await provider.getFaceStatus();
            },
            // onPressed: () {
            //   //ye same screen hi reload hoga ok
            //   Navigator.pushReplacementNamed(context, AppRoutes.faceAttendance);
            // },
            child: const Text("Refresh"),
          ),
        ],
      ),
    );
  }
}

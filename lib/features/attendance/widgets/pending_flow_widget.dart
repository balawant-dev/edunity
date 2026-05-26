import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_images.dart';
import '../provider/attendance_provider.dart';

class PendingFlowWidget extends StatelessWidget {
  final VoidCallback? onRefresh;

  const PendingFlowWidget({
    super.key,
    this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 30,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            AppImages.illustration,
            scale: 5,
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
              color: Colors.black.withOpacity(
                0.6,
              ),
              fontSize: 15,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 50),
          OutlinedButton(
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.primary,
              side: const BorderSide(
                color: AppColors.primary,
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: 40,
                vertical: 12,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            onPressed: () async {
              /// SELF FLOW
              if (onRefresh == null) {
                final provider = context.read<AttendanceProvider>();

                await provider.getFaceStatus();

                return;
              }

              /// MANAGER POPUP FLOW
              onRefresh!.call();
            },
            child: const Text(
              "Refresh",
            ),
          ),
        ],
      ),
    );
  }
}

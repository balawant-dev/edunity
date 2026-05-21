import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

class SuccessAttendanceDialog extends StatelessWidget {
  final VoidCallback onHomePressed;

  const SuccessAttendanceDialog({
    super.key,
    required this.onHomePressed,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 20,
              spreadRadius: 5,
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Success Icon
            Container(
              height: 90,
              width: 90,
              decoration: BoxDecoration(
                color: AppColors.green.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check_circle,
                size: 85,
                color: AppColors.green,
              ),
            ),

            const SizedBox(height: 20),

            const Text(
              "Face Matched Successfully!",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 8),

            const Text(
              "Your attendance has been marked successfully",
              style: TextStyle(
                fontSize: 15,
                color: Colors.grey,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 28),

            // Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: onHomePressed,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  "Go to Home",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
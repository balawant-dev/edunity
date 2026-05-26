import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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

class AttendanceSuccessPopup extends StatelessWidget {
  final VoidCallback onHomeTap;

  final bool isPunchIn;

  const AttendanceSuccessPopup({
    super.key,
    required this.onHomeTap,
    required this.isPunchIn,
  });

  @override
  Widget build(BuildContext context) {
    final now = DateFormat(
      "hh:mm a",
    ).format(
      DateTime.now(),
    );

    final title = isPunchIn ? "Punch In Successful" : "Punch Out Successful";

    final subtitle = isPunchIn
        ? "Your Punch In has been recorded successfully."
        : "Your Punch Out has been recorded successfully.";

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(
        horizontal: 26,
      ),
      child: Container(
        padding: const EdgeInsets.all(
          24,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(
            28,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            /// SUCCESS ICON

            Container(
              height: 90,
              width: 90,
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.check_circle,
                color: Colors.green.shade600,
                size: 62,
              ),
            ),

            const SizedBox(
              height: 22,
            ),

            /// TITLE

            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(
              height: 10,
            ),

            /// DESCRIPTION

            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey.shade700,
                fontSize: 14,
              ),
            ),

            const SizedBox(
              height: 22,
            ),

            /// TIME CARD

            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(
                vertical: 18,
              ),
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                borderRadius: BorderRadius.circular(
                  18,
                ),
              ),
              child: Column(
                children: [
                  Text(
                    isPunchIn ? "Punch In Time" : "Punch Out Time",
                    style: TextStyle(
                      color: Colors.grey.shade700,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(
                    height: 6,
                  ),
                  Text(
                    now,
                    style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(
              height: 28,
            ),

            /// HOME BUTTON CENTER

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: onHomeTap,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  minimumSize: const Size(
                    double.infinity,
                    54,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                      16,
                    ),
                  ),
                ),
                child: const Text(
                  "Home",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
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

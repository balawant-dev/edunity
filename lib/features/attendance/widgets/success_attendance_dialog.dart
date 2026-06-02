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
  final String action;

  final String employeeName;
  final String employeeId;
  final String? imageUrl;

  const AttendanceSuccessPopup({
    super.key,
    required this.onHomeTap,
    required this.action,
    required this.employeeName,
    required this.employeeId,
    this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    final now = DateFormat(
      "hh:mm a",
    ).format(
      DateTime.now(),
    );

    String title;
    String subtitle;
    String timeLabel;

    switch (action) {
      case "In":
        title = "Punch In Successful";
        subtitle = "Your Punch In has been recorded successfully.";
        timeLabel = "Punch In Time";
        break;

      case "Out":
        title = "Punch Out Successful";
        subtitle = "Your Punch Out has been recorded successfully.";
        timeLabel = "Punch Out Time";
        break;

      case "Start Break":
        title = "Break Started";
        subtitle = "Your break has been started successfully.";
        timeLabel = "Break Start Time";
        break;

      case "End Break":
        title = "Break Ended";
        subtitle = "Your break has been ended successfully.";
        timeLabel = "Break End Time";
        break;

      default:
        title = "Attendance Updated";
        subtitle = "Attendance marked successfully.";
        timeLabel = "Time";
    }

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
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(22),
                border: Border.all(
                  color: Colors.grey.shade200,
                ),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.grey.shade200,
                    backgroundImage: imageUrl != null && imageUrl!.isNotEmpty
                        ? NetworkImage(imageUrl!)
                        : null,
                    child: imageUrl == null || imageUrl!.isEmpty
                        ? const Icon(
                            Icons.person,
                            size: 30,
                          )
                        : null,
                  ),
                  const SizedBox(
                    width: 14,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          employeeName,
                          style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(
                          height: 4,
                        ),
                        Text(
                          "ID : $employeeId",
                          style: TextStyle(
                            color: Colors.grey.shade700,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(
              height: 22,
            ),

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
                    timeLabel,
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

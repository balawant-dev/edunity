// import 'package:flutter/material.dart';
// import '../../../core/constants/app_colors.dart';
//
// class SuccessAttendanceDialog extends StatelessWidget {
//   final VoidCallback onHomePressed;
//
//   const SuccessAttendanceDialog({
//     super.key,
//     required this.onHomePressed,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Dialog(
//       backgroundColor: Colors.transparent,
//       elevation: 0,
//       child: Container(
//         padding: const EdgeInsets.all(24),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(20),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black.withOpacity(0.1),
//               blurRadius: 20,
//               spreadRadius: 5,
//             ),
//           ],
//         ),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             // Success Icon
//             Container(
//               height: 90,
//               width: 90,
//               decoration: BoxDecoration(
//                 color: AppColors.green.withOpacity(0.1),
//                 shape: BoxShape.circle,
//               ),
//               child: const Icon(
//                 Icons.check_circle,
//                 size: 85,
//                 color: AppColors.green,
//               ),
//             ),
//
//             const SizedBox(height: 20),
//
//             const Text(
//               "Face Matched Successfully!",
//               style: TextStyle(
//                 fontSize: 20,
//                 fontWeight: FontWeight.bold,
//               ),
//               textAlign: TextAlign.center,
//             ),
//
//             const SizedBox(height: 8),
//
//             const Text(
//               "Your attendance has been marked successfully",
//               style: TextStyle(
//                 fontSize: 15,
//                 color: Colors.grey,
//               ),
//               textAlign: TextAlign.center,
//             ),
//
//             const SizedBox(height: 28),
//
//             // Button
//             SizedBox(
//               width: double.infinity,
//               child: ElevatedButton(
//                 onPressed: onHomePressed,
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: AppColors.primary,
//                   padding: const EdgeInsets.symmetric(vertical: 16),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                 ),
//                 child: const Text(
//                   "Go to Home",
//                   style: TextStyle(
//                     fontSize: 16,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.white,
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';

class AttendanceSuccessPopup extends StatelessWidget {
  final VoidCallback onHomeTap;

  const AttendanceSuccessPopup({
    super.key,
    required this.onHomeTap,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [

            /// Success Icon
            Container(
              height: 80,
              width: 80,
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.check_circle,
                color: Colors.green.shade600,
                size: 55,
              ),
            ),

            const SizedBox(height: 18),

            /// Title
            const Text(
              "Attendance Marked",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            /// Description
            Text(
              "Your attendance has been marked successfully.",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey.shade700,
                fontSize: 14,
              ),
            ),

            const SizedBox(height: 20),

            /// Checkbox Row
            StatefulBuilder(
              builder: (context, setState) {
                bool isChecked = true;

                return Row(
                  children: [
                    Checkbox(
                      value: isChecked,
                      activeColor: Colors.green,
                      onChanged: (value) {
                        setState(() {
                          isChecked = value ?? false;
                        });
                      },
                    ),

                    const Expanded(
                      child: Text(
                        "I confirm my attendance for today",
                        style: TextStyle(
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),

            const SizedBox(height: 20),

            /// Buttons
            Row(
              children: [

                /// Close Button
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 52),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: const Text("Close"),
                  ),
                ),

                const SizedBox(width: 12),

                /// Home Button
                Expanded(
                  child: ElevatedButton(
                    onPressed: onHomeTap,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      minimumSize: const Size(double.infinity, 52),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: const Text(
                      "Home",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';

import '../../../common/widgets/custom_button.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/utils/app_toast.dart';
import '../provider/attendance_provider.dart';
import 'camera_preview_widget.dart';
import 'info_card_widget.dart';

class ApprovedFlowWidget extends StatelessWidget {

  final AttendanceProvider provider;

  const ApprovedFlowWidget({
    super.key,
    required this.provider,
  });

  @override
  Widget build(BuildContext context) {

    final attendance =
        provider.todayAttendanceModel;

    final summary =
        attendance?.attendanceSummary;

    return Padding(

      padding: const EdgeInsets.all(20),

      child: Column(

        children: [

          /// VERIFIED CARD

          Container(

            width: double.infinity,

            padding: const EdgeInsets.all(16),

            decoration: BoxDecoration(

              color: Colors.green.shade50,

              borderRadius:
              BorderRadius.circular(20),

              border: Border.all(
                color: Colors.green,
              ),
            ),

            child: const Row(

              children: [

                Icon(
                  Icons.verified,
                  color: Colors.green,
                ),

                SizedBox(width: 10),

                Expanded(

                  child: Text(

                    "Face verified successfully. You can mark attendance now.",
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          /// CAMERA

          Expanded(

            child: CameraPreviewWidget(
              provider: provider,
              showProgress: false,
            ),
          ),

          const SizedBox(height: 20),

          /// INFO

          InfoCardWidget(
            text: provider.instructionText,
          ),

          const SizedBox(height: 20),
          CustomButton(

            isLoading: provider.isPunchLoading,

            text:
            (summary?.timeline == null ||
                summary!.timeline.isEmpty)

                ? "Punch In"

                : (summary.timeline.last.type == "In"

                ? "Punch Out"

                : "Punch In"),

            onTap: () async {

              final location =
                  attendance
                      ?.assignment
                      ?.locations
                      .first;

              if (location == null) {
                return;
              }

              /// AUTO FACE SCAN
              final success =
              await provider.capturePunchImage();

              if (!success) {
                return;
              }

              /// API CALL
              await provider.punchAttendance(
                locationId: location.locationId,
              );

              if (context.mounted) {

                AppToast.show(

                  provider
                      .punchResponseModel
                      ?.message ??

                      "Attendance Updated",
                );
              }
            },
          ),

          /// BUTTON
          // CustomButton(onTap: () async {
          //
          //   final location =
          //       attendance
          //           ?.assignment
          //           ?.locations
          //           .first;
          //
          //   if (location == null) {
          //     return;
          //   }
          //
          //   /// ONLY ONE IMAGE
          //   await provider.capturePunchImage();
          //
          //   await provider.punchAttendance(
          //     locationId: location.locationId,
          //   );
          //
          //   if (context.mounted) {
          //     AppToast.show(
          //       provider
          //           .punchResponseModel
          //           ?.message ??
          //           "",
          //     );
          //
          //     // ScaffoldMessenger.of(context)
          //     //     .showSnackBar(
          //
          //       // SnackBar(
          //       //
          //       //   content: Text(
          //       //
          //       //     provider
          //       //         .punchResponseModel
          //       //         ?.message ??
          //       //         "",
          //       //   ),
          //       // ),
          //     // );
          //   }
          // },isLoading: provider.isPunchLoading,text:  (summary?.timeline == null ||
          //     summary!.timeline.isEmpty)
          //
          //     ? "Punch In"
          //
          //     : (summary.timeline.last.type ==
          //     "In"
          //
          //     ? "Punch Out"
          //
          //     : "Punch In"),),

          // SizedBox(
          //
          //   width: double.infinity,
          //   height: 55,
          //
          //   child: ElevatedButton(
          //                                   style: ElevatedButton.styleFrom(
          //                       backgroundColor: AppColors.deepPrimary,
          //                       foregroundColor: AppColors.white,
          //                       shape: RoundedRectangleBorder(
          //                         borderRadius: BorderRadius.circular(16),
          //                       ),
          //                     ),
          //
          //     onPressed:
          //     provider.isPunchLoading
          //
          //         ? null
          //
          //         : () async {
          //
          //       final location =
          //           attendance
          //               ?.assignment
          //               ?.locations
          //               .first;
          //
          //       if (location == null) {
          //         return;
          //       }
          //
          //       /// ONLY ONE IMAGE
          //       await provider.capturePunchImage();
          //
          //       await provider.punchAttendance(
          //         locationId: location.locationId,
          //       );
          //
          //       if (context.mounted) {
          //
          //         ScaffoldMessenger.of(context)
          //             .showSnackBar(
          //
          //           SnackBar(
          //
          //             content: Text(
          //
          //               provider
          //                   .punchResponseModel
          //                   ?.message ??
          //                   "",
          //             ),
          //           ),
          //         );
          //       }
          //     },
          //
          //     child:
          //     provider.isPunchLoading
          //
          //         ? const CircularProgressIndicator()
          //
          //         : Text(
          //
          //       (summary?.timeline == null ||
          //           summary!.timeline.isEmpty)
          //
          //           ? "Punch In"
          //
          //           : (summary.timeline.last.type ==
          //           "In"
          //
          //           ? "Punch Out"
          //
          //           : "Punch In"),
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
}
import 'package:edunity/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

import '../../../common/widgets/custom_button.dart';
import '../../../core/utils/app_toast.dart';
import '../provider/attendance_provider.dart';
import 'camera_preview_widget.dart';
import 'info_card_widget.dart';
import 'primary_image_widget.dart';

class RegistrationFlowWidget extends StatelessWidget {

  final AttendanceProvider provider;

  const RegistrationFlowWidget({
    super.key,
    required this.provider,
  });

  @override
  Widget build(BuildContext context) {

    return Padding(


      padding: const EdgeInsets.all(12),

      child: Column(

        children: [

          /// PRIMARY IMAGE

          PrimaryImageWidget(
            provider: provider,
          ),

          const SizedBox(height: 20),

          /// CAMERA

          Expanded(
            child: CameraPreviewWidget(
              provider: provider,
              showProgress: true,
            ),
          ),

          const SizedBox(height: 20),

          /// INFO

          InfoCardWidget(
            text: provider.instructionText,
          ),

          const SizedBox(height: 20),

          /// BUTTON
          ///
          CustomButton(text:  "Start Face Scan",isLoading: provider.isRegistering,onTap:() async {

            if (provider.primaryImage == null) {
              AppToast.show(

                "Please select primary image",
                backgroundColor: AppColors.red

              );

              // ScaffoldMessenger.of(context)
              //     .showSnackBar(
              //
              //   const SnackBar(
              //
              //     content: Text(
              //       "Please select primary image",
              //     ),
              //   ),
              // );

              return;
            }

            await provider.startAutoCapture();
          } ,),

          // SizedBox(
          //
          //   width: double.infinity,
          //   height: 55,
          //
          //   child: ElevatedButton(
          //
          //     onPressed: () async {
          //
          //       if (provider.primaryImage == null) {
          //
          //         ScaffoldMessenger.of(context)
          //             .showSnackBar(
          //
          //           const SnackBar(
          //
          //             content: Text(
          //               "Please select primary image",
          //             ),
          //           ),
          //         );
          //
          //         return;
          //       }
          //
          //       await provider.startAutoCapture();
          //     },
          //
          //     child: provider.isCapturing
          //
          //         ? Text(
          //       "Capturing ${provider.captureCount}/20",
          //     )
          //
          //         : provider.isRegistering
          //
          //         ? const CircularProgressIndicator()
          //
          //         : const Text(
          //       "Register Face",
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
}
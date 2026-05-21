import 'dart:io';

import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../provider/attendance_provider.dart';

class PrimaryImageWidget extends StatelessWidget {

  final AttendanceProvider provider;

  const PrimaryImageWidget({
    super.key,
    required this.provider,
  });

  @override
  Widget build(BuildContext context) {

    return Container(

      padding: const EdgeInsets.all(12),

      decoration: BoxDecoration(

        color: Colors.black12,

        borderRadius: BorderRadius.circular(24),
      ),

      child: Row(

        children: [

          /// IMAGE
          GestureDetector(

            onTap: () {

              _showImagePickerSheet(
                context,
                provider,
              );
            },

            child: Stack(

              children: [

                CircleAvatar(

                  radius: 35,

                  backgroundColor: Colors.white,

                  backgroundImage:
                  provider.primaryImage != null

                      ? FileImage(
                    File(
                      provider.primaryImage!.path,
                    ),
                  )

                      : null,

                  child:
                  provider.primaryImage == null

                      ? const Icon(

                    Icons.person,

                    size: 45,

                    color: Colors.grey,
                  )

                      : null,
                ),

                Positioned(

                  bottom: 0,
                  right: 0,

                  child: Container(

                    padding: const EdgeInsets.all(5),

                    decoration: const BoxDecoration(

                      color: AppColors.deepPrimary,

                      shape: BoxShape.circle,
                    ),

                    child: const Icon(

                      Icons.add_a_photo,

                      size: 16,

                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 16),

          /// TEXT
          const Expanded(

            child: Column(

              crossAxisAlignment:
              CrossAxisAlignment.start,

              children: [

                Text(

                  "Primary Face Image",

                  style: TextStyle(

                    color: Colors.black,

                    fontWeight: FontWeight.bold,

                    fontSize: 16,
                  ),
                ),

                SizedBox(height: 5),
                Text(
                  "Please upload a clear face photo for verification",
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// =========================================================
  /// BOTTOM SHEET
  /// =========================================================

  void _showImagePickerSheet(
      BuildContext context,
      AttendanceProvider provider,
      ) {

    showModalBottomSheet(

      context: context,

      backgroundColor: Colors.white,

      shape: const RoundedRectangleBorder(

        borderRadius: BorderRadius.vertical(

          top: Radius.circular(24),
        ),
      ),

      builder: (_) {

        return Padding(

          padding: const EdgeInsets.all(20),

          child: Column(

            mainAxisSize: MainAxisSize.min,

            children: [

              Container(

                width: 50,
                height: 5,

                decoration: BoxDecoration(

                  color: Colors.grey.shade300,

                  borderRadius:
                  BorderRadius.circular(20),
                ),
              ),

              const SizedBox(height: 20),

              const Text(

                "Choose Primary Image",

                style: TextStyle(

                  fontSize: 18,

                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 10),
              Text(
                "Please upload a clear face photo for verification",
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 10),

              Row(
mainAxisAlignment: MainAxisAlignment.center,
                children: [

                  _buildOptionCard(

                    icon: Icons.camera_alt,

                    title: "Camera",

                    onTap: () async {

                      Navigator.pop(context);

                      /// USER CLICK KAREGA TAB IMAGE OPEN HOGA
                      await provider.capturePrimaryImage();
                    },
                  ),

                  // const SizedBox(width: 16),

                  // Expanded(
                  //
                  //   child: _buildOptionCard(
                  //
                  //     icon: Icons.photo,
                  //
                  //     title: "Gallery",
                  //
                  //     onTap: () async {
                  //
                  //       Navigator.pop(context);
                  //
                  //       await provider
                  //           .pickPrimaryImageFromGallery();
                  //     },
                  //   ),
                  // ),
                ],
              ),

              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  /// =========================================================
  /// OPTION CARD
  /// =========================================================

  Widget _buildOptionCard({

    required IconData icon,

    required String title,

    required VoidCallback onTap,
  }) {

    return InkWell(

      borderRadius: BorderRadius.circular(18),

      onTap: onTap,

      child: Container(
        height: 100,
        width: 100,

        padding: const EdgeInsets.symmetric(
          vertical: 20,
        ),

        decoration: BoxDecoration(

          color: Colors.black12,

          borderRadius:
          BorderRadius.circular(18),
        ),

        child: Column(

          children: [

            Icon(

              icon,

              size: 30,

              color: AppColors.deepPrimary,
            ),

            const SizedBox(height: 10),

            Text(

              title,

              style: const TextStyle(

                fontWeight: FontWeight.w600,

                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
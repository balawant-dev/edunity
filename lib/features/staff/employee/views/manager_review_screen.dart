import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../attendance/provider/attendance_provider.dart';
import '../model/onbehalf_employee_model.dart';
import '../widgets/step_indicator_widget.dart';
import 'manager_registration_success_screen.dart';

class ManagerReviewScreen extends StatelessWidget {
  final EmployeeData employee;

  const ManagerReviewScreen({
    super.key,
    required this.employee,
  });

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AttendanceProvider>();

    return Scaffold(
      backgroundColor: const Color(0xffF7F8FA),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: true,
        title: const Text(
          "Face Registration\nvia Manager",
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.black,
            fontSize: 15,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const StepIndicatorWidget(
                step: 3,
              ),

              const SizedBox(height: 24),

              const Text(
                "Review & Confirm",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),

              const SizedBox(height: 8),

              const Text(
                "Verify the primary image and all captured faces.",
                style: TextStyle(
                  color: Colors.grey,
                ),
              ),

              const SizedBox(height: 24),

              /// PRIMARY
              const Text(
                "Primary Image",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                ),
              ),

              const SizedBox(height: 12),

              Center(
                child: Container(
                  height: 150,
                  width: 130,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    image: provider.primaryImage != null
                        ? DecorationImage(
                            image: FileImage(
                              File(
                                provider.primaryImage!.path,
                              ),
                            ),
                            fit: BoxFit.cover,
                          )
                        : null,
                    color: Colors.grey.shade200,
                  ),
                ),
              ),

              const SizedBox(height: 24),

              Text(
                "Captured Faces (${provider.croppedFaceImages.length})",
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                ),
              ),

              const SizedBox(height: 12),

              SizedBox(
                height: 90,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: provider.croppedFaceImages.length,
                  itemBuilder: (context, index) {
                    final image = provider.croppedFaceImages[index];

                    return Container(
                      width: 70,
                      margin: const EdgeInsets.only(
                        right: 10,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        image: DecorationImage(
                          image: FileImage(
                            image,
                          ),
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: Align(
                        alignment: Alignment.bottomRight,
                        child: Container(
                          margin: const EdgeInsets.all(4),
                          padding: const EdgeInsets.all(3),
                          decoration: const BoxDecoration(
                            color: Colors.green,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.check,
                            size: 12,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 20),

              /// INFO
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xffEEF4FF),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: Colors.blue,
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        "Ensure all faces are clear and visible before confirming.",
                        style: TextStyle(
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const Spacer(),

              /// RETAKE
              SizedBox(
                width: double.infinity,
                height: 52,
                child: OutlinedButton(
                  onPressed: () {
                    provider.resetFaceScanner();

                    Navigator.pop(
                      context,
                    );
                  },
                  child: const Text(
                    "Retake",
                  ),
                ),
              ),

              const SizedBox(height: 12),

              /// CONFIRM
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                  ),
                  onPressed: provider.isRegistering
                      ? null
                      : () async {
                          await provider.registerEmployeeByManager();
                          if (context.mounted) {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    ManagerRegistrationSuccessScreen(
                                  provider: provider,
                                  employee: employee,
                                ),
                              ),
                            );
                          }
                          // if (context.mounted) {
                          //   await provider.registerEmployeeByManager();
                          //
                          //
                          //   // showDialog(
                          //   //   context: context,
                          //   //   builder: (_) => AlertDialog(
                          //   //     title: const Text(
                          //   //       "Success",
                          //   //     ),
                          //   //     content: const Text(
                          //   //       "Face registration submitted successfully.\nAwaiting admin approval.",
                          //   //     ),
                          //   //     actions: [
                          //   //       TextButton(
                          //   //         onPressed: () {
                          //   //           Navigator.pop(context);
                          //   //
                          //   //           Navigator.popUntil(
                          //   //             context,
                          //   //             (route) => route.isFirst,
                          //   //           );
                          //   //         },
                          //   //         child: const Text(
                          //   //           "OK",
                          //   //         ),
                          //   //       )
                          //   //     ],
                          //   //   ),
                          //   // );
                          // }
                        },
                  child: provider.isRegistering
                      ? const CircularProgressIndicator(
                          color: Colors.white,
                        )
                      : const Text(
                          "Confirm & Register",
                        ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

import 'dart:io';

import 'package:flutter/material.dart';

import '../../../attendance/provider/attendance_provider.dart';
import '../model/onbehalf_employee_model.dart';
import '../widgets/step_indicator_widget.dart';

class ManagerRegistrationSuccessScreen extends StatelessWidget {
  final AttendanceProvider provider;
  final EmployeeData employee;

  const ManagerRegistrationSuccessScreen({
    super.key,
    required this.provider,
    required this.employee,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF7F8FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const BackButton(),
        centerTitle: true,
        title: const Text(
          "Face Registration\nvia Manager",
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.black,
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              const StepIndicatorWidget(
                step: 4,
              ),

              const SizedBox(height: 30),

              /// SUCCESS ICON
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_circle,
                  color: Colors.green,
                  size: 44,
                ),
              ),

              const SizedBox(height: 20),

              const Text(
                "Registration Successful!",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 8),

              Text(
                "Face has been registered for\n${employee.name} (${employee.employeeId})",
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 14,
                ),
              ),

              const SizedBox(height: 28),

              /// SUMMARY CARD
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Summary",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),

                    const SizedBox(height: 20),

                    /// PRIMARY
                    Row(
                      children: [
                        if (provider.primaryImage != null)
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.file(
                              File(
                                provider.primaryImage!.path,
                              ),
                              width: 42,
                              height: 42,
                              fit: BoxFit.cover,
                            ),
                          ),
                        const SizedBox(width: 12),
                        const Expanded(
                          child: Text(
                            "Primary Image",
                          ),
                        ),
                        const Text(
                          "1 Image",
                          style: TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),

                    const Divider(height: 28),

                    // /// CAPTURED
                    // Row(
                    //   children: [
                    //     Expanded(
                    //       child: SizedBox(
                    //         height: 42,
                    //         child: ListView.builder(
                    //           scrollDirection: Axis.horizontal,
                    //           itemCount: provider.croppedFaceImages.length,
                    //           itemBuilder: (
                    //             context,
                    //             index,
                    //           ) {
                    //             return Container(
                    //               margin: const EdgeInsets.only(
                    //                 right: 6,
                    //               ),
                    //               child: ClipRRect(
                    //                 borderRadius: BorderRadius.circular(8),
                    //                 child: Image.file(
                    //                   provider.croppedFaceImages[index],
                    //                   width: 42,
                    //                   height: 42,
                    //                   fit: BoxFit.cover,
                    //                 ),
                    //               ),
                    //             );
                    //           },
                    //         ),
                    //       ),
                    //     ),
                    //     Text(
                    //       "${provider.croppedFaceImages.length} Images",
                    //       style: const TextStyle(
                    //         color: Colors.grey,
                    //       ),
                    //     ),
                    //   ],
                    // ),
                    //
                    // const Divider(height: 28),

                    /// REGISTER DATE
                    // _row(
                    //   "Registered On",
                    //   provider
                    //       .faceRegistrationModel
                    //       ?.createdAt ??
                    //       "-",
                    // ),

                    const SizedBox(height: 14),

                    /// STATUS
                    _row(
                      "Registration By",
                      "API / Manager Approval",
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              /// DONE
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  onPressed: () {
                    Navigator.popUntil(
                      context,
                      (route) => route.isFirst,
                    );
                  },
                  child: const Text(
                    "Done",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 12),

              TextButton(
                onPressed: () {
                  Navigator.popUntil(
                    context,
                    (route) => route.isFirst,
                  );
                },
                child: const Text(
                  "Register Another Employee",
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _row(
    String title,
    String value,
  ) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: const TextStyle(
              color: Colors.grey,
            ),
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

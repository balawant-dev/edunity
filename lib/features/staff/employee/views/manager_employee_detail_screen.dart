import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../attendance/provider/attendance_provider.dart';
import '../model/onbehalf_employee_model.dart';
import '../provider/manager_face_provider.dart';
import '../widgets/step_indicator_widget.dart';
import 'manager_capture_face_screen.dart';

class ManagerEmployeeDetailScreen extends StatefulWidget {
  final EmployeeData employee;

  const ManagerEmployeeDetailScreen({
    super.key,
    required this.employee,
  });

  @override
  State<ManagerEmployeeDetailScreen> createState() =>
      _ManagerEmployeeDetailScreenState();
}

class _ManagerEmployeeDetailScreenState
    extends State<ManagerEmployeeDetailScreen> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      // context.read<ManagerFaceProvider>().getEmployeeDetail(
      //       widget.employee.uid!,
      //     );

      context.read<AttendanceProvider>().selectEmployee(
            widget.employee.uid!,
          );
    });
  }

  @override
  Widget build(BuildContext context) {
    final manager = context.watch<ManagerFaceProvider>();

    /// IMPORTANT
    final attendanceProvider = context.watch<AttendanceProvider>();

    final detail = manager.detailModel;

    return Scaffold(
      backgroundColor: const Color(0xffF7F8FA),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
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
      body: manager.isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const StepIndicatorWidget(
                      step: 1,
                    ),

                    const SizedBox(height: 26),

                    const Text(
                      "Employee Details",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),

                    const SizedBox(height: 18),

                    /// EMPLOYEE ID
                    const Text(
                      "Employee ID",
                    ),

                    const SizedBox(height: 8),

                    Container(
                      height: 52,
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Colors.grey.shade300,
                        ),
                      ),
                      child: Text(
                        widget.employee.employeeId ?? "",
                      ),
                    ),

                    const SizedBox(height: 22),

                    /// PRIMARY IMAGE
                    const Text(
                      "Primary Image *",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    const SizedBox(height: 6),

                    const Text(
                      "Upload a clear front-facing image",
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),

                    const SizedBox(height: 12),

                    /// IMAGE CARD
                    GestureDetector(
                      onTap: () {
                        attendanceProvider.capturePrimaryImage();
                      },
                      child: Container(
                        width: 120,
                        height: 150,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: Colors.grey.shade300,
                          ),
                        ),
                        child: Stack(
                          children: [
                            if (attendanceProvider.primaryImage != null)
                              ClipRRect(
                                borderRadius: BorderRadius.circular(16),
                                child: Image.file(
                                  File(
                                    attendanceProvider.primaryImage!.path,
                                  ),
                                  width: double.infinity,
                                  height: double.infinity,
                                  fit: BoxFit.cover,
                                ),
                              )
                            else
                              const Center(
                                child: Icon(
                                  Icons.person,
                                  size: 45,
                                  color: Colors.grey,
                                ),
                              ),
                            Positioned(
                              right: 8,
                              top: 8,
                              child: CircleAvatar(
                                radius: 14,
                                backgroundColor: Colors.blue,
                                child: const Icon(
                                  Icons.camera_alt,
                                  color: Colors.white,
                                  size: 14,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    /// INFO CARD
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Employee Information",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),
                          _infoRow(
                            "Name",
                            widget.employee.name ?? "-",
                          ),
                          _infoRow(
                            "Department",
                            widget.employee.department ?? "-",
                          ),
                          _infoRow(
                            "Email",
                            widget.employee.email ?? "-",
                          ),
                          _infoRow(
                            "Phone",
                            widget.employee.mobile ?? "-",
                          ),
                          if (detail?.assignment?.shift?.name != null)
                            _infoRow(
                              "Shift",
                              detail!.assignment!.shift!.name ?? "",
                            ),
                          if (detail?.attendanceSummary?.status != null)
                            _infoRow(
                              "Attendance",
                              detail!.attendanceSummary!.status ?? "",
                            ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 28),

                    SizedBox(
                      width: double.infinity,
                      height: 54,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        onPressed: attendanceProvider.primaryImage == null
                            ? null
                            : () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => ManagerCaptureFaceScreen(
                                      employee: widget.employee,
                                    ),
                                  ),
                                );
                              },
                        child: const Text(
                          "Continue",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _infoRow(
    String title,
    String value,
  ) {
    return Padding(
      padding: const EdgeInsets.only(
        bottom: 12,
      ),
      child: Row(
        children: [
          SizedBox(
            width: 100,
            child: Text(
              title,
              style: const TextStyle(
                color: Colors.grey,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

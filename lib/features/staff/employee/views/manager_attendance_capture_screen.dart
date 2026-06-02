import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../common/widgets/custom_button.dart';
import '../../../attendance/provider/attendance_provider.dart';
import '../../../attendance/widgets/camera_preview_widget.dart';
import '../../../attendance/widgets/info_card_widget.dart';
import '../model/onbehalf_employee_model.dart';
import 'manager_punch_success_screen.dart';

class ManagerAttendanceCaptureScreen extends StatefulWidget {
  final EmployeeData employee;

  const ManagerAttendanceCaptureScreen({
    super.key,
    required this.employee,
  });

  @override
  State<ManagerAttendanceCaptureScreen> createState() =>
      _ManagerAttendanceCaptureScreenState();
}

class _ManagerAttendanceCaptureScreenState
    extends State<ManagerAttendanceCaptureScreen> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() async {
      final provider = context.read<AttendanceProvider>();

      await provider.initialize();

      await provider.getManagerEmployeeAttendance(
        widget.employee.uid!,
      );
      await provider.getFaceImages();

      await provider.prepareManagerEmployeeEmbeddings();
      // await provider.getFaceImages();
    });
  }

  Future<void> _handlePunch() async {
    final provider = context.read<AttendanceProvider>();

    final attendance = provider.managerTodayAttendanceModel;

    final location = attendance?.assignment?.locations.first;

    if (location == null) {
      return;
    }

    /// VERIFY FACE

    final verified = await provider.verifyFaceAndPunch(
      context,
    );

    if (!verified) {
      return;
    }

    /// PUNCH

    await provider.managerPunchAttendance(
      uid: widget.employee.uid!,
      locationId: location.locationId,
      context: context,
    );

    if (context.mounted && provider.punchResponseModel != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => ManagerPunchSuccessScreen(
            employee: widget.employee,
          ),
        ),
      );
    }
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    final provider = context.watch<AttendanceProvider>();

    final attendance = provider.managerTodayAttendanceModel;

    final summary = attendance?.attendanceSummary;

    final isPunchIn = summary?.timeline == null ||
        summary!.timeline.isEmpty ||
        summary.timeline.last.type != "In";

    return Scaffold(
      backgroundColor: const Color(0xffF7F8FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const BackButton(),
        centerTitle: true,
        title: const Text(
          "Capture Image",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: provider.isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    /// EMPLOYEE CARD
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 24,
                            child: Text(
                              widget.employee.name!.substring(0, 1),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.employee.name ?? "",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  "${widget.employee.employeeId} •",
                                  // "${widget.employee.employeeId} • ${attendance?.assignment?.shift?.name ?? ""}",
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 5,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.green.withOpacity(
                                    .1,
                                  ),
                                  borderRadius: BorderRadius.circular(
                                    20,
                                  ),
                                ),
                                child: Text(
                                  summary?.status ?? "",
                                  style: const TextStyle(
                                    color: Colors.green,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 12,
                                  ),
                                ),
                              ),

                              const SizedBox(height: 6),

                              // Text(
                              //   summary?.punchInTime ??
                              //       "--",
                              //   style:
                              //   const TextStyle(
                              //     fontSize:
                              //     11,
                              //     color:
                              //     Colors.grey,
                              //   ),
                              // ),
                            ],
                          )
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    /// INFO
                    InfoCardWidget(
                      text: "Capture employee's face for verification",
                    ),

                    const SizedBox(height: 16),

                    /// CAMERA
                    Expanded(
                      child: CameraPreviewWidget(
                        provider: provider,
                        showProgress: false,
                      ),
                    ),

                    const SizedBox(height: 18),

                    const Text(
                      "Ensure well-lit area and clear face",
                      style: TextStyle(
                        color: Colors.grey,
                      ),
                    ),

                    const SizedBox(height: 20),

                    /// BUTTON
                    CustomButton(
                      text: isPunchIn ? "Punch In" : "Punch Out",
                      isLoading: provider.isPunchLoading,
                      onTap: _handlePunch,
                    )
                  ],
                ),
              ),
            ),
    );
  }
}

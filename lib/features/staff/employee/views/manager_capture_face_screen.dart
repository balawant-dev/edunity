import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../common/widgets/custom_button.dart';
import '../../../attendance/provider/attendance_provider.dart';
import '../../../attendance/widgets/registration_flow_widget.dart';
import '../model/onbehalf_employee_model.dart';
import '../widgets/step_indicator_widget.dart';
import 'manager_review_screen.dart';

class ManagerCaptureFaceScreen extends StatefulWidget {
  final EmployeeData employee;

  const ManagerCaptureFaceScreen({
    super.key,
    required this.employee,
  });

  @override
  State<ManagerCaptureFaceScreen> createState() =>
      _ManagerCaptureFaceScreenState();
}

class _ManagerCaptureFaceScreenState extends State<ManagerCaptureFaceScreen> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      final provider = context.read<AttendanceProvider>();

      provider.initialize();

      provider.setManagerFlow(true);
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AttendanceProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Face Registration\nvia Manager",
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.all(16),
              child: StepIndicatorWidget(
                step: 2,
              ),
            ),
            Expanded(
              child: RegistrationFlowWidget(
                provider: provider,
              ),
            ),
            provider.captureCount >= 5
                // ? SizedBox(
                //     width: double.infinity,
                //     height: 54,
                //     child: ElevatedButton(
                //       style: ElevatedButton.styleFrom(
                //         backgroundColor: Colors.blue,
                //         shape: RoundedRectangleBorder(
                //           borderRadius: BorderRadius.circular(14),
                //         ),
                //       ),
                //       onPressed: () {
                //         Navigator.push(
                //           context,
                //           MaterialPageRoute(
                //             builder: (_) => ManagerReviewScreen(
                //               employee: widget.employee,
                //             ),
                //           ),
                //         );
                //       },
                //       child: const Text(
                //         "Review",
                //         style: TextStyle(
                //           color: Colors.white,
                //           fontSize: 16,
                //         ),
                //       ),
                //     ),
                //   )
                ? Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CustomButton(
                      text: "Review",
                      isLoading: provider.isRegistering,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ManagerReviewScreen(
                              employee: widget.employee,
                            ),
                          ),
                        );
                      },
                    ),
                  )
                : SizedBox.shrink(),
          ],
        ),
      ),
      // floatingActionButton: provider.captureCount >= 5
      //     ? FloatingActionButton.extended(
      //         onPressed: () {
      //           Navigator.push(
      //             context,
      //             MaterialPageRoute(
      //               builder: (_) => ManagerReviewScreen(
      //                 employee: widget.employee,
      //               ),
      //             ),
      //           );
      //         },
      //         label: const Text(
      //           "Review",
      //         ),
      //       )
      //     : null,
    );
  }
}

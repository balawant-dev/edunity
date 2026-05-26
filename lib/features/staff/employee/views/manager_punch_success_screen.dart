import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../../../attendance/provider/attendance_provider.dart';
import '../model/onbehalf_employee_model.dart';

class ManagerPunchSuccessScreen extends StatelessWidget {
  final EmployeeData employee;

  const ManagerPunchSuccessScreen({
    super.key,
    required this.employee,
  });

  @override
  Widget build(
    BuildContext context,
  ) {
    final provider = context.watch<AttendanceProvider>();

    final response = provider.punchResponseModel;

    final date = response?.time != null
        ? DateFormat(
            "dd MMM yyyy, hh:mm a",
          ).format(
            DateTime.fromMillisecondsSinceEpoch(
              response!.time! * 1000,
            ),
          )
        : "-";

    return Scaffold(
      backgroundColor: const Color(0xffF7F8FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const BackButton(),
        centerTitle: true,
        title: const Text(
          "Attendance Result",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const SizedBox(height: 20),

              CircleAvatar(
                radius: 44,
                backgroundColor: Colors.green.withOpacity(.1),
                child: const Icon(
                  Icons.check,
                  size: 46,
                  color: Colors.green,
                ),
              ),

              const SizedBox(height: 22),

              const Text(
                "Attendance Marked\nSuccessfully!",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 12),

              const Text(
                "Attendance has been marked on behalf of employee.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.grey,
                ),
              ),

              const SizedBox(height: 28),

              /// CARD
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 22,
                          child: Text(
                            employee.name!.substring(0, 1),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                employee.name ?? "",
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                "${employee.employeeId}",
                                style: const TextStyle(
                                  color: Colors.grey,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.green.withOpacity(.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        "Marked By Manager",
                        style: TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const Divider(height: 30),
                    _row(
                      "Type",
                      response?.type ?? "-",
                    ),
                    const SizedBox(height: 12),
                    _row(
                      "Date & Time",
                      date,
                    ),
                    const SizedBox(height: 12),
                    _row(
                      "Marked By",
                      "Manager",
                    ),
                  ],
                ),
              ),

              const Spacer(),

              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
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

              // SizedBox(
              //   width: double.infinity,
              //   height: 52,
              //   child: OutlinedButton(
              //     onPressed: () {
              //       Navigator.pop(context);
              //     },
              //     child: const Text(
              //       "View Attendance Records",
              //     ),
              //   ),
              // ),
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

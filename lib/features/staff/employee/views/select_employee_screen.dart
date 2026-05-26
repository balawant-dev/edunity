import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../attendance/provider/attendance_provider.dart';
import '../../../attendance/widgets/pending_flow_widget.dart';
import '../provider/onbehalf_employee_provider.dart';
import '../model/onbehalf_employee_model.dart';
import 'manager_attendance_capture_screen.dart';
import 'manager_employee_detail_screen.dart';

enum EmployeeActionType {
  registration,
  attendance,
}

class SelectEmployeeScreen extends StatefulWidget {
  final EmployeeActionType actionType;

  const SelectEmployeeScreen({
    super.key,
    required this.actionType,
  });

  @override
  State<SelectEmployeeScreen> createState() => _SelectEmployeeScreenState();
}

class _SelectEmployeeScreenState extends State<SelectEmployeeScreen> {
  int? selectedIndex;
  String search = "";

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      context.read<OnBehalfEmployeeProvider>().getActiveEmployees();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF7F8FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Attendance Manager",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
      ),
      body: Consumer<OnBehalfEmployeeProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final employees = provider.employeeModel?.data ?? [];

          final filtered = employees.where((e) {
            return (e.name ?? "").toLowerCase().contains(
                      search.toLowerCase(),
                    ) ||
                (e.employeeId ?? "").toLowerCase().contains(
                      search.toLowerCase(),
                    );
          }).toList();

          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  /// INFO BOX
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: const Color(0xffEEF4FF),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: const [
                        Icon(
                          Icons.info_outline,
                          color: Colors.blue,
                          size: 20,
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            "Mark attendance on behalf of an employee only when they are physically present",
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  /// SEARCH + FILTER
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          onChanged: (v) {
                            setState(() {
                              search = v;
                            });
                          },
                          decoration: InputDecoration(
                            hintText: "Search employee by name or ID",
                            prefixIcon: const Icon(Icons.search),
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      // Container(
                      //   padding: const EdgeInsets.all(12),
                      //   decoration: BoxDecoration(
                      //     color: Colors.white,
                      //     borderRadius: BorderRadius.circular(12),
                      //   ),
                      //   child: const Icon(
                      //     Icons.tune,
                      //   ),
                      // ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "All Employees (${filtered.length})",
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),

                  /// EMPLOYEE LIST
                  Expanded(
                    child: ListView.builder(
                      itemCount: filtered.length,
                      itemBuilder: (context, index) {
                        final employee = filtered[index];

                        return EmployeeCard(
                          employee: employee,
                          selected: selectedIndex == index,
                          onTap: () {
                            setState(() {
                              selectedIndex = index;
                            });
                          },
                        );
                      },
                    ),
                  ),

                  /// BUTTON
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xff125BFF),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      onPressed: selectedIndex == null
                          ? null
                          : () async {
                              final employee = filtered[selectedIndex!];

                              final status =
                                  employee.faceRegistrationStatus ?? "none";

                              /// =========================
                              /// REGISTRATION FLOW
                              /// =========================
                              if (widget.actionType ==
                                  EmployeeActionType.registration) {
                                if (status == "approved") {
                                  showDialog(
                                    context: context,
                                    builder: (_) => _alreadyVerifiedPopup(
                                      context,
                                      employee,
                                    ),
                                  );

                                  return;
                                }

                                if (status == "pending") {
                                  showDialog(
                                    context: context,
                                    builder: (_) => _underReviewPopup(
                                      context,
                                      employee,
                                    ),
                                  );

                                  return;
                                }

                                /// none / rejected
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => ManagerEmployeeDetailScreen(
                                      employee: employee,
                                    ),
                                  ),
                                );

                                return;
                              }

                              /// =========================
                              /// ATTENDANCE FLOW
                              /// =========================

                              /// only approved allowed
                              if (status == "approved") {
                                final attendanceProvider =
                                    context.read<AttendanceProvider>();

                                await attendanceProvider
                                    .getManagerEmployeeAttendance(
                                  employee.uid!,
                                );

                                /// API FAILED
                                if (attendanceProvider.managerAttendanceError !=
                                    null) {
                                  if (context.mounted) {
                                    showDialog(
                                      context: context,
                                      builder: (_) => _shiftLocationPopup(
                                        context,
                                        attendanceProvider
                                                .managerAttendanceError ??
                                            "Employee is not assigned to any shift or location.",
                                      ),
                                    );
                                  }

                                  return;
                                }

                                /// SUCCESS
                                if (context.mounted) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) =>
                                          ManagerAttendanceCaptureScreen(
                                        employee: employee,
                                      ),
                                    ),
                                  );
                                }

                                return;
                              }

                              /// pending
                              if (status == "pending") {
                                showDialog(
                                  context: context,
                                  builder: (_) => _underReviewPopup(
                                    context,
                                    employee,
                                  ),
                                );

                                return;
                              }

                              /// none / rejected
                              showDialog(
                                context: context,
                                builder: (_) => _notRegisteredPopup(
                                  context,
                                  employee,
                                ),
                              );
                            },
                      child: Text(
                        widget.actionType == EmployeeActionType.registration
                            ? "Next: Capture Image"
                            : "Next: Mark Attendance",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _shiftLocationPopup(
    BuildContext context,
    String message,
  ) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
          24,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(
          24,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              radius: 34,
              backgroundColor: Colors.orange.withOpacity(
                .12,
              ),
              child: const Icon(
                Icons.location_off,
                color: Colors.orange,
                size: 38,
              ),
            ),
            const SizedBox(height: 18),
            const Text(
              "Attendance Not Available",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.grey,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                ),
                onPressed: () {
                  Navigator.pop(
                    context,
                  );
                },
                child: const Text(
                  "Okay",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _underReviewPopup(
    BuildContext context,
    EmployeeData employee,
  ) {
    return Dialog(
      insetPadding: const EdgeInsets.all(20),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      child: SizedBox(
        height: 520,
        child: PendingFlowWidget(
          onRefresh: () async {
            Navigator.pop(
              context,
            );

            await context.read<OnBehalfEmployeeProvider>().getActiveEmployees();
          },
        ),
      ),
    );
  }

  Widget _notRegisteredPopup(
    BuildContext context,
    EmployeeData employee,
  ) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              radius: 34,
              backgroundColor: Colors.red.withOpacity(.12),
              child: const Icon(
                Icons.warning_amber_rounded,
                color: Colors.red,
                size: 38,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              "Face Not Registered",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              "${employee.name} does not have an approved face registration.\nAttendance cannot be marked.",
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.grey,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                ),
                onPressed: () {
                  Navigator.pop(
                    context,
                  );
                },
                child: const Text(
                  "Okay",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _alreadyVerifiedPopup(
    BuildContext context,
    EmployeeData employee,
  ) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              radius: 34,
              backgroundColor: Colors.green.withOpacity(.12),
              child: const Icon(
                Icons.verified,
                color: Colors.green,
                size: 40,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              "Already Verified",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              "${employee.name} already has an approved face registration.",
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.grey,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 26),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                ),
                onPressed: () {
                  Navigator.pop(
                    context,
                  );
                },
                child: const Text(
                  "Okay",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class EmployeeCard extends StatelessWidget {
  final EmployeeData employee;
  final bool selected;
  final VoidCallback onTap;

  const EmployeeCard({
    super.key,
    required this.employee,
    required this.selected,
    required this.onTap,
  });

  Color getStatusColor() {
    switch (employee.faceRegistrationStatus) {
      case "approved":
        return Colors.blue;

      case "pending":
        return Colors.orange;

      case "rejected":
        return Colors.red;
      case "none":
        return Colors.red;

      default:
        return Colors.red;
    }
  }

  String getStatusText() {
    switch (employee.faceRegistrationStatus) {
      case "approved":
        return "Verified";

      case "pending":
        return "Under Review";

      case "rejected":
        return "Rejected";

      case "none":
        return "Not Registered";

      default:
        return "Absent";
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: selected ? Colors.blue : Colors.transparent,
            width: 1.5,
          ),
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 24,
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
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    employee.employeeId ?? "",
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
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
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: getStatusColor().withOpacity(.12),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    getStatusText(),
                    style: TextStyle(
                      color: getStatusColor(),
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                if (selected)
                  const CircleAvatar(
                    radius: 12,
                    backgroundColor: Colors.blue,
                    child: Icon(
                      Icons.check,
                      size: 14,
                      color: Colors.white,
                    ),
                  ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

import 'attendance_legend.dart';
import 'package:provider/provider.dart';
import '../provider/attendance_report_provider.dart';

class CalendarViewWidget extends StatefulWidget {
  const CalendarViewWidget({
    super.key,
  });

  @override
  State<CalendarViewWidget> createState() => _CalendarViewWidgetState();
}

class _CalendarViewWidgetState extends State<CalendarViewWidget> {
  int selectedDay = DateTime.now().day;

  // final Map<int, Color> attendanceStatus = {
  //   1: Colors.green,
  //   2: Colors.red,
  //   3: Colors.green,
  //   4: Colors.orange,
  //   5: Colors.green,
  //   6: Colors.green,
  //   7: Colors.red,
  //   8: Colors.orange,
  //   9: Colors.green,
  //   10: Colors.red,
  //   11: Colors.green,
  //   12: Colors.orange,
  //   13: Colors.green,
  //   14: Colors.green,
  //   15: Colors.red,
  // };

  @override
  Widget build(
    BuildContext context,
  ) {
    final provider = context.watch<AttendanceReportProvider>();

    final currentMonth = provider.selectedMonth;

    final logs = provider.reportModel?.logs ?? [];

    final daysInMonth = DateUtils.getDaysInMonth(
      currentMonth.year,
      currentMonth.month,
    );

    final firstDay = DateTime(
          currentMonth.year,
          currentMonth.month,
          1,
        ).weekday %
        7;

    List<Widget> days = [];

    for (int i = 0; i < firstDay; i++) {
      days.add(
        const SizedBox(),
      );
    }

    for (int day = 1; day <= daysInMonth; day++) {
      bool isLate = false;
      final selected = selectedDay == day;
      Color statusColor = Colors.grey;

      final match = logs.where(
        (e) {
          final d = DateTime.parse(
            e.attendanceDate ?? "",
          );

          return d.day == day &&
              d.month == currentMonth.month &&
              d.year == currentMonth.year;
        },
      ).toList();

      if (match.isNotEmpty) {
        final firstIn = match.first.timeline
            ?.where(
              (e) => e.type == "In",
            )
            .toList();

        isLate = firstIn?.isNotEmpty == true &&
            (firstIn!.first.note ?? "").toLowerCase().contains("late");
        switch (match.first.status) {
          case "Present":
            statusColor = isLate ? Colors.orange : Colors.green;
            break;

          case "Absent":
            statusColor = Colors.red;
            break;

          case "Half Day":
            statusColor = Colors.orange;
            break;

          case "Holiday":
            statusColor = Colors.grey;
            break;

          case "Weekly Off":
            statusColor = Colors.purple;
            break;

          default:
            statusColor = Colors.grey;
        }
      }

      days.add(
        GestureDetector(
          onTap: () {
            setState(() {
              selectedDay = day;
            });
          },
          child: AnimatedContainer(
            duration: const Duration(
              milliseconds: 250,
            ),
            decoration: BoxDecoration(
              color: selected
                  ? const Color(
                      0xff0A53FF,
                    )
                  : isLate
                      ? const Color(
                          0xffFFF4E5,
                        )
                      : statusColor.withOpacity(
                          .12,
                        ),
              borderRadius: BorderRadius.circular(
                14,
              ),
              border: Border.all(
                color: selected
                    ? const Color(
                        0xff0A53FF,
                      )
                    : isLate
                        ? Colors.orange
                        : statusColor.withOpacity(
                            .30,
                          ),
                width: isLate ? 1.6 : 1,
              ),
            ),
            alignment: Alignment.center,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "$day",
                  style: TextStyle(
                    color: selected ? Colors.white : statusColor,
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                  ),
                ),
                if (isLate) ...[
                  const SizedBox(
                    height: 1,
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 5,
                      vertical: 1,
                    ),
                    decoration: BoxDecoration(
                      color: selected ? Colors.white24 : Colors.orange.shade100,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      "Late",
                      style: TextStyle(
                        color: selected ? Colors.white : Colors.orange.shade800,
                        fontSize: 8,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 2,
                  ),
                  Container(
                    width: 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color: Colors.orange,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.orange.withOpacity(.4),
                          blurRadius: 6,
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(
        18,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(
          24,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(
              .04,
            ),
            blurRadius: 14,
            offset: const Offset(
              0,
              5,
            ),
          ),
        ],
      ),
      child: Column(
        children: [
          /// MONTH HEADER
          Row(
            children: [
              GestureDetector(
                onTap: () async {
                  provider.selectedMonth = DateTime(
                    currentMonth.year,
                    currentMonth.month - 1,
                  );

                  await provider.getAttendanceReport();
                },
                child: Container(
                  padding: const EdgeInsets.all(
                    8,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(
                      0xffEEF4FF,
                    ),
                    borderRadius: BorderRadius.circular(
                      12,
                    ),
                  ),
                  child: const Icon(
                    Icons.chevron_left_rounded,
                  ),
                ),
              ),
              const Spacer(),
              Text(
                "${_monthName(currentMonth.month)} ${currentMonth.year}",
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const Spacer(),
              GestureDetector(
                onTap: () async {
                  provider.selectedMonth = DateTime(
                    currentMonth.year,
                    currentMonth.month + 1,
                  );

                  await provider.getAttendanceReport();
                },
                child: Container(
                  padding: const EdgeInsets.all(
                    8,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(
                      0xffEEF4FF,
                    ),
                    borderRadius: BorderRadius.circular(
                      12,
                    ),
                  ),
                  child: const Icon(
                    Icons.chevron_right_rounded,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(
            height: 24,
          ),

          /// WEEKDAYS
          Row(
            children: [
              "SUN",
              "MON",
              "TUE",
              "WED",
              "THU",
              "FRI",
              "SAT",
            ].map(
              (e) {
                return Expanded(
                  child: Center(
                    child: Text(
                      e,
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                  ),
                );
              },
            ).toList(),
          ),

          const SizedBox(
            height: 20,
          ),

          /// GRID
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 7,
            crossAxisSpacing: 10,
            mainAxisSpacing: 12,
            childAspectRatio: .72,
            children: days,
          ),

          const SizedBox(
            height: 22,
          ),

          const AttendanceLegend(),
        ],
      ),
    );
  }

  String _monthName(
    int month,
  ) {
    const months = [
      "January",
      "February",
      "March",
      "April",
      "May",
      "June",
      "July",
      "August",
      "September",
      "October",
      "November",
      "December"
    ];

    return months[month - 1];
  }
}

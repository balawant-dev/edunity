import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../provider/attendance_report_provider.dart';
import 'attendance_day_tile.dart';

class ListViewWidget extends StatelessWidget {
  const ListViewWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AttendanceReportProvider>();

    final logs = provider.reportModel?.logs ?? [];
    return Column(
      children: [
        /// FILTER CARD
        // Container(
        //   padding: const EdgeInsets.all(
        //     18,
        //   ),
        //   decoration: BoxDecoration(
        //     color: Colors.white,
        //     borderRadius: BorderRadius.circular(
        //       22,
        //     ),
        //     boxShadow: [
        //       BoxShadow(
        //         color: Colors.black.withOpacity(
        //           .04,
        //         ),
        //         blurRadius: 14,
        //         offset: const Offset(
        //           0,
        //           5,
        //         ),
        //       ),
        //     ],
        //   ),
        //   child: Expanded(
        //     child: _filter(
        //       Icons.calendar_today,
        //       DateFormat(
        //         "MMMM yyyy",
        //       ).format(
        //         provider.selectedMonth,
        //       ),
        //     ),
        //   ),
        //   // child: Row(
        //   //   children: [
        //   //     Expanded(
        //   //       child: _filter(
        //   //         Icons.calendar_today,
        //   //         "May 2024",
        //   //       ),
        //   //     ),
        //   //     // const SizedBox(
        //   //     //   width: 12,
        //   //     // ),
        //   //     // Expanded(
        //   //     //   child: _filter(
        //   //     //     Icons.filter_alt,
        //   //     //     "Filter",
        //   //     //   ),
        //   //     // ),
        //   //   ],
        //   // ),
        // ),
        Container(
          padding: const EdgeInsets.all(
            18,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(
              22,
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
          child: GestureDetector(
            onTap: () async {
              final picked = await showDatePicker(
                context: context,
                initialDate: provider.selectedMonth,
                firstDate: DateTime(2020),
                lastDate: DateTime(2035),
                initialDatePickerMode: DatePickerMode.year,
              );

              if (picked != null) {
                provider.selectedMonth = DateTime(
                  picked.year,
                  picked.month,
                );

                await provider.getAttendanceReport();
              }
            },
            child: _filter(
              Icons.calendar_today,
              DateFormat(
                "MMMM yyyy",
              ).format(
                provider.selectedMonth,
              ),
            ),
          ),
        ),
        const SizedBox(
          height: 18,
        ),

        /// TILES
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: logs.length,
          itemBuilder: (_, index) {
            final log = logs[index];

            String punchIn = "--";

            String punchOut = "--";

            String location = "--";

            if (log.timeline != null && log.timeline!.isNotEmpty) {
              for (var t in log.timeline!) {
                if (t.type == "In") {
                  punchIn = formatUnixIST(
                    t.punchTime,
                  );

                  location = t.location ?? "--";
                }

                if (t.type == "Out") {
                  punchOut = formatUnixIST(
                    t.punchTime,
                  );
                }
              }
            }

            return AttendanceDayTile(
              date: log.attendanceDate != null
                  ? DateFormat(
                      "dd MMM yyyy",
                    ).format(
                      DateTime.parse(
                        log.attendanceDate!,
                      ),
                    )
                  : "--",
              status: log.status ?? "",
              workingHours: "${log.punchesCount ?? 0} Punches",
              punchIn: punchIn,
              punchOut: punchOut,
              location: location,
              late: "--",
              early: "--",
            );
          },
        )
      ],
    );
  }

  Widget _filter(
    IconData icon,
    String text,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 14,
      ),
      decoration: BoxDecoration(
        color: const Color(
          0xffEEF4FF,
        ),
        borderRadius: BorderRadius.circular(
          14,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 18,
            color: const Color(
              0xff0A53FF,
            ),
          ),
          const SizedBox(
            width: 8,
          ),
          Text(
            text,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

String formatUnixIST(
  int? unix,
) {
  if (unix == null || unix == 0) {
    return "--";
  }

  final date = DateTime.fromMillisecondsSinceEpoch(
    unix * 1000,
    isUtc: true,
  ).toLocal();

  return DateFormat(
    'hh:mm a',
  ).format(
    date,
  );
}

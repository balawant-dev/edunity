import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../common/widgets/custom_appbar.dart';
import '../model/attendance_report_model.dart';
import '../provider/punch_summary_provider.dart';
import '../provider/punch_viewmodel.dart';
import '../widgets/list_view_widget.dart';

class PunchesScreen extends StatelessWidget {
  const PunchesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => PunchSummaryProvider()..getPunchReport(),
      child: Scaffold(
        appBar: CustomAppBar(
          title: "Punch Summary",
        ),
        // appBar: AppBar(
        //   backgroundColor: const Color(0xFF1E3A8A),
        //   foregroundColor: Colors.white,
        //   title: const Text("Today's Punches"),
        //   leading: IconButton(
        //     icon: const Icon(Icons.arrow_back),
        //     onPressed: () {},
        //   ),
        //   actions: const [
        //     Padding(
        //       padding: EdgeInsets.only(right: 16),
        //       child: Icon(Icons.calendar_today),
        //     ),
        //   ],
        // ),
        body: Consumer<PunchSummaryProvider>(
          builder: (context, provider, child) {
            final logs = provider.reportModel?.logs ?? [];

            final timeline = logs.isNotEmpty ? logs.first.timeline ?? [] : [];

            final inPunches = timeline
                .where(
                  (e) => e.type == "In",
                )
                .toList();

            final outPunches = timeline
                .where(
                  (e) => e.type == "Out",
                )
                .toList();

            final firstIn = inPunches.isNotEmpty
                ? formatUnixIST(
                    inPunches.first.punchTime,
                  )
                : "--";

            final lastOut = outPunches.isNotEmpty
                ? formatUnixIST(
                    outPunches.last.punchTime,
                  )
                : "--";

            String working = "--";

            if (inPunches.isNotEmpty && outPunches.isNotEmpty) {
              final start = DateTime.fromMillisecondsSinceEpoch(
                (inPunches.first.punchTime ?? 0) * 1000,
              );

              final end = DateTime.fromMillisecondsSinceEpoch(
                (outPunches.last.punchTime ?? 0) * 1000,
              );

              final diff = end.difference(
                start,
              );

              working = "${diff.inHours}h "
                  "${diff.inMinutes % 60}m";
            }
            if (provider.isLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: SafeArea(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Date Header
                    Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 6,
                        horizontal: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          /// LEFT BUTTON
                          IconButton(
                            icon: const Icon(Icons.chevron_left),
                            onPressed: () {
                              provider.previousDate();
                            },
                          ),

                          /// CENTER
                          Expanded(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                /// CALENDAR BUTTON
                                GestureDetector(
                                  onTap: () {
                                    provider.pickDate(context);
                                  },
                                  child: const CircleAvatar(
                                    backgroundColor: Colors.white,
                                    child: Icon(
                                      Icons.calendar_today,
                                      size: 20,
                                    ),
                                  ),
                                ),

                                const SizedBox(height: 6),

                                /// DATE
                                Text(
                                  provider.formattedDate,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),

                                const SizedBox(height: 2),

                                /// DAY
                                Text(
                                  provider.dayName,
                                  style: const TextStyle(
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          /// RIGHT BUTTON
                          IconButton(
                            icon: const Icon(Icons.chevron_right),
                            onPressed: () {
                              provider.nextDate();
                            },
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Punch Timeline
                    const Text(
                      "Punch Timeline",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),

                    timeline.isEmpty
                        ? Container(
                            padding: const EdgeInsets.all(
                              18,
                            ),
                            alignment: Alignment.center,
                            child: const Text(
                              "No punches found",
                            ),
                          )
                        : ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: timeline.length,
                            itemBuilder: (_, index) {
                              return _buildTimelineItem(
                                timeline[index],
                                isLast: index == timeline.length - 1,
                              );
                            },
                          ),

                    const SizedBox(height: 24),

                    // Note
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xffF5F7FF),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          /// ICON
                          Container(
                            height: 32,
                            width: 32,
                            child: const Center(
                              child: Icon(
                                Icons.info_outline,
                                color: Color(0xff2F5BFF),
                                size: 22,
                              ),
                            ),
                          ),

                          const SizedBox(width: 4),

                          /// TEXT
                          const Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Note",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xff1D2A7A),
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  "All times are in local device time.",
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Punch Summary
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.shade200),
                      ),
                      child: Column(
                        children: [
                          const Padding(
                            padding: EdgeInsets.all(14),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Punch Summary",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                          _buildSummaryRow(
                            "Total Punches",
                            timeline.length.toString(),
                          ),
                          const Divider(height: 1),
                          _buildSummaryRow(
                            "First Punch In",
                            firstIn,
                          ),
                          const Divider(height: 1),
                          _buildSummaryRow(
                            "Last Punch Out",
                            lastOut,
                          ),
                          const Divider(height: 1),
                          _buildSummaryRow(
                            "Total Working Hours",
                            working,
                            isHighlight: true,
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Disclaimer
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.orange[50],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Icons.info_outline, color: Colors.orange),
                          const SizedBox(width: 8),
                          const Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Disclaimer",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.orange,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  "Please ensure all punches are accurate.\nContact admin in case of any issues.",
                                  style: TextStyle(fontSize: 14),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildTimelineItem(Timeline punch,
      {bool isFirst = false, bool isLast = false}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: punch.type == "In"
                    ? Colors.green
                    : punch.type == "Out"
                        ? Colors.red
                        : Colors.orange,
                shape: BoxShape.circle,
              ),
              child: Icon(
                (punch.type ?? "").contains(
                  "In",
                )
                    ? Icons.login
                    : Icons.logout,
                color: Colors.white,
                size: 24,
              ),
            ),
            if (!isLast)
              Container(
                width: 2,
                height: 60,
                color: Colors.grey.shade300,
              ),
          ],
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    punch.type ?? "--",
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Spacer(),
                  if ((punch.note ?? "").isNotEmpty)
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.green[100],
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        // "On Time",
                        punch.note!,
                        style: TextStyle(
                          color: Colors.green,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.access_time, size: 16, color: Colors.grey),
                  const SizedBox(width: 6),
                  Text(
                    formatUnixIST(
                      punch.punchTime,
                    ),
                  ),
                  const SizedBox(width: 16),
                  const Icon(Icons.location_on, size: 16, color: Colors.grey),
                  const SizedBox(width: 6),
                  Text(
                    punch.location ?? "--",
                  ),
                ],
              ),
              if ((punch.note ?? "").isNotEmpty && punch.note != "-")
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Row(
                    children: [
                      const Icon(Icons.note, size: 16, color: Colors.grey),
                      const SizedBox(width: 6),
                      Text(
                        "Note: ${punch.note}",
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryRow(String label, String value,
      {bool isHighlight = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 15),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 15,
              fontWeight: isHighlight ? FontWeight.bold : FontWeight.w500,
              color: isHighlight ? Colors.blue : Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}

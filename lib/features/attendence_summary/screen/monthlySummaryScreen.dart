import 'package:flutter/material.dart';

class MonthlySummaryScreen extends StatefulWidget {
  const MonthlySummaryScreen({super.key});

  @override
  State<MonthlySummaryScreen> createState() => _MonthlySummaryScreenState();
}

class _MonthlySummaryScreenState extends State<MonthlySummaryScreen> {
  DateTime currentMonth = DateTime(2024, 5);

  int selectedDay = 15;

  final Map<int, Color> attendanceStatus = {
    1: Colors.green,
    2: Colors.red,
    3: Colors.green,
    4: Colors.orange,
    5: Colors.green,
    6: Colors.orange,
    7: Colors.green,
    8: Colors.red,
    9: Colors.green,
    10: Colors.orange,
    11: Colors.green,
    12: Colors.red,
    13: Colors.green,
    14: Colors.orange,
    15: Colors.green,
    16: Colors.green,
    17: Colors.orange,
    18: Colors.red,
    19: Colors.green,
    20: Colors.orange,
    21: Colors.green,
    22: Colors.red,
    23: Colors.green,
    24: Colors.orange,
    25: Colors.green,
    26: Colors.red,
    27: Colors.green,
    28: Colors.orange,
    29: Colors.green,
    30: Colors.red,
    31: Colors.green,
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF5F7FB),
      body: SafeArea(
        child: Column(
          children: [
            /// TOP HEADER
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
              decoration: const BoxDecoration(
                color: Color(0xff0038B8),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(28),
                  bottomRight: Radius.circular(28),
                ),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                          child: const Icon(Icons.arrow_back, color: Colors.white)),
                      const Spacer(),
                      const Text(
                        "Monthly Summary",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const Spacer(),
                      const Icon(Icons.calendar_month,
                          color: Colors.white),
                    ],
                  ),
                  const SizedBox(height: 20),

                  /// PROFILE CARD
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 35,
                          backgroundImage: NetworkImage(
                            "https://i.pravatar.cc/300",
                          ),
                        ),
                        const SizedBox(width: 14),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Ramesh Kumar Singh",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                "Student ID: 250900001",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.black54,
                                ),
                              ),
                              SizedBox(height: 6),
                              Row(
                                children: [
                                  Icon(Icons.school,
                                      size: 18, color: Colors.grey),
                                  SizedBox(width: 5),
                                  Text(
                                    "B.Ed (2 Year Programme)",
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.black54,
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    /// TAB
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              children: [
                                Icon(Icons.list, color: Colors.grey.shade600),
                                const SizedBox(height: 5),
                                Text(
                                  "List View",
                                  style: TextStyle(
                                    color: Colors.grey.shade700,
                                  ),
                                )
                              ],
                            ),
                          ),
                          Container(
                            height: 40,
                            width: 1,
                            color: Colors.grey.shade300,
                          ),
                          const Expanded(
                            child: Column(
                              children: [
                                Icon(Icons.calendar_month,
                                    color: Color(0xff0A53FF)),
                                SizedBox(height: 5),
                                Text(
                                  "Calendar View",
                                  style: TextStyle(
                                    color: Color(0xff0A53FF),
                                    fontWeight: FontWeight.w600,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 18),

                    /// CALENDAR
                    buildCalendar(),

                    const SizedBox(height: 20),

                    /// SUMMARY TITLE
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Attendance Summary",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    buildSummaryCard(
                      number: "1",
                      title: "Monthly Summary",
                      subtitle: "May 2024",
                      stats: const [
                        ["Working Days", "20"],
                        ["Present Days", "16"],
                        ["Absent Days", "2"],
                        ["Attendance %", "80%"],
                      ],
                      percent: "80%",
                      color: Colors.green,
                      icon: Icons.pie_chart,
                    ),

                    const SizedBox(height: 14),

                    buildSummaryCard(
                      number: "2",
                      title: "Academic Summary",
                      subtitle: "Jan 2024 - May 2024",
                      stats: const [
                        ["Total Working Days", "100"],
                        ["Present Days", "82"],
                        ["Absent Days", "8"],
                        ["Attendance %", "82%"],
                      ],
                      percent: "82%",
                      color: Colors.green,
                      icon: Icons.pie_chart,
                    ),

                    const SizedBox(height: 14),

                    buildSummaryCard(
                      number: "3",
                      title: "Late Coming Summary",
                      subtitle: "May 2024",
                      stats: const [
                        ["Total Late Days", "5"],
                        ["Total Late Count", "7"],
                        ["Average Late", "15m"],
                      ],
                      percent: "",
                      color: Colors.orange,
                      icon: Icons.access_time,
                    ),

                    const SizedBox(height: 14),

                    buildSummaryCard(
                      number: "4",
                      title: "Early Going Summary",
                      subtitle: "May 2024",
                      stats: const [
                        ["Total Early Days", "3"],
                        ["Total Early Count", "4"],
                        ["Average Early", "20m"],
                      ],
                      percent: "",
                      color: Colors.red,
                      icon: Icons.logout,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),

      /// BOTTOM NAV

    );
  }

  Widget buildCalendar() {
    List<String> weekDays = [
      "SUN",
      "MON",
      "TUE",
      "WED",
      "THU",
      "FRI",
      "SAT"
    ];

    int daysInMonth =
    DateUtils.getDaysInMonth(currentMonth.year, currentMonth.month);

    /// 0 = sunday
    int firstDayOfMonth =
        DateTime(currentMonth.year, currentMonth.month, 1).weekday % 7;

    List<Widget> calendarWidgets = [];

    /// EMPTY BOXES
    for (int i = 0; i < firstDayOfMonth; i++) {
      calendarWidgets.add(const SizedBox());
    }

    /// DAYS
    for (int day = 1; day <= daysInMonth; day++) {
      bool isSelected = selectedDay == day;

      calendarWidgets.add(
        GestureDetector(
          onTap: () {
            setState(() {
              selectedDay = day;
            });
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 42,
                width: 42,
                decoration: BoxDecoration(
                  color: isSelected
                      ? const Color(0xff0A53FF)
                      : Colors.transparent,
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Text(
                  "$day",
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: isSelected
                        ? Colors.white
                        : Colors.black,
                  ),
                ),
              ),
              const SizedBox(height: 4),
              Container(
                height: 8,
                width: 8,
                decoration: BoxDecoration(
                  color: attendanceStatus[day] ?? Colors.grey,
                  shape: BoxShape.circle,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        children: [

          /// HEADER
          Row(
            children: [

              /// PREVIOUS MONTH
              GestureDetector(
                onTap: () {
                  setState(() {
                    currentMonth = DateTime(
                      currentMonth.year,
                      currentMonth.month - 1,
                    );
                  });
                },
                child: const Icon(Icons.chevron_left),
              ),

              const Spacer(),

              Text(
                "${getMonthName(currentMonth.month)} ${currentMonth.year}",
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),

              const Spacer(),

              /// NEXT MONTH
              GestureDetector(
                onTap: () {
                  setState(() {
                    currentMonth = DateTime(
                      currentMonth.year,
                      currentMonth.month + 1,
                    );
                  });
                },
                child: const Icon(Icons.chevron_right),
              ),
            ],
          ),

          const SizedBox(height: 20),

          /// WEEK DAYS
          Row(
            children: weekDays.map((e) {
              return Expanded(
                child: Center(
                  child: Text(
                    e,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.grey.shade600,
                      fontSize: 12,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),

          const SizedBox(height: 15),

          /// CALENDAR GRID
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 7,
            mainAxisSpacing: 12,
            crossAxisSpacing: 8,
            childAspectRatio: 0.7,
            children: calendarWidgets,
          ),

          const SizedBox(height: 18),

          /// LEGEND
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              buildLegend(Colors.green, "Full Day"),
              buildLegend(Colors.orange, "Half Day"),
              buildLegend(Colors.red, "Absent"),
              buildLegend(Colors.grey, "Holiday"),
            ],
          ),
        ],
      ),
    );
  }
  String getMonthName(int month) {
    List<String> months = [
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
  Widget buildLegend(Color color, String text) {
    return Row(
      children: [
        Container(
          height: 10,
          width: 10,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 6),
        Text(
          text,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 12
          ),
        ),
      ],
    );
  }

  Widget buildSummaryCard({
    required String number,
    required String title,
    required String subtitle,
    required List<List<String>> stats,
    required String percent,
    required Color color,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 14,
                      backgroundColor: const Color(0xff0A53FF),
                      child: Text(
                        number,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 38, top: 4),
                  child: Text(
                    subtitle,
                    style: TextStyle(
                      color: Colors.grey.shade600,
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                Wrap(
                  spacing: 24,
                  runSpacing: 14,
                  children: stats.map((e) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          e[0],
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey.shade600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          e[1],
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          CircleAvatar(
            radius: 30,
            backgroundColor: color.withOpacity(.12),
            child: Icon(
              icon,
              color: color,
              size: 30,
            ),
          ),
        ],
      ),
    );
  }
}


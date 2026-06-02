import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AttendanceDayTile extends StatefulWidget {
  final String date;
  final String status;
  final String workingHours;
  final String punchIn;
  final String punchOut;
  final String location;
  final String late;
  final String early;

  const AttendanceDayTile({
    super.key,
    required this.date,
    required this.status,
    required this.workingHours,
    required this.punchIn,
    required this.punchOut,
    required this.location,
    required this.late,
    required this.early,
  });

  @override
  State<AttendanceDayTile> createState() => _AttendanceDayTileState();
}

class _AttendanceDayTileState extends State<AttendanceDayTile> {
  bool expanded = false;

  Color get statusColor {
    switch (widget.status) {
      case "Present":
        return Colors.green;
      case "Half Day":
        return Colors.orange;
      case "Absent":
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(
        milliseconds: 280,
      ),
      margin: const EdgeInsets.only(
        bottom: 14,
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
      child: Column(
        children: [
          /// HEADER
          InkWell(
            borderRadius: BorderRadius.circular(
              22,
            ),
            onTap: () {
              setState(() {
                expanded = !expanded;
              });
            },
            child: Padding(
              padding: const EdgeInsets.all(
                18,
              ),
              child: Row(
                children: [
                  Container(
                    height: 52,
                    width: 52,
                    decoration: BoxDecoration(
                      color: statusColor.withOpacity(
                        .12,
                      ),
                      borderRadius: BorderRadius.circular(
                        16,
                      ),
                    ),
                    child: Icon(
                      Icons.calendar_month_rounded,
                      color: statusColor,
                    ),
                  ),
                  const SizedBox(
                    width: 14,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.date,
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 15,
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Text(
                          "Working ${widget.workingHours}",
                          style: TextStyle(
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: statusColor.withOpacity(
                        .12,
                      ),
                      borderRadius: BorderRadius.circular(
                        12,
                      ),
                    ),
                    child: Text(
                      widget.status,
                      style: TextStyle(
                        color: statusColor,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  AnimatedRotation(
                    duration: const Duration(
                      milliseconds: 250,
                    ),
                    turns: expanded ? .5 : 0,
                    child: const Icon(
                      Icons.keyboard_arrow_down_rounded,
                    ),
                  ),
                ],
              ),
            ),
          ),

          /// BODY
          AnimatedCrossFade(
            duration: const Duration(
              milliseconds: 280,
            ),
            crossFadeState:
                expanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
            firstChild: const SizedBox(),
            secondChild: Padding(
              padding: const EdgeInsets.only(
                left: 18,
                right: 18,
                bottom: 18,
              ),
              child: Column(
                children: [
                  const Divider(),
                  _row(
                    Icons.login_rounded,
                    "Punch In",
                    widget.punchIn,
                  ),
                  _row(
                    Icons.logout_rounded,
                    "Punch Out",
                    widget.punchOut,
                  ),
                  _row(
                    Icons.location_on,
                    "Location",
                    widget.location,
                  ),
                  _row(
                    Icons.access_time,
                    "Late",
                    widget.late,
                  ),
                  _row(
                    Icons.timer_off,
                    "Early",
                    widget.early,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _row(
    IconData icon,
    String title,
    String value,
  ) {
    return Padding(
      padding: const EdgeInsets.only(
        bottom: 14,
      ),
      child: Row(
        children: [
          Icon(
            icon,
            size: 18,
            color: Colors.grey.shade700,
          ),
          const SizedBox(
            width: 10,
          ),
          Text(
            title,
            style: TextStyle(
              color: Colors.grey.shade700,
            ),
          ),
          const Spacer(),
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

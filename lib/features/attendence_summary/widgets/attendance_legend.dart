import 'package:flutter/material.dart';

class AttendanceLegend extends StatelessWidget {
  const AttendanceLegend({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: const [
        _LegendItem(
          color: Colors.green,
          text: "Present",
        ),
        _LegendItem(
          color: Colors.orange,
          text: "Late",
        ),
        // _LegendItem(
        //   color: Colors.orange,
        //   text: "Half Day",
        // ),
        _LegendItem(
          color: Colors.red,
          text: "Absent",
        ),
        _LegendItem(
          color: Colors.grey,
          text: "Holiday",
        ),
      ],
    );
  }
}

class _LegendItem extends StatelessWidget {
  final Color color;
  final String text;

  const _LegendItem({
    required this.color,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          height: 12,
          width: 12,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(
              4,
            ),
          ),
        ),
        const SizedBox(width: 6),
        Text(
          text,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';

class LocationStatusCard extends StatelessWidget {
  final bool isInsideRadius;
  final double distanceInMeter;

  const LocationStatusCard({
    super.key,
    required this.isInsideRadius,
    required this.distanceInMeter,
  });

  @override
  Widget build(BuildContext context) {
    final Color bgColor =
    isInsideRadius ? Colors.green.shade50 : Colors.red.shade50;

    final Color mainColor =
    isInsideRadius ? Colors.green : Colors.red;

    final IconData icon =
    isInsideRadius ? Icons.location_on : Icons.location_off;

    final String title =
    isInsideRadius ? "Inside Attendance Area" : "Outside Attendance Area";

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: mainColor),
      ),
      child: Row(
        children: [
          Icon(icon, color: mainColor),
          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: mainColor,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "Distance : ${distanceInMeter.toStringAsFixed(2)} Meter",
                  style: const TextStyle(fontSize: 13),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
import 'package:flutter/material.dart';

import '../model/home_model.dart';
class AttendanceCard extends StatelessWidget {

  final AttendanceCardModel model;

  const AttendanceCard({
    super.key,
    required this.model,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        height: 125,
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.only(right: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
        ),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Row(
              children: [

                CircleAvatar(
                  radius: 12,
                  backgroundColor: Colors.green.withOpacity(0.08),
                  child: Icon(
                    model.icon,
                    size: 16,
                    color: model.color,
                  ),
                ),

                const SizedBox(width: 4),

                Text(
                  model.title,
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10),

            Text(
              model.value,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: model.color,
              ),
            ),

            const SizedBox(height: 6),

            Text(
              model.subtitle,
              style: const TextStyle(fontSize: 11),
            ),

            const SizedBox(height: 8),

            if(model.bottomText.isNotEmpty)
              Text(
                model.bottomText,
                style: TextStyle(
                  fontSize: 10,
                  color: Colors.grey.shade500,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';

class StepIndicatorWidget extends StatelessWidget {
  final int step;

  const StepIndicatorWidget({
    super.key,
    required this.step,
  });

  Widget buildStep(
    int number,
    String title,
  ) {
    final active = step == number;
    final completed = step > number;

    return Expanded(
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 2,
                  color: number == 1
                      ? Colors.transparent
                      : completed
                          ? Colors.blue
                          : Colors.grey.shade300,
                ),
              ),
              CircleAvatar(
                radius: 14,
                backgroundColor: active
                    ? Colors.blue
                    : completed
                        ? Colors.blue
                        : Colors.grey.shade300,
                child: completed
                    ? const Icon(
                        Icons.check,
                        size: 14,
                        color: Colors.white,
                      )
                    : Text(
                        "$number",
                        style: TextStyle(
                          color: active ? Colors.white : Colors.black,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
              ),
              Expanded(
                child: Container(
                  height: 2,
                  color: completed ? Colors.blue : Colors.grey.shade300,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        buildStep(
          1,
          "Select\nEmployee",
        ),
        buildStep(
          2,
          "Capture\nFace",
        ),
        buildStep(
          3,
          "Review\n",
        ),
        buildStep(
          4,
          "Complete\n",
        ),
      ],
    );
  }
}

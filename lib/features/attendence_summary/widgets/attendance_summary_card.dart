import 'package:flutter/material.dart';

class AttendanceSummaryCard extends StatelessWidget {
  final String number;
  final String title;
  final String subtitle;
  final List<List<String>> stats;
  final String percent;
  final Color color;
  final IconData icon;

  const AttendanceSummaryCard({
    super.key,
    required this.number,
    required this.title,
    required this.subtitle,
    required this.stats,
    required this.percent,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
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
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// LEFT
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    /// NUMBER TAG
                    Container(
                      height: 30,
                      width: 30,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: const Color(
                          0xff0A53FF,
                        ),
                        borderRadius: BorderRadius.circular(
                          10,
                        ),
                      ),
                      child: Text(
                        number,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 12,
                        ),
                      ),
                    ),

                    const SizedBox(
                      width: 12,
                    ),

                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(
                            height: 3,
                          ),
                          Text(
                            subtitle,
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 22,
                ),
                Wrap(
                  spacing: 26,
                  runSpacing: 16,
                  children: stats.map(
                    (e) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            e[0],
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Text(
                            e[1],
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      );
                    },
                  ).toList(),
                ),
              ],
            ),
          ),

          const SizedBox(
            width: 12,
          ),

          /// RIGHT ICON BOX
          Container(
            height: 68,
            width: 68,
            decoration: BoxDecoration(
              color: color.withOpacity(
                .12,
              ),
              borderRadius: BorderRadius.circular(
                20,
              ),
            ),
            child: Icon(
              icon,
              size: 34,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';

class AttendanceViewToggle extends StatelessWidget {
  final bool isCalendar;
  final Function(bool) onChanged;

  const AttendanceViewToggle({
    super.key,
    required this.isCalendar,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 58,
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.04),
            blurRadius: 14,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          _tab(
            icon: Icons.list_alt_rounded,
            text: "List View",
            selected: !isCalendar,
            onTap: () => onChanged(false),
          ),
          _tab(
            icon: Icons.calendar_month_rounded,
            text: "Calendar View",
            selected: isCalendar,
            onTap: () => onChanged(true),
          ),
        ],
      ),
    );
  }

  Widget _tab({
    required IconData icon,
    required String text,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(
            milliseconds: 280,
          ),
          curve: Curves.easeOut,
          decoration: BoxDecoration(
            color: selected ? const Color(0xff0A53FF) : Colors.transparent,
            borderRadius: BorderRadius.circular(
              14,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 20,
                color: selected ? Colors.white : Colors.grey.shade600,
              ),
              const SizedBox(width: 8),
              Text(
                text,
                style: TextStyle(
                  color: selected ? Colors.white : Colors.grey.shade700,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

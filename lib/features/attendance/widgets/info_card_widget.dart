import 'package:flutter/material.dart';

class InfoCardWidget extends StatelessWidget {

  final String text;

  const InfoCardWidget({
    super.key,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {

    return Container(

      width: double.infinity,

      padding: const EdgeInsets.all(16),

      decoration: BoxDecoration(

        color: Colors.grey.shade100,

        borderRadius:
        BorderRadius.circular(18),
      ),

      child: Row(

        children: [

          const Icon(
            Icons.info_outline,
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Text(text),
          ),
        ],
      ),
    );
  }
}
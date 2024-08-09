import 'package:flutter/material.dart';


class AdditionalInfo extends StatelessWidget {

  final IconData icon ;
  final String label;
  final String value;
  const AdditionalInfo({
    super.key,
    required this.icon,
    required this.label,
    required this.value

  });

  @override
  Widget build(BuildContext context) {
    return Column(
        children: [
          Icon(
            icon,
            size: 38,
          ),
          const SizedBox(
            height: 8,
          ),
          Text(
            (label),
            style: const TextStyle(
              fontSize: 16,

            ),
          ),
          const SizedBox(
            height: 8,
          ),
          Text((value),style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),)
        ],
      );
  }
}

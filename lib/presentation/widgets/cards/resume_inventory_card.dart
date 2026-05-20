import 'package:flutter/material.dart';

class ResumeInventoryCard extends StatelessWidget {
  const ResumeInventoryCard({
    super.key,
    required this.title,
    required this.number,
    this.hasShadow = false,
    this.fontSize = 16,
    required this.color,
  });

  final String title;
  final int number;
  final bool hasShadow;
  final double fontSize;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          if (hasShadow)
            BoxShadow(
              color: color,
              offset: Offset.fromDirection(-0, -4),
              blurStyle: BlurStyle.normal,
            ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: fontSize),
            ),
            Text(
              '$number',
              style: TextStyle(
                color: color,
                fontSize: 30,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

class QuickActionsCard extends StatelessWidget {
  const QuickActionsCard({
    super.key,
    required this.title,
    required this.icon,
    this.isSelected = false,
  });

  final String title;
  final IconData icon;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: isSelected ? Colors.blueAccent : Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      width: double.infinity,
      height: 110,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        child: Column(
          spacing: 4,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isSelected ? Colors.white : Colors.blueAccent,
              weight: 5,
              size: 32,
            ),
            Center(
              child: Text(
                maxLines: 2,
                textAlign: TextAlign.center,
                title,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

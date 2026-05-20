import 'package:flutter/material.dart';

class CardHeaderForm extends StatelessWidget {
  const CardHeaderForm({
    super.key,
    required this.title,
    this.subTitle,
    required this.icon,
  });

  final String title;
  final String? subTitle;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 8,
      children: [
        Container(
          height: 60,
          width: 60,
          decoration: BoxDecoration(
            color: Color(0xff3f49e0),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Center(child: Icon(icon, size: 30, color: Colors.white)),
        ),
        Text(
          title,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 28),
        ),
        if (subTitle != null)
          Text(
            subTitle!,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
          ),
      ],
    );
  }
}

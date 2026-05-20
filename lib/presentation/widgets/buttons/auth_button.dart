import 'package:flutter/material.dart';

class AuthButton extends StatelessWidget {
  const AuthButton({
    super.key,
    required this.onPressed,
    required this.isLoading,
    required this.text,
  });

  final void Function() onPressed;
  final bool isLoading;
  final String text;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: TextButton(
        onPressed: onPressed,
        style: ButtonStyle(
          shape: WidgetStatePropertyAll(BeveledRectangleBorder()),
          backgroundColor: WidgetStateProperty.resolveWith<Color>((states) {
            if (states.contains(WidgetState.pressed)) {
              return Color.fromARGB(255, 32, 44, 221);
            }
            return Color(0xff3f49e0);
          }),
        ),
        child: !isLoading
            ? Text(
                text,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              )
            : CircularProgressIndicator(color: Colors.white),
      ),
    );
  }
}

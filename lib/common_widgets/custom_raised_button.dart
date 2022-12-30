import 'package:flutter/material.dart';

class CustomRaisedButton extends StatelessWidget {
  const CustomRaisedButton(
      {super.key,
      required this.child,
      required this.color,
      this.borderRadius = 2.0, // Default value for all custom buttons
      this.height = 50.0,
      required this.onPressed});

  final Widget child;
  final Color color;
  final double borderRadius;
  final double height;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    // The Buttons can have children
    return SizedBox( // Useful for directly adding height to widgets
      height: height,
      child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
              backgroundColor: color,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(borderRadius)))),
          child: child,
          ),
    );
  }
}



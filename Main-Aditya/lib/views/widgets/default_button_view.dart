import 'package:flutter/material.dart';

class DefaultButton extends StatelessWidget {
  final VoidCallback onPressed;
  final Widget child;
  final Color color;
  final Color textColor;
  const DefaultButton({
    Key? key,
    required this.onPressed,
    required this.child,
    required this.color,
    required this.textColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.all<Color>(color),
        textStyle: WidgetStateProperty.all<TextStyle>(
          TextStyle(
            color: textColor,
          ),
        ),
      ),
      onPressed: onPressed,
      child: child,
    );
  }
}
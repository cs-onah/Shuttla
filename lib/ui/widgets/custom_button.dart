import 'package:flutter/material.dart';

class BoxButton extends StatelessWidget {
  final String? text;
  final Color? backgroundColor;
  final Color? textColor;
  final double? textSize;
  final VoidCallback? onPressed;
  const BoxButton({
    this.text,
    this.backgroundColor,
    this.textColor,
    this.textSize,
    this.onPressed,
  });

  const BoxButton.black({this.text, this.textSize, this.onPressed})
      : backgroundColor = Colors.black,
        textColor = Colors.white;
  const BoxButton.purple({this.text, this.textSize, this.onPressed})
      : backgroundColor = const Color(0xff7B439F),
        textColor = Colors.white;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
        backgroundColor: backgroundColor ?? Colors.black,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
      ),
      onPressed: onPressed,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          text ?? "",
          style: TextStyle(
            color: textColor ?? Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: textSize ?? 14,
          ),
        ),
      ),
    );
  }
}

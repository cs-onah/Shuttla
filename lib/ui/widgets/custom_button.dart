import 'package:flutter/material.dart';

class BoxButton extends StatefulWidget {
  final String? text;
  final Color? backgroundColor;
  final Color? textColor;
  final double? textSize;
  final VoidCallback? onPressed;
  final double borderRadius;
  final Function(ValueNotifier<bool>)? onPressedWithNotifier;
  const BoxButton({
    this.text,
    this.backgroundColor,
    this.textColor,
    this.textSize,
    this.onPressed,
    this.borderRadius = 12,
    this.onPressedWithNotifier,
  });

  const BoxButton.black(
      {this.text, this.textSize, this.onPressed, this.onPressedWithNotifier})
      : backgroundColor = Colors.black,
        textColor = Colors.white,
        borderRadius = 12;
  const BoxButton.rounded(
      {this.text,
      this.textSize,
      this.onPressed,
      this.backgroundColor,
      this.textColor,
      this.onPressedWithNotifier})
      : borderRadius = 100;
  const BoxButton.purple(
      {this.text, this.textSize, this.onPressed, this.onPressedWithNotifier})
      : backgroundColor = const Color(0xff7B439F),
        textColor = Colors.white,
        borderRadius = 12;

  @override
  State<BoxButton> createState() => _BoxButtonState();
}

class _BoxButtonState extends State<BoxButton> {
  late ValueNotifier<bool> isLoading;
  @override
  void initState() {
    super.initState();
    isLoading = ValueNotifier(false);
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: isLoading,
      builder: (context, value, _) {
        if (value) {
          return buttonBody(
            SizedBox(
              height: widget.textSize ?? 14,
              width: widget.textSize ?? 14,
              child: CircularProgressIndicator(
                strokeWidth: 4,
                color: Colors.white,
              ),
            ),
          );
        } else {
          return buttonBody(
            Text(
              widget.text ?? "",
              style: TextStyle(
                color: widget.textColor ?? Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: widget.textSize ?? 14,
              ),
            ),
            notifierCallback: () {
              if (widget.onPressedWithNotifier != null)
                widget.onPressedWithNotifier!(isLoading);
            },
          );
        }
      },
    );
  }

  TextButton buttonBody(Widget child, {VoidCallback? notifierCallback}) {
    return TextButton(
      style: TextButton.styleFrom(
        backgroundColor: widget.backgroundColor ?? Colors.black,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(widget.borderRadius)),
        ),
      ),
      onPressed: () {
        if (notifierCallback != null) notifierCallback();
        if (widget.onPressed != null) widget.onPressed!();
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: child,
      ),
    );
  }
}

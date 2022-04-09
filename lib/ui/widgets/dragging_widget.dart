import 'package:flutter/material.dart';

class DragHandle extends StatelessWidget {
  final double? width;
  const DragHandle({
    Key? key, this.width,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          height: 8,
          width: width ?? 60,
          decoration: BoxDecoration(
              borderRadius:
              BorderRadius.all(Radius.circular(20)),
              color: Colors.grey[300]),
        ),
      ],
    );
  }
}

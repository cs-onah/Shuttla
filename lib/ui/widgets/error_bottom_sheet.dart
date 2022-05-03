import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:shuttla/ui/widgets/custom_button.dart';

class ErrorBottomSheet extends StatelessWidget {
  const ErrorBottomSheet({this.title, this.description});
  final String? title, description;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if(title != null) Text(
                '$title',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                ),
            ),
            if(title != null) const Gap(10),
            Icon(Icons.info_outline, color: Colors.red, size: 80),
            const Gap(20),
            Text('$description', style: TextStyle(fontSize: 14)),
            const Gap(20),
            SizedBox(
              width: 100,
              child: BoxButton.purple(
                text: "Dismiss",
                onPressed: ()=> Navigator.pop(context),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

class StationDetailTile extends StatelessWidget {
  final IconData? iconData;
  final Color? iconBgColor;
  final String text;
  const StationDetailTile({
    Key? key,
    this.iconData,
    this.text = "",
    this.iconBgColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 15),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          iconData == null
              ? SizedBox(width: 30)
              : Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(60)),
                color: iconBgColor ?? Colors.black45,
              ),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Icon(iconData, size: 25, color: Colors.white),
              )),
          SizedBox(width: 25),
          Expanded(
            child: Text(
              '$text',
              style: TextStyle(
                fontSize: 16,
                // fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';

class BusstopTile extends StatelessWidget {
  final bool isSelected;
  const BusstopTile({
    Key? key, this.isSelected = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      // margin: EdgeInsets.only(bottom: 10),
      margin: EdgeInsets.only(top: 20),
      // decoration: BoxDecoration(
      //   borderRadius: BorderRadius.all(Radius.circular(12)),
      //   color: Colors.grey[200],
      // ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // if(isSelected)
              //   Icon(Icons.check_circle, color: Colors.green, size: 30,)
              // else
              //   Icon(Icons.circle_outlined, color: Colors.green, size: 30,),
              Icon(Icons.location_on_outlined, size: 30, color: Colors.grey[600]),
              SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'SEET Head Station',
                      style: TextStyle(
                        fontSize: 14,
                        // fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      '40m away from you',
                      style: TextStyle(
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          Divider(height: 0),
        ],
      ),
    );
  }
}

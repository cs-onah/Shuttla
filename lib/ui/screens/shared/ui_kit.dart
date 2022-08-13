import 'package:flutter/material.dart';

mixin UiKit{

  showToastMessage(BuildContext context, String message, {Duration? duration, bool success = false}){
    final snackBar = SnackBar(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      backgroundColor: success ? Colors.green : Colors.red,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5))),
      elevation: 5,
      duration: duration ?? Duration(seconds: 5),
      dismissDirection: DismissDirection.endToStart,
      content: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          success ? Icon(Icons.check_circle, color: Colors.white) :
          Icon(Icons.error_outline, color: Colors.white),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              message,
              style: TextStyle(fontSize: 14, color: Colors.white),
            ),
          ),
        ],
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  showBottomSheetMessage(BuildContext context, String message){

  }

}
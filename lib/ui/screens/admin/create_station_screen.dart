import 'package:flutter/material.dart';
import 'package:shuttla/ui/widgets/custom_textfield.dart';

class CreateStationScreen extends StatelessWidget {
  const CreateStationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Create Station"),
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          Container(
            height: 150,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(16)),
              color: Colors.grey[200]
            ),
            child: Column(
              children: [
                Icon(Icons.add_location_alt_outlined, size: 60),
                SizedBox(height: 20),
                Text("Pick Location"),
              ],
            ),
          ),
          SizedBox(height: 20),
          BoxTextField(hintText: "Station Name"),
          SizedBox(height: 12),
          BoxTextField(hintText: "Station Description"),
          SizedBox(height: 12),
          BoxTextField(hintText: "Station Name"),
        ],
      ),
    );
  }
}

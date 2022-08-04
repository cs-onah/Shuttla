import 'package:flutter/material.dart';
import 'package:shuttla/core/blocs/driver_home_bloc.dart';
import 'package:shuttla/core/blocs/passenger_home_bloc.dart';
import 'package:shuttla/core/data_models/station.dart';
import 'package:shuttla/ui/size_config/size_config.dart';
import 'package:shuttla/ui/widgets/custom_button.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DriverCompleteFragment extends StatelessWidget {
  DriverCompleteFragment({Key? key}) : super(key: key);

  ValueNotifier<bool> pickedAll = ValueNotifier(false);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Card(
            elevation: 5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(12)),
            ),
            child: Container(
            padding: EdgeInsets.all(SizeConfig.widthOf(7)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Icon(Icons.departure_board), SizedBox(width: 10),
                      Text(
                        'SEET HEAD',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Divider(height: 0),
                  SizedBox(height: 10),
                  Text(
                    'You have arrived at the station. \n'
                        'Click Complete to finish.',
                    style: TextStyle(
                      fontSize: 14,
                      height: 1.5,
                      color: Colors.green,
                    ),
                  ),
                  SizedBox(height: 10),
                  ValueListenableBuilder<bool>(
                      valueListenable: pickedAll,
                      builder: (context, value, _)=>Row(
                        children: [
                          Checkbox(value: value,
                              splashRadius: 20,
                              fillColor: MaterialStateProperty.all(Colors.green) ,
                              onChanged: (val){
                            pickedAll.value = val!;
                          }),
                          Text("I picked all waiting passengers"),
                        ],
                      ),
                  ),
                  SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: BoxButton.rounded(
                      text: "COMPLETE",
                      backgroundColor: Colors.green[700],
                      onPressed: (){
                        Navigator.pop(context);
                        // context.read<DriverHomeBloc>()
                        //     .add(DriverCompleteEvent(Station()));
                      },
                    ),
                  ),
                ],
              ),
      )
      )
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shuttla/core/blocs/driver_home_bloc.dart';
import 'package:shuttla/ui/size_config/size_config.dart';
import 'package:shuttla/ui/widgets/custom_button.dart';

class DriverEnrouteFragment extends StatelessWidget {
  const DriverEnrouteFragment({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<DriverHomeBloc>(context);
    return BlocBuilder<DriverHomeBloc, DriverHomeState>(
      builder:(context, state)=> Padding(
        padding: const EdgeInsets.all(8.0),
        child: Card(
          elevation: 5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
          child: Container(
            padding: EdgeInsets.all(SizeConfig.widthOf(7)),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.departure_board), SizedBox(width: 10),
                    Text(
                        bloc.selectedStation!.stationName,
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
                    'You have selected this station.\n'
                        'Please go to the selected station for pickup',
                    style: TextStyle(
                        fontSize: 14,
                    ),
                ),
                SizedBox(height: 10),
                RichText(
                  text: TextSpan(text: '${bloc.selectedStation!.waitingPassengers.length}', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
                    children: [
                      TextSpan(text: " passengers waiting.", style: TextStyle(fontWeight: FontWeight.normal, color: Colors.black)),
                    ]
                  ),
                ),
                SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: BoxButton.rounded(
                    text: "PICKUP",
                    backgroundColor: Theme.of(context).primaryColorDark,
                    onPressed: (){
                      context.read<DriverHomeBloc>()
                          .add(DriverPickupEvent(bloc.selectedStation!));
                    },
                  ),
                ),
                SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  child: BoxButton.rounded(text: "CANCEL",
                    onPressed: () {
                      Navigator.pop(context);
                      context.read<DriverHomeBloc>()
                          .add(DriverCancelEvent(bloc.selectedStation!));
                    },
                  ),
                ),


              ],
            ),
          ),
        ),
      ),
    );
  }
}

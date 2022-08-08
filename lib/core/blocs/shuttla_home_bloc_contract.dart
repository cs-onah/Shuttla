import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shuttla/core/blocs/driver_home_bloc.dart';
import 'package:shuttla/core/blocs/passenger_home_bloc.dart';
import 'package:shuttla/core/data_models/station.dart';

abstract class ShuttlaHomeBloc{
  Station? selectedStation;
  StreamSubscription? stationStream;

  void add(covariant dynamic value);
}

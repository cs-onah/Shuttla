import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:shuttla/core/blocs/authentication_bloc.dart';
import 'package:shuttla/core/blocs/blocA.dart';
import 'package:shuttla/core/blocs/driver_home_bloc.dart';
import 'package:shuttla/core/blocs/passenger_home_bloc.dart';
import 'package:shuttla/core/blocs/station_cubit.dart';
import 'package:shuttla/core/viewmodels/home_viewmodel.dart';
import 'package:shuttla/core/viewmodels/providerA.dart';


class AppProviders {
  //The providers for dependency injection and state management are to added here
  //as the app will use MultiProvider
  static final providers = <SingleChildWidget>[
    //format for registering providers:
    ListenableProvider(create: (_) => ProviderA()),
    ListenableProvider(create: (_) => HomeViewmodel()),

  ];

  static final blocProviders = <BlocProvider>[
    //format for registering providers:
    BlocProvider<BlocA>(create: (BuildContext context) => BlocA()),
    BlocProvider<AuthenticationBloc>(create: (context) => AuthenticationBloc()),
    BlocProvider<StationCubit>(create: (context) => StationCubit()),

    // These providers have been scoped to their respective home screens
    // BlocProvider<PassengerHomeBloc>(create: (context) => PassengerHomeBloc()),
    // BlocProvider<DriverHomeBloc>(create: (context) => DriverHomeBloc()),
  ];
}

import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shuttla/core/data_models/station.dart';
import 'package:shuttla/core/services/session_manager.dart';
import 'package:shuttla/core/services/station_service.dart';

class DriverHomeBloc extends Bloc<DriverHomeEvent, DriverHomeState> {
  Station? selectedStation;
  StreamSubscription? stationStream;

  DriverHomeBloc() : super(DriverIdleState()) {
    on<DriverFetchStationDetailEvent>(
      (event, emit) {
        selectedStation = event.station;
        listenToStationEvents(event.station);
        return emit(DriverStationDetailState(event.station));
      },
    );

    on<DriverEnrouteEvent>(
      (event, emit) {
        //Add driver to approachingDrivers list
        try {
          StationService().driverPickupPassengers(
            driver: SessionManager.user!,
            station: selectedStation!,
          );
        } catch (e) {
          return emit(DriverErrorState(e.toString()));
        }
        return emit(DriverEnrouteState());
      },
    );

    on<DriverCancelEvent>(
      (event, emit) {
        stationStream?.cancel();
        try {
          StationService().driverCancelStationSelection(
            driver: SessionManager.user!,
            station: selectedStation!,
          );
        } catch (e) {
          return emit(DriverErrorState(e.toString()));
        }
        return emit(DriverIdleState());
      },
    );
    on<DriverPickupEvent>(
      (event, emit) {
        stationStream?.cancel();
        try {
          StationService().driverPickupPassengers(
            driver: SessionManager.user!,
            station: selectedStation!,
          );
        } catch (e) {
          return emit(DriverErrorState(e.toString()));
        }
        return emit(DriverPickupState());
      },
    );
    on<DriverCompleteEvent>(
      (event, emit) => emit(DriverIdleState(completedSession: true)),
    );
  }

  void listenToStationEvents(Station station) {
    //Station stream
    stationStream?.cancel();
    stationStream =
        StationService().getStationDetailStream(station).listen((event) {
      print("Firebase Station Stream fired");

      Station stationUpdate = Station.fromFirebaseSnapshot(event);

      /// Checks if current user has joined waiting list
      if (stationUpdate.waitingPassengers
          .contains(SessionManager.user!.userData)) {
        add(DriverFetchStationDetailEvent(stationUpdate));
      }

      selectedStation = stationUpdate;
    });
  }
}

//Events
abstract class DriverHomeEvent {}

class DriverIdleEvent extends DriverHomeEvent {}

class DriverFetchStationDetailEvent extends DriverHomeEvent {
  final Station station;
  DriverFetchStationDetailEvent(this.station);
}

class DriverCancelEvent extends DriverHomeEvent {
  final String stationId, stationName;
  DriverCancelEvent(this.stationId, this.stationName);
}

class DriverEnrouteEvent extends DriverHomeEvent {
  final String stationId, stationName;
  DriverEnrouteEvent(this.stationId, this.stationName);
}

class DriverPickupEvent extends DriverHomeEvent {
  final String stationId, stationName;
  DriverPickupEvent(this.stationId, this.stationName);
}

class DriverCompleteEvent extends DriverHomeEvent {
  final String stationId, stationName;
  DriverCompleteEvent(this.stationId, this.stationName);
}

//states
abstract class DriverHomeState {}

class DriverIdleState extends DriverHomeState {
  final List? stations;
  final bool completedSession;
  DriverIdleState({this.completedSession = false, this.stations});
}

class DriverStationDetailState extends DriverHomeState {
  final Station station;
  DriverStationDetailState(this.station);
}

class DriverPickupState extends DriverHomeState {
  DriverPickupState();
}

class DriverEnrouteState extends DriverHomeState {
  DriverEnrouteState();
}

class DriverErrorState extends DriverHomeState {
  final String errorMessage;
  DriverErrorState(this.errorMessage);
}

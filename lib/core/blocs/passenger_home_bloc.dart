import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shuttla/core/blocs/shuttla_home_bloc_contract.dart';
import 'package:shuttla/core/data_models/station.dart';
import 'package:shuttla/core/services/session_manager.dart';
import 'package:shuttla/core/services/station_service.dart';

class PassengerHomeBloc extends Bloc<PassengerHomeEvent, PassengerHomeState>
    implements ShuttlaHomeBloc {
  StreamSubscription? stationStream;
  Station? selectedStation;

  PassengerHomeBloc() : super(PassengerIdleState()) {
    on<PassengerFetchStationDetailEvent>(
      (event, emit) {
        selectedStation = event.station;
        if (stationStream == null) listenToStationEvents(event);
        return emit(PassengerStationDetailState(event.station,
            showUI: event.showStationDetailsUI));
      },
    );

    on<PassengerJoinStationEvent>(
      (event, emit) {
        //Add new passenger to station queue
        try {
          StationService().joinStation(
            user: SessionManager.user!.userData,
            station: event.station ?? selectedStation!,
          );
        } catch (e) {
          return emit(PassengerErrorState(e.toString()));
        }
        return;
      },
    );

    on<PassengerLeaveStationEvent>(
      (event, emit) {
        try {
          StationService().leaveStation(
            user: SessionManager.user!.userData,
            station: event.station ?? selectedStation!,
          );
          resetPassengerHomeBloc();
        } catch (e) {
          return emit(PassengerErrorState(e.toString()));
        }
        return emit(PassengerIdleState());
      },
    );

    on<PassengerResetEvent>(
      (event, emit) {
        resetPassengerHomeBloc();
        return emit(PassengerIdleState());
      },
    );

    on<PassengerJoinSuccessfulEvent>(
      (event, emit) {
        selectedStation = event.station;
        return emit(PassengerWaitingState(event.station));
      },
    );

    on<DriverPickedPassengerEvent>(
      (event, emit) => emit(PassengerPickupState(event.station)),
    );
  }

  void resetPassengerHomeBloc() {
    stationStream?.cancel();
    stationStream = null;
    selectedStation = null;
  }

  void setupStationAndJoinWait(Station station) {
    add(PassengerFetchStationDetailEvent(station, showStationDetailsUI: false));
    add(PassengerJoinStationEvent(station));
  }

  void listenToStationEvents(PassengerFetchStationDetailEvent event) {
    //Station stream
    stationStream?.cancel();
    stationStream =
        StationService().getStationDetailStream(event.station).listen((event) {
      print("Firebase Station Stream fired");

      Station stationUpdate = Station.fromFirebaseSnapshot(event);

      /// Checks if current user has joined waiting list
      if (stationContainsCurrentUser(stationUpdate)) {
        return add(PassengerJoinSuccessfulEvent(stationUpdate));
      }

      /// Checks if driver has picked passengers from station since last update
      /// [DriverPickedPassengerEvent] is triggered if current user is a [Station.waitingPassenger]
      if (selectedStation!.lastPickupTime != null) {
        if (stationUpdate.lastPickupTime!
                .isAfter(selectedStation!.lastPickupTime!) && stationContainsCurrentUser(selectedStation!)) {
          return add(DriverPickedPassengerEvent(stationUpdate));
        }
      }

      ///Check if station data is updated
      if (selectedStation != stationUpdate) {
        print("station data changed");

        ///Check if New driver is assigned to station
        if (selectedStation!.approachingDrivers.map((e) => e.userData.userId) !=
            stationUpdate.approachingDrivers.map((e) => e.userData.userId)) {
          print("New driver coming");
          // Start listening for driver location
          add(PassengerJoinSuccessfulEvent(stationUpdate));
        }

        /// Add Event to update UI
        ///
        /// Updates UI if remote data changes while state is
        /// [PassengerStationDetailState] or [PassengerWaitingState]
        if (state is PassengerStationDetailState) {
          add(PassengerFetchStationDetailEvent(stationUpdate));
        } else if (state is PassengerWaitingState &&
            stationUpdate.waitingPassengers
                .contains(SessionManager.user!.userData)) {
          add(PassengerJoinSuccessfulEvent(stationUpdate));
        }
      }
    });
  }

  bool stationContainsCurrentUser(Station station) => station.waitingPassengers.map((e) => e.userId)
      .contains(SessionManager.user!.userData.userId);
}

//Events
abstract class PassengerHomeEvent {}

abstract class AppTriggeredHomeEvent extends PassengerHomeEvent {}

class PassengerResetEvent extends AppTriggeredHomeEvent {}

class PassengerFetchStationDetailEvent extends AppTriggeredHomeEvent {
  Station station;
  final bool showStationDetailsUI;
  PassengerFetchStationDetailEvent(this.station,
      {this.showStationDetailsUI = true});
}

class PassengerLeaveStationEvent extends AppTriggeredHomeEvent {
  final Station? station;
  PassengerLeaveStationEvent([this.station]);
}

class PassengerJoinStationEvent extends AppTriggeredHomeEvent {
  final Station? station;
  PassengerJoinStationEvent([this.station]);
}

///Firebase Triggered Events
abstract class FirebaseTriggeredHomeEvent extends PassengerHomeEvent {}

class PassengerJoinSuccessfulEvent extends FirebaseTriggeredHomeEvent {
  final Station station;
  PassengerJoinSuccessfulEvent(this.station);
}

class DriverPickedPassengerEvent extends FirebaseTriggeredHomeEvent {
  final Station station;
  DriverPickedPassengerEvent(this.station);
}

//UI States
abstract class PassengerHomeState {}

class PassengerIdleState extends PassengerHomeState {
  final List? stations;
  PassengerIdleState([this.stations]);
}

class PassengerStationDetailState extends PassengerHomeState {
  final Station station;
  final bool showUI;
  PassengerStationDetailState(this.station, {this.showUI = true});
}

class PassengerErrorState extends PassengerHomeState {
  final String errorMessage;
  PassengerErrorState(this.errorMessage);
}

class PassengerWaitingState extends PassengerHomeState {
  final Station station;
  PassengerWaitingState(this.station);
}

class PassengerPickupState extends PassengerHomeState {
  final Station station;
  PassengerPickupState(this.station);
}

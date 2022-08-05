import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shuttla/core/data_models/station.dart';
import 'package:shuttla/core/services/session_manager.dart';
import 'package:shuttla/core/services/station_service.dart';

class PassengerHomeBloc extends Bloc<PassengerHomeEvent, PassengerHomeState> {
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
        stopStationStream();
        try {
          StationService().leaveStation(
            user: SessionManager.user!.userData,
            station: event.station ?? selectedStation!,
          );
        } catch (e) {
          return emit(PassengerErrorState(e.toString()));
        }
        return emit(PassengerIdleState());
      },
    );

    on<DriverComingEvent>(
      (event, emit) => emit(PassengerStationDetailState(event.station)),
    );

    on<PassengerResetEvent>(
      (event, emit) {
        stopStationStream();
        return emit(PassengerIdleState());
      },
    );

    on<UserJoinSuccessfulEvent>(
      (event, emit) => emit(PassengerWaitingState()),
    );

    on<DriverPickedPassengerEvent>(
      (event, emit) => emit(PassengerPickupState(event.station)),
    );
  }

  void stopStationStream() {
    stationStream?.cancel();
    stationStream = null;
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

      ///Check if New driver is assigned to station
      if (selectedStation!.approachingDrivers.length !=
          stationUpdate.approachingDrivers.length) {
        add(DriverComingEvent(stationUpdate));
      }

      ///TODO: On passenger leave
      ///add PassengerLeaveStationEvent from Button

      /// Checks if current user has joined waiting list
      if (stationUpdate.waitingPassengers
          .contains(SessionManager.user!.userData)) {
        add(UserJoinSuccessfulEvent(stationUpdate));
      }

      /// Checks if driver has picked passengers
      if (selectedStation!.lastPickupTime != null) {
        if (stationUpdate.lastPickupTime!
            .isAfter(selectedStation!.lastPickupTime!)) {
          add(DriverPickedPassengerEvent(stationUpdate));
        }
      }

      ///Check if station data is updated
      if (selectedStation != stationUpdate) {
        print("station data changed");

        /// Add Event to update UI
        ///
        /// Updates UI if remote data changes while state is
        /// [PassengerStationDetailState] or [PassengerWaitingState]
        if (state is PassengerStationDetailState) {
          add(PassengerFetchStationDetailEvent(stationUpdate));
        } else if (state is PassengerWaitingState &&
            stationUpdate.waitingPassengers
                .contains(SessionManager.user!.userData)) {
          add(UserJoinSuccessfulEvent(stationUpdate));
        }
      }
    });
  }
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

class DriverComingEvent extends FirebaseTriggeredHomeEvent {
  final Station station;
  DriverComingEvent(this.station);
}

class UserJoinSuccessfulEvent extends FirebaseTriggeredHomeEvent {
  final Station station;
  UserJoinSuccessfulEvent(this.station);
}

class DriverPickedPassengerEvent extends FirebaseTriggeredHomeEvent {
  final Station station;
  DriverPickedPassengerEvent(this.station);
}

//states
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

class PassengerWaitingState extends PassengerHomeState {}

class PassengerPickupState extends PassengerHomeState {
  final Station station;
  PassengerPickupState(this.station);
}

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
        listenToStationEvents(event);
        emit(PassengerStationDetailState(selectedStation!));
      },
    );

    on<PassengerJoinStationEvent>(
      (event, emit) {
        //Add new passenger to station queue
        try {
          StationService().joinStation(
            user: SessionManager.user!.userData,
            station: selectedStation!,
          );
        } catch (e) {
          return emit(PassengerErrorState(e.toString()));
        }
        return;
      },
    );

    on<PassengerLeaveStationEvent>(
      (event, emit) {
        stationStream?.cancel();
        try {
          StationService().leaveStation(
            user: SessionManager.user!.userData,
            station: selectedStation!,
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

    on<UserJoinStationEvent>(
      (event, emit) => emit(PassengerWaitingState()),
    );

    on<DriverPickedPassengerEvent>(
      (event, emit) => emit(PassengerPickupState()),
    );
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
        add(UserJoinStationEvent(stationUpdate));
      }

      /// Checks if driver has picked passengers
      if (selectedStation!.lastPickupTime != null) {
        if (stationUpdate.lastPickupTime!
            .isAfter(selectedStation!.lastPickupTime!)) {
          add(DriverPickedPassengerEvent(stationUpdate));
        }
      }

      selectedStation = stationUpdate;
    });
  }
}

//Events
abstract class PassengerHomeEvent {}

class PassengerFetchStationDetailEvent extends PassengerHomeEvent {
  final Station station;
  PassengerFetchStationDetailEvent(this.station);
}

class PassengerLeaveStationEvent extends PassengerHomeEvent {
  final Station? station;
  PassengerLeaveStationEvent([this.station]);
}

class DriverComingEvent extends PassengerHomeEvent {
  final Station station;
  DriverComingEvent(this.station);
}

class UserJoinStationEvent extends PassengerHomeEvent {
  final Station station;
  UserJoinStationEvent(this.station);
}

class DriverPickedPassengerEvent extends PassengerHomeEvent {
  final Station station;
  DriverPickedPassengerEvent(this.station);
}

class PassengerJoinStationEvent extends PassengerHomeEvent {}

//states
abstract class PassengerHomeState {}

class PassengerIdleState extends PassengerHomeState {
  final List? stations;
  PassengerIdleState([this.stations]);
}

class PassengerStationDetailState extends PassengerHomeState {
  final Station station;
  PassengerStationDetailState(this.station);
}

class PassengerErrorState extends PassengerHomeState {
  final String errorMessage;
  PassengerErrorState(this.errorMessage);
}

class PassengerWaitingState extends PassengerHomeState {}

class PassengerPickupState extends PassengerHomeState {}

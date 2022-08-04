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

        //Station stream
        stationStream?.cancel();
        stationStream = StationService()
            .getStationDetailStream(event.station)
            .listen((event) {
              print("Stream fired");
          Station stationUpdate = Station.fromFirebaseSnapshot(event);
              print(stationUpdate.waitingPassengers);

          ///TODO: Check driver arriving

          /// Checks if current user has joined waiting list
          if (stationUpdate.waitingPassengers
              .contains(SessionManager.user!.userData)) {
            emit(PassengerWaitingState());
          }

          /// Checks if driver has picked passengers
          if(selectedStation!.lastPickupTime != null){
            if(stationUpdate.lastPickupTime!.isAfter(selectedStation!.lastPickupTime!))
              emit(PassengerPickupState());
          }
        });

        return emit(PassengerStationDetailState(selectedStation!));
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
        return emit(PassengerIdleState());
      },
    );
  }
}

//Events
abstract class PassengerHomeEvent {}

class PassengerFetchStationDetailEvent extends PassengerHomeEvent {
  final Station station;
  PassengerFetchStationDetailEvent(this.station);
}

class PassengerLeaveStationEvent extends PassengerHomeEvent {
  final String stationId, stationName;
  PassengerLeaveStationEvent(this.stationId, this.stationName);
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

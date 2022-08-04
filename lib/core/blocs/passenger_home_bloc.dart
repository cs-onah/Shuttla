import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shuttla/core/data_models/station.dart';
import 'package:shuttla/core/services/session_manager.dart';
import 'package:shuttla/core/services/station_service.dart';

class PassengerHomeBloc extends Bloc<PassengerHomeEvent, PassengerHomeState> {
  StreamSubscription? stationStream;
  Station? selectedStation;

  PassengerHomeBloc() : super(PassengerIdleState()) {
    on<PassengerFetchAllStationsEvent>(
      (event, emit) => emit(PassengerIdleState()),
    );

    on<PassengerFetchStationDetailEvent>(
      (event, emit) {
        selectedStation = event.station;
        stationStream = StationService()
            .getStationDetailStream(event.station)
            .listen((event) {
          Station stationUpdate = Station.fromFirebaseSnapshot(event);

          ///TODO: Check driver arriving

          ///TODO: Check if joined waiting list
          if (stationUpdate.waitingPassengers
              .contains(SessionManager.user!.userData)) {
            emit(PassengerWaitingState());
          }

          ///TODO: Check if driver has picked passengers
        });

        return emit(PassengerStationDetailState(selectedStation!));
      },
    );

    on<PassengerJoinStationEvent>(
      (event, emit) {
        //Add new passenger to station queue
        try {
          StationService().joinQueue(
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

class PassengerIdleEvent extends PassengerHomeEvent {}

class PassengerFetchAllStationsEvent extends PassengerHomeEvent {}

class PassengerFetchStationDetailEvent extends PassengerHomeEvent {
  final Station station;
  PassengerFetchStationDetailEvent(this.station);
}

class PassengerLeaveStationEvent extends PassengerHomeEvent {
  final String stationId, stationName;
  PassengerLeaveStationEvent(this.stationId, this.stationName);
}

class PassengerJoinStationEvent extends PassengerHomeEvent {
  final String stationId, stationName;
  PassengerJoinStationEvent(this.stationId, this.stationName);
}

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

class PassengerWaitingState extends PassengerHomeState {
  PassengerWaitingState();
}

class PassengerPickupState extends PassengerHomeState {
  PassengerPickupState();
}

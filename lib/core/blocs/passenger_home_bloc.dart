import 'package:flutter_bloc/flutter_bloc.dart';

class PassengerHomeBloc extends Bloc<PassengerHomeEvent, PassengerHomeState>{
  PassengerHomeBloc() : super(PassengerIdleState()){
    on<PassengerFetchAllStationsEvent>(
            (event, emit)=> emit(PassengerIdleState()),
    );
    on<PassengerFetchStationDetailEvent>(
          (event, emit)=> emit(PassengerStationDetailState()),
    );
    on<PassengerJoinStationEvent>(
          (event, emit)=> emit(PassengerWaitingState()),
    );
    on<PassengerLeaveStationEvent>(
          (event, emit)=> emit(PassengerIdleState()),
    );
  }
}

//Events
abstract class PassengerHomeEvent{}
class PassengerIdleEvent extends PassengerHomeEvent{}
class PassengerFetchAllStationsEvent extends PassengerHomeEvent{}
class PassengerFetchStationDetailEvent extends PassengerHomeEvent{
  final String stationId, stationName;
  PassengerFetchStationDetailEvent(this.stationId, this.stationName);
}
class PassengerLeaveStationEvent extends PassengerHomeEvent{
  final String stationId, stationName;
  PassengerLeaveStationEvent(this.stationId, this.stationName);
}
class PassengerJoinStationEvent extends PassengerHomeEvent{
  final String stationId, stationName;
  PassengerJoinStationEvent(this.stationId, this.stationName);
}


//states
abstract class PassengerHomeState{}
class PassengerIdleState extends PassengerHomeState{
  final List? stations;
  PassengerIdleState([this.stations]);
}
class PassengerStationDetailState extends PassengerHomeState{
  final dynamic station;
  PassengerStationDetailState([this.station]);
}
class PassengerWaitingState extends PassengerHomeState{
  PassengerWaitingState();
}
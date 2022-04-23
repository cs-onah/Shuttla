import 'package:flutter_bloc/flutter_bloc.dart';

class DriverHomeBloc extends Bloc<DriverHomeEvent, DriverHomeState>{
  DriverHomeBloc() : super(DriverIdleState()){
    on<DriverFetchAllStationsEvent>(
          (event, emit)=> emit(DriverIdleState()),
    );
    on<DriverFetchStationDetailEvent>(
          (event, emit)=> emit(DriverStationDetailState()),
    );
    on<DriverEnrouteEvent>(
          (event, emit)=> emit(DriverEnrouteState()),
    );
    on<DriverCancelEvent>(
          (event, emit)=> emit(DriverIdleState()),
    );
    on<DriverPickupEvent>(
          (event, emit)=> emit(DriverPickupState()),
    );
    on<DriverCompleteEvent>(
          (event, emit)=> emit(DriverIdleState()),
    );
  }
}

//Events
abstract class DriverHomeEvent{}
class DriverIdleEvent extends DriverHomeEvent{}
class DriverFetchAllStationsEvent extends DriverHomeEvent{}
class DriverFetchStationDetailEvent extends DriverHomeEvent{
  final String stationId, stationName;
  DriverFetchStationDetailEvent(this.stationId, this.stationName);
}
class DriverCancelEvent extends DriverHomeEvent{
  final String stationId, stationName;
  DriverCancelEvent(this.stationId, this.stationName);
}
class DriverEnrouteEvent extends DriverHomeEvent{
  final String stationId, stationName;
  DriverEnrouteEvent(this.stationId, this.stationName);
}
class DriverPickupEvent extends DriverHomeEvent{
  final String stationId, stationName;
  DriverPickupEvent(this.stationId, this.stationName);
}
class DriverCompleteEvent extends DriverHomeEvent{
  final String stationId, stationName;
  DriverCompleteEvent(this.stationId, this.stationName);
}


//states
abstract class DriverHomeState{}
class DriverIdleState extends DriverHomeState{
  final List? stations;
  DriverIdleState([this.stations]);
}
class DriverStationDetailState extends DriverHomeState{
  final dynamic station;
  DriverStationDetailState([this.station]);
}
class DriverPickupState extends DriverHomeState{
  DriverPickupState();
}
class DriverEnrouteState extends DriverHomeState{
  DriverEnrouteState();
}
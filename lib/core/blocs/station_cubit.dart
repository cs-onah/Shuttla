import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shuttla/core/services/station_service.dart';

class StationCubit extends Cubit<StationState> {
  StationService _stationService;
  StationCubit(StationService? service)
      : _stationService = service ?? StationService(),
        super(IdleStationState());

  Future createStation({
    required String stationName,
    String? description,
    required double latitude,
    required double longitude,
  }) async {
    emit(LoadingStationState());
    try{
      await _stationService.createStation(
        stationName: stationName,
        description: description,
        coordinates: [latitude, longitude],
      );
      return emit(SuccessStationState());
    } catch (e){
      return emit(ErrorStationState(e.toString()));
    }
  }
}

class StationState {}

class IdleStationState extends StationState {}

class LoadingStationState extends StationState {}

class SuccessStationState extends StationState {}

class ErrorStationState extends StationState {
  String error;
  ErrorStationState(this.error);
}

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shuttla/core/data_models/station.dart';
import 'package:shuttla/core/services/station_service.dart';

class StationCubit extends Cubit<StationState> {
  StationService _stationService;
  StationCubit([StationService? service])
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

  Future getStations({bool showLoader = true}) async{
    if(showLoader) emit(LoadingStationState());
    try{
      List<Station> stations = await _stationService.getStation();
      return emit(LoadedStationState(stations));
    } catch (e){
      return emit(ErrorStationState(e.toString()));
    }
  }

  Future editStation(Station newStation) async{
    try{
      await _stationService.editStation(newStation);
      return getStations(showLoader: false);
    } catch (e){
      return emit(ErrorStationState(e.toString()));
    }
  }

  Future deleteStation(Station station) async{
    try{
      await _stationService.deleteStation(station.reference!);
      return getStations(showLoader: false);
    } catch (e){
      return emit(ErrorStationState(e.toString()));
    }
  }
}

class StationState {}

class IdleStationState extends StationState {}

class LoadingStationState extends StationState {}

class SuccessStationState extends StationState {}

class LoadedStationState extends StationState {
  final List<Station> stations;
  LoadedStationState(this.stations);
}

class ErrorStationState extends StationState {
  String error;
  ErrorStationState(this.error);
}

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:shuttla/core/blocs/station_cubit.dart';
import 'package:shuttla/core/data_models/station.dart';
import 'package:shuttla/core/services/station_service.dart';

import 'station_service_test.mocks.dart';

@GenerateMocks([StationService])
void main(){
  late StationCubit sut;
  late StationService stationService;

  setUp(() async{
    stationService = MockStationService();
    sut = StationCubit(stationService);
  });

  group("getStation", (){
    // Set getStation() to return [sampleStations]
    setUp((){
      when(stationService.getStation())
        .thenAnswer((realInvocation) async => sampleStations);
    });

    test("testData is constant", () async {
      await sut.getStations();

      // check that getStation() depends on [StationService]
      verify(stationService.getStation()).called(1);
      // check if stations stored in bloc is same as sampleStations
      expectLater(sut.stations, sampleStations);
      // check if LoadedState is returned after service call
      expectLater(sut.state, isA<LoadedStationState>());
    });
  });
}

class MockStation extends Mock implements Station {}

final List<Station> sampleStations = [MockStation(), MockStation()];



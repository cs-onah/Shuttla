import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:shuttla/core/data_models/station.dart';
import 'package:shuttla/core/services/station_service.dart';

import 'station_service_test.mocks.dart';

@GenerateMocks([Station])
void main(){

  StationService sut;
  CollectionReference stationCollection;

  setUp(() async{
    sut = StationService();
    await Firebase.initializeApp();
  });

  group("getStation", (){
    Station testData = MockStation();
    testData.approachingDrivers = [];
    test("testData is constant", (){
      expect(testData, testData);
    });

  });


}

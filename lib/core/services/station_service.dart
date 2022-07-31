import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shuttla/constants/collection_names.dart';
import 'package:shuttla/core/data_models/station.dart';

class StationService {
  late FirebaseFirestore _firestore;
  late CollectionReference _stationCollection;

  StationService({FirebaseAuth? auth, FirebaseFirestore? firestore}) {
    _firestore = firestore ?? FirebaseFirestore.instance;
    _stationCollection = _firestore.collection(CollectionName.STATIONS);
  }

  createStation({
    required String stationName,
    String? description,
    required List<double> coordinates,
    int? capacity,
  }) async {
    Station newStation = Station(
      stationName: stationName,
      description: description,
      coordinates: coordinates,
      createdDate: DateTime.now().toString(),
    );
    await _stationCollection.add(newStation.toMap());
    return true;
  }

  Future<List<Station>> getStation() async {
    QuerySnapshot data = await _stationCollection.get();
    return data.docs.map((e) => Station.fromMap(e.data()!)).toList();
  }

  /// Provides a listenable snapshot of station collection
  ///
  /// To use, create a [StreamSubscription] from the snapshot
  /// remember to cancel stream subscription when not in use.
  Stream<QuerySnapshot> getStationSnapshot() {
    return _stationCollection.snapshots();
  }

  _test(){

    getStationSnapshot().listen((event) {
      event.docs.map((e) => Station.fromMap(e.data()!));
    });
  }
}
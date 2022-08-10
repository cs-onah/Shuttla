import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shuttla/constants/collection_names.dart';
import 'package:shuttla/core/data_models/app_user.dart';
import 'package:shuttla/core/data_models/station.dart';
import 'package:shuttla/core/data_models/user_data.dart';
import 'package:shuttla/core/services/session_manager.dart';

class StationService {
  late FirebaseFirestore _firestore;
  late CollectionReference _stationCollection;

  StationService({FirebaseAuth? auth, FirebaseFirestore? firestore}) {
    _firestore = firestore ?? FirebaseFirestore.instance;
    _stationCollection = _firestore.collection(CollectionName.STATIONS);
  }

  Future createStation({
    required String stationName,
    String? description,
    required List<double> coordinates,
    int? capacity,
  }) async {
    Map<String, dynamic> newStation = {
      "station_name": stationName,
      "description": description,
      "coordinates": coordinates,
      "created_date": DateTime.now().toString(),
    };

    await _stationCollection.add(newStation);
    return true;
  }

  Future<List<Station>> getStation() async {
    QuerySnapshot data = await _stationCollection.get();
    return data.docs.map((e) => Station.fromFirebaseSnapshot(e)).toList();
  }

  Future deleteStation(DocumentReference stationReference) async {
    await stationReference.delete();
    return true;
  }

  /// Edit Station details
  ///
  /// Usage: use the [Station.copyWith] method to edit the desired properties
  Future editStation(Station station) async {
    await station.reference.set(station.toMap());
    return true;
  }

  /// Add user to queue
  ///
  Future joinStation({required UserData user, required Station station}) async {
    if (station.waitingPassengers.contains(user)) return true;
    station.waitingPassengers.add(user);
    await station.reference.set(station.toMap());
    return true;
  }

  /// Add user to queue
  ///
  Future leaveStation(
      {required UserData user, required Station station}) async {
    if (!station.waitingPassengers.contains(user)) return true;
    station.waitingPassengers.remove(user);
    await station.reference.set(station.toMap());
    return true;
  }

  /// Provides a listenable snapshot of station collection
  ///
  /// To use, create a [StreamSubscription] from the snapshot
  /// remember to cancel stream subscription when not in use.
  /// ```dart
  /// getStationSnapshot().listen((event) {
  ///   event.docs.map((e) => Station.fromMap(e.data()!));
  /// });
  /// ```
  Stream<QuerySnapshot> getStationSnapshot() {
    return _stationCollection.snapshots();
  }

  /// Provides a stream of a station details
  Stream<DocumentSnapshot> getStationDetailStream(Station station) {
    return station.reference.snapshots();
  }

  Future<bool> driverSelectStation({
    required Station station,
    required AppUser driver,
  }) async {
    if (station.approachingDrivers.contains(driver)) return true;
    station.approachingDrivers.add(driver);
    await station.reference.set(station.toMap());
    return true;
  }

  Future driverCancelStationSelection({
    required AppUser driver,
    required Station station,
  }) async {
    if (!station.approachingDrivers.contains(driver)) return true;
    station.approachingDrivers.remove(driver);
    await station.reference.set(station.toMap());
    return true;
  }

  Future driverPickupPassengers({
    required AppUser driver,
    required Station station,
  }) async {
    List<String> driverIds =
        station.approachingDrivers.map((e) => e.userData.userId).toList();
    String currentUserId = SessionManager.user!.userData.userId;

    if (!driverIds.contains(currentUserId))
      return Future.error("You have not selected this station for pickup.");

    //Remove driver from approaching list
    station.approachingDrivers.removeWhere(
        (e) => e.userData.userId == currentUserId);

    //Clear passenger list
    station.waitingPassengers = [];

    //Update last pickup time
    station.lastPickupTime = DateTime.now();

    await station.reference.set(station.toMap());
    return true;
  }
}

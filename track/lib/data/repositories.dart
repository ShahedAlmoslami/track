import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:track/data/models/place_model.dart';

class PlacesRepo {
  final _db = FirebaseFirestore.instance;

  Future<void> addPlace(PlaceModel place) async {
    await _db
        .collection('places')
        .doc(place.id)
        .set(place.toJson());
  }

  Future<List<PlaceModel>> getPlacesByCity(String cityId) async {
    final snapshot = await _db
        .collection('places')
        .where('cityId', isEqualTo: cityId)
        .get();

    return snapshot.docs
        .map((doc) => PlaceModel.fromJson(doc.id, doc.data()))
        .toList();
  }
}
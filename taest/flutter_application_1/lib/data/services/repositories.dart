
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_1/data/place_model.dart';

class Repositories {
  final db=FirebaseFirestore.instance;
  Future <void> addPlace(PlaceModel place,)async{
    await db.collection('places').add(place.toJson());
  }
  Future <List<PlaceModel>>getPlaces()async{
    final snapshot = await db.collection('places').get();
    return snapshot.docs.map((doc) => PlaceModel.fromJson(doc.id, doc.data())).toList();
  }
}

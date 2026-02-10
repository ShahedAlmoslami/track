import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:track/data/models/experience_model.dart';
import 'package:track/data/models/place_model.dart';

class PlacesRepo {
  final db = FirebaseFirestore.instance;

  Future<void> addPlace(PlaceModel place) async {
    await db
        .collection('places')
        .doc(place.id)
        .set(place.toJson());
  }

  Future<List<PlaceModel>> getPlacesByCity(String cityId) async {
    final snapshot = await db
        .collection('places')
        .where('cityId', isEqualTo: cityId)
        .get();

    return snapshot.docs
        .map((doc) => PlaceModel.fromJson(doc.id, doc.data()))
        .toList();
  }
  Future<void> addExperience(String placeId,ExperienceModel experienceModel)async{
    await db.collection('places').doc(placeId).collection('experiences').add(experienceModel.toJson());
    
  }
  Future<List<ExperienceModel>>getExperiences (String placeId,)async{
    final snap=await db.collection('places').doc(placeId).collection('experiences').get();
  
   return snap.docs
        .map((d) => ExperienceModel.fromJson(d.id, d.data()))
        .toList();

  }
}
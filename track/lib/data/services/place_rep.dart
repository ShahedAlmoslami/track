import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:track/data/models/experience_model.dart';
import 'package:track/data/models/hotelModel.dart';
import 'package:track/data/models/item_model.dart';
import 'package:track/data/models/menu_item_model.dart';
import 'package:track/data/models/place_model.dart';
import 'package:track/data/models/restaurantModel.dart';
import 'package:track/data/models/city_modle.dart';

class PlacesRepo {
  final db = FirebaseFirestore.instance;
  

  // ============================
// CITY METHODS
// ============================

Future<String> addCity(CityModel city) async {
  final doc = db.collection('cities').doc(); // auto id

  final newCity = city.copyWith(id: doc.id);

  await doc.set({
    ...newCity.toJson(),
    'createdAt': FieldValue.serverTimestamp(),
  });

  return doc.id;
}

Future<List<CityModel>> getCities() async {
  final snap = await db
      .collection('cities')
      .where('isActive', isEqualTo: true)
      .get();

  return snap.docs.map((doc) {
    final data = doc.data();
    data['id'] = doc.id; // نضمن وجود id
    return CityModel.fromJson(data);
  }).toList();
}

  Future<String> addPlace(String cityIdDoc, PlaceModel place) async {
    final ref = db.collection('cities').doc(cityIdDoc).collection('places').doc();
    await ref.set(place.toJson());
    return ref.id;
  }

  Future<List<PlaceModel>> getPlaces(String cityIdDoc, bool isPopular) async {
    final snap = await db
        .collection('cities')
        .doc(cityIdDoc)
        .collection('places')
        .where('isPopular', isEqualTo: isPopular )
        .get();

    return snap.docs.map((d) => PlaceModel.fromJson(cityId: cityIdDoc, doc: d)).toList();
  }

  // HOTELS
  Future<String> addHotel(String cityIdDoc, HotelModel hotel) async {
    final ref = db.collection('cities').doc(cityIdDoc).collection('hotels').doc();
    await ref.set(hotel.toJson());
    return ref.id;
  }

  Future<List<HotelModel>> getHotels(String cityIdDoc, String hotelName) async {
    final snap = await db
        .collection('cities')
        .doc(cityIdDoc)
        .collection('hotels')
        .get();

    return snap.docs.map((d) => HotelModel.fromJson(cityId: cityIdDoc, doc: d)).toList();
  }

  // RESTAURANTS ✅
  Future<String> addRestaurant(String cityIdDoc, RestaurantModel restaurant) async {
    final ref = db.collection('cities').doc(cityIdDoc).collection('restaurants').doc();
    await ref.set(restaurant.toJson());
    return ref.id;
  }

  Future<List<RestaurantModel>> getRestaurants(String cityIdDoc,) async {
    final snap = await db
        .collection('cities')
        .doc(cityIdDoc)
        .collection('restaurants')
        .get();

    return snap.docs.map((d) => RestaurantModel.fromFirestore(cityId: cityIdDoc, doc: d)).toList();
  }

  // EXPERIENCES تحت PLACE ✅ (Auto-ID)
  Future<String> addExperience(String cityIdDuc, String placeIdDuc, ExperienceModel exp) async {
    final ref = db
        .collection('cities')
        .doc(cityIdDuc)
        .collection('places')
        .doc(placeIdDuc)
        .collection('experiences')
        .doc(); // ✅ auto id

    await ref.set(exp.toJson());
    return ref.id;
  }

  Future<List<ExperienceModel>> getExperiences(String cityIdDuc, String placeIdDuc) async {
    final snap = await db
        .collection('cities')
        .doc(cityIdDuc)
        .collection('places')
        .doc(placeIdDuc)
        .collection('experiences')
        .get();

    return snap.docs.map((d) => ExperienceModel.fromJson(d.id, d.data())).toList();
  }
   Future<String> addItem(
    String cityDocId,
    String restaurantId,
    MenuCategoryModel item,
  ) async {
    try {

    
      final docRef = db
          .collection('cities')
          .doc(cityDocId)
          .collection('restaurants') 
          .doc(restaurantId)
          .collection('items')
          .doc(); 

      await docRef.set(item.toJson());

  debugPrint('done');

      return docRef.id;

    } catch (e) {
        debugPrint('error: $e');

      return '';
    }
  }

  Future<List<MenuCategoryModel>> getItems(
    String cityDocId,
    String restaurantId,) async {
    try {

      final snap = await db
          .collection('cities')
          .doc(cityDocId)
          .collection('restaurants') 
          .doc(restaurantId)
          .collection('items')
          .get();

      return snap.docs.map((d) {
        final items=d.data();
        items['id']=d.id;  
        return MenuCategoryModel.fromJson(
           items
          ,items['id']
        
        );
      }).toList();

    } catch (e) {
      return [];
    }
  }
  Future<String> addMenuItem(
    String cityDocId,
    String restaurantId,
    String itemId,
    MenuItemModel item,
  ) async {
    try {

    
      final docRef = db
          .collection('cities')
          .doc(cityDocId)
          .collection('restaurants') 
          .doc(restaurantId)
          .collection('items')
          .doc(itemId)
          .collection('menu')
          .doc();

      await docRef.set(item.toJson());

  debugPrint('done');

      return docRef.id;

    } catch (e) {
        debugPrint('error: $e');

      return '';
    }
  }

  Future<List<MenuItemModel>> getMenuItems(
    String cityDocId,
    String restaurantId,
    String itemId) async {
    try {

      final snap = await db
          .collection('cities')
          .doc(cityDocId)
          .collection('restaurants') 
          .doc(restaurantId)
          .collection('items')
          .doc(itemId)
          .collection('menu')
          .get();

      return  snap.docs.map((d) {
        final items=d.data();
        items['id']=d.id;  
        return  MenuItemModel.fromJson(
           items
          ,itemId
        );
      }).toList();

    } catch (e) {
      return [];
    }
  }
  
}
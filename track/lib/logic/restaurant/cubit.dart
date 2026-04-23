import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:track/data/models/restaurantModel.dart';
import 'package:track/data/services/place_rep.dart';
import 'package:track/logic/restaurant/state.dart';

class RestaurantCubit extends Cubit<RestaurantState> {
  final PlacesRepo repo;

  RestaurantCubit(this.repo) : super(RestaurantInitialstate());

  Future<String> addRestaurant(String cityIdDoc, RestaurantModel restaurant) async {
    emit(RestaurantLoadingstate());
    try {
      final restaurantId = await repo.addRestaurant(cityIdDoc, restaurant);
      emit(RestaurantSuccessstate(restaurant: [restaurant]));
      return restaurantId;
    } catch (e) {
      emit(RestaurantErrorstate(e.toString()));
      return '';
    }
  }

  Future<void> getRestaurant(String cityIdDoc,) async {
    emit(RestaurantLoadingstate());
    try {
      final restaurants = await repo.getRestaurants(cityIdDoc, );
      emit(RestaurantSuccessstate(restaurant: restaurants));
    } catch (e) {
      emit(RestaurantErrorstate(e.toString()));
    }
  }
}
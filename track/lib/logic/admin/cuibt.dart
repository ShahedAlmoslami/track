import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:track/data/models/city_modle.dart';
import 'package:track/data/models/experience_model.dart';
import 'package:track/data/models/item_model.dart';
import 'package:track/data/models/menu_item_model.dart';
import 'package:track/data/models/place_model.dart';
import 'package:track/data/models/hotelModel.dart';
import 'package:track/data/models/restaurantModel.dart';
import 'package:track/data/services/place_rep.dart';
import 'package:track/logic/admin/state.dart';
import 'package:track/logic/city/cubit.dart';

class AdminCubit extends Cubit<AdminState> {
  final PlacesRepo repo;

    final CityCubit? cityCubit;

  AdminCubit(this.repo, {this.cityCubit}) : super(AdminInitial());

  Future<String> addPlace(String cityId, PlaceModel place) async {
    emit(AdminLoading());
    try {
      final placeId = await repo.addPlace(cityId, place);
      emit(AdminSuccess());
      return placeId;
    } catch (e) {
      emit(AdminError(e.toString()));
      return '';
    }
  }

  Future<String> addHotel(String cityId, HotelModel hotel) async {
    emit(AdminLoading());
    try {
      final hotelId = await repo.addHotel(cityId, hotel);
      emit(AdminSuccess());
      return hotelId;
    } catch (e) {
      emit(AdminError(e.toString()));
      return '';
    }
  }

  Future<String> addRestaurant(String cityId, RestaurantModel restaurant) async {
    emit(AdminLoading());
    try {
      final restaurantId = await repo.addRestaurant(cityId, restaurant);
      emit(AdminSuccess());
      return restaurantId;
    } catch (e) {
      emit(AdminError(e.toString()));
      return '';
    }
  }

  // experiences تحت place
  Future<String> addExperience(
    String cityId,
    String placeId,
    ExperienceModel experienceModel,
  ) async {
    emit(AdminLoading());
    try {
      final experienceId =
          await repo.addExperience(cityId, placeId, experienceModel);
      emit(AdminSuccess());
      return experienceId;
    } catch (e) {
      emit(AdminError(e.toString()));
      return '';
    }
  }

  Future<void> addCitym(
   CityModel city
  ) async {
    emit(AdminLoading());
    try {
await repo.addCity(city);     
emit(AdminSuccess());
    } catch (e) {
      emit(AdminError(e.toString()));
    }
  }
  
  Future<String> addItem(
    String cityId,
    String reseId,
    MenuCategoryModel menuCategoryModel,
  ) async {
    emit(AdminLoading());
    try {
      final itemId =
          await repo.addItem(cityId, reseId, menuCategoryModel);
      emit(AdminSuccess());
      return itemId;
    } catch (e) {
      emit(AdminError(e.toString()));
      return '';
    }
  }
   Future<String> addMenuItem(
    String cityId,
    String reseId,
        String itemId,

    MenuItemModel menuItemModel,
  ) async {
    emit(AdminLoading());
    try {
      final dish =
          await repo.addMenuItem(cityId, reseId, itemId,menuItemModel);
      emit(AdminSuccess());
      return dish;
    } catch (e) {
      emit(AdminError(e.toString()));
      return '';
    }
  }
  }
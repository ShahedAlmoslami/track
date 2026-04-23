import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:track/data/models/city_modle.dart';
import 'package:track/data/services/place_rep.dart';
import 'package:track/logic/city/state.dart';

class CityCubit extends Cubit<CityState> {
  final PlacesRepo repo;

  CityCubit(this.repo) : super(CityInitial());

  // ✅ Add City
  Future<void> addCity(CityModel city) async {
    try {
      emit(CityLoading());

      await repo.addCity(city);

      emit(CitySuccess());
    } catch (e) {
      emit(CityError(e.toString()));
    }
  }

  // ✅ Get Cities
  Future<void> getCities() async {
    try {
      emit(CityLoading());

      final cities = await repo.getCities();

      emit(CitySuccess(cities: cities));
    } catch (e) {
      emit(CityError(e.toString()));
    }
  }

  // ✅ Soft Delete
  
 

}
import 'package:flutter/foundation.dart';
import 'package:track/data/models/city_modle.dart';

@immutable
abstract class CityState {}

class CityInitial extends CityState {}

class CityLoading extends CityState {}

class CitySuccess extends CityState {
  final List<CityModel>? cities;
  CitySuccess({this.cities});
}

class CityError extends CityState {
  final String message;
  CityError(this.message);
}
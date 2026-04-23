import 'package:track/data/models/restaurantModel.dart';

abstract class RestaurantState {}

class RestaurantInitialstate extends RestaurantState {}

class RestaurantLoadingstate extends RestaurantState {}

class RestaurantSuccessstate extends RestaurantState {
  final List<RestaurantModel> restaurant;
  RestaurantSuccessstate({required this.restaurant});
}

class RestaurantErrorstate extends RestaurantState {
  final String message;
  RestaurantErrorstate(this.message);
}
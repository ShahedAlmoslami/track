import 'package:track/data/models/place_model.dart';

class PlaceState{}
class PlaceInitialstate extends PlaceState{}
class PlaceLoadingstate extends PlaceState{}
class PlaceSuccessstate extends PlaceState{
  List<PlaceModel> places;
  PlaceSuccessstate({required this.places});
}
class PlaceErrorstate extends PlaceState{
  final String message;
  PlaceErrorstate(this.message);
}
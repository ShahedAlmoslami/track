import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:track/data/models/place_model.dart';
import 'package:track/data/services/place_rep.dart';
import 'package:track/logic/place_model/state.dart';

class PlaceCubit extends Cubit<PlaceState>{
  final PlacesRepo repo;

  PlaceCubit(this.repo) : super(PlaceInitialstate());
  Future<String> addPlace(String cityIdDoc, PlaceModel place) async {
    emit(PlaceLoadingstate());
    try {
      final placeId = await repo.addPlace(cityIdDoc, place);
      emit(PlaceSuccessstate(places: [place]));
      return placeId;
    } catch (e) {
      emit(PlaceErrorstate(e.toString()));
            return '';

    }
  }

  Future<void>getPlaces(String cityIdDoc,bool isPopular)async{
    emit(PlaceLoadingstate());
    try{
      final places=await repo.getPlaces( cityIdDoc , isPopular);
      emit(PlaceSuccessstate(places: places));
    } catch(e){
      emit(PlaceErrorstate(e.toString()));
    }
  }
  
}
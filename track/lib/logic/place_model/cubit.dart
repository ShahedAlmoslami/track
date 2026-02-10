import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:track/data/services/place_model.dart';
import 'package:track/logic/place_model/state.dart';

class PlaceCubit extends Cubit<PlaceState>{
  final PlacesRepo repo;
  PlaceCubit(this.repo) : super(PlaceInitialstate());
  Future<void>getPlacesByCity(String cityId)async{
    emit(PlaceLoadingstate());
    try{
      final places=await repo.getPlacesByCity(cityId);
      emit(PlaceSuccessstate(places: places));
    } catch(e){
      emit(PlaceErrorstate(e.toString()));
    }
  }
}
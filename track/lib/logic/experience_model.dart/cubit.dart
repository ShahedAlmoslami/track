import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:track/data/services/place_model.dart';
import 'package:track/logic/experience_model.dart/state.dart';

class ExperienceCuibt extends Cubit<ExperienceState>{
    final PlacesRepo repo;

  ExperienceCuibt(this.repo) : super(ExperienceInitialState());
  
  
  Future<void> getExperience(String placeId)async{
    emit(ExperienceLoadingState());
    try{
      final experience=await repo.getExperiences(placeId);
      emit(ExperienceSuccessState(experience));


      
    }catch(e){
      emit(ExperienceErrorState(e.toString()));
  }

 
  }
}
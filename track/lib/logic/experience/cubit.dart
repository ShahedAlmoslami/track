import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:track/data/models/experience_model.dart';
import 'package:track/data/services/place_rep.dart';
import 'package:track/logic/experience/state.dart';

class ExperienceCubit extends Cubit<ExperienceState> {
  final PlacesRepo repo;

  ExperienceCubit(this.repo) : super(ExperienceInitialState());

  Future<List<ExperienceModel>> getExperiences(String cityId, String placeId) async {
    emit(ExperienceLoadingState());
    try {
      final experiences = await repo.getExperiences(cityId, placeId);
      emit(ExperienceSuccessState(experiences));
      return experiences;
    } catch (e) {
      emit(ExperienceErrorState(e.toString()));
      return [];
    }
  }

  Future<String> addExperience(
    String cityId,
    String placeId,
    ExperienceModel experience,
  ) async {
    emit(ExperienceLoadingState());
    try {
      final experienceId = await repo.addExperience(cityId, placeId, experience);

      // ✅ تحديث القائمة بعد الإضافة
      final experiences = await repo.getExperiences(cityId, placeId);
      emit(ExperienceSuccessState(experiences));

      return experienceId;
    } catch (e) {
      emit(ExperienceErrorState(e.toString()));
      return '';
    }
  }
}
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:track/data/models/experience_model.dart';
import 'package:track/data/models/place_model.dart';
import 'package:track/data/services/place_model.dart';
import 'package:track/logic/admin/state.dart';
class AdminCubit extends Cubit<AdminState> {
  final PlacesRepo repo;

  AdminCubit(this.repo) : super(AdminInitial());

  Future<void> addPlace(PlaceModel place) async {
    emit(AdminLoading());
    try {
      await repo.addPlace(place);
      emit(AdminSuccess());
    } catch (e) {
      emit(AdminError(e.toString()));
    }
  }
  Future<void> addExperience(String placeId, ExperienceModel experienceModel) async {
    emit(AdminLoading());
    try {
      await repo.addExperience(placeId, experienceModel);
      emit(AdminSuccess());
    } catch (e) {
      emit(AdminError(e.toString()));
    }
  }
}
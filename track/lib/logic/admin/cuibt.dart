import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:track/data/models/place_model.dart';
import 'package:track/data/repositories.dart';
import 'state.dart';

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
}

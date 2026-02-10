import 'package:flutter_application_1/data/place_model.dart';
import 'package:flutter_application_1/data/services/repositories.dart';
import 'package:flutter_application_1/ligic/state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AdminCuibt extends Cubit<AdminState>{
 final Repositories repo;
  AdminCuibt(this.repo):super (AdminInitial());
  Future<void> addPlace (PlaceModel place)async{
    try{
      emit(AdminLoading());
      await repo.addPlace(place);
      emit(AdminSuccess());
    }catch(e){
      emit(AdminError(e.toString()));
    }
  }

}
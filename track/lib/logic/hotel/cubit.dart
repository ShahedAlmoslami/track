import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:track/data/models/hotelModel.dart';
import 'package:track/data/services/place_rep.dart';
import 'package:track/logic/hotel/state.dart';

class HotelCubit extends Cubit<HotelState> {
  final PlacesRepo repo;

  HotelCubit(this.repo) : super(HotelInitialstate());

  Future<String> addHotel(String cityIdDoc, HotelModel hotel) async {
    emit(HotelLoadingstate());
    try {
      final hotelId = await repo.addHotel(cityIdDoc, hotel);
      emit(HotelSuccessstate(hotel: [hotel]));
      return hotelId;
    } catch (e) {
      emit(HotelErrorstate(e.toString()));
      return '';
    }
  }

  Future<void> getHotel(String cityIdDoc, String hotelName) async {
    emit(HotelLoadingstate());
    try {
      final hotels = await repo.getHotels(cityIdDoc, hotelName);
      emit(HotelSuccessstate(hotel: hotels));
    } catch (e) {
      emit(HotelErrorstate(e.toString()));
    }
  }
}
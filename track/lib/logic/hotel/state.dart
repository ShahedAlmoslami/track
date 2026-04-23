import 'package:track/data/models/hotelModel.dart';

class HotelState{}
class HotelInitialstate extends HotelState{}
class HotelLoadingstate extends HotelState{}
class HotelSuccessstate extends HotelState{
  List<HotelModel> hotel;
  HotelSuccessstate({required this.hotel});
}
class HotelErrorstate extends HotelState{
  final String message;
  HotelErrorstate(this.message);
}
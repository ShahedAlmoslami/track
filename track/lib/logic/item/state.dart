import 'package:track/data/models/item_model.dart';

class ItemState {}
class ItemInitialState extends ItemState {}
class ItemLoadingState extends ItemState {}
class ItemSuccessState extends ItemState {
   List<MenuCategoryModel> items;
  ItemSuccessState({required this.items});
}
class ItemErrorState extends ItemState{
  final String message;
  ItemErrorState(this.message);
}
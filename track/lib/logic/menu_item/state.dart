import 'package:track/data/models/menu_item_model.dart';

class MenuItemState {}
class MenuItemInitialState extends MenuItemState {}
class MenuItemLoadingState extends MenuItemState {}
class MenuItemSuccessState extends MenuItemState {
   List<MenuItemModel> items;
  MenuItemSuccessState({required this.items});
}
class MenuItemErrorState extends MenuItemState{
  final String message;
  MenuItemErrorState(this.message);
}
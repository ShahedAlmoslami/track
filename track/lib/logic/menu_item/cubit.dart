import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:track/data/models/menu_item_model.dart';
import 'package:track/data/services/place_rep.dart';
import 'package:track/logic/item/state.dart';
import 'package:track/logic/menu_item/state.dart';

class MenuItemCubit extends Cubit<MenuItemState> {
    final PlacesRepo repo;


  MenuItemCubit(this.repo):
        super(MenuItemInitialState());

  Future<String> addItem(
    String cityDocId,
    String restaurantId,
    String itemId,
    MenuItemModel menu,
  ) async {
    try {
      emit(MenuItemLoadingState());

    final item =await repo.addMenuItem(cityDocId, restaurantId, itemId,menu);   
      // (اختياري) بعد الإضافة حمّلي القائمة من جديد
      emit(MenuItemSuccessState(items: [menu]));

      return itemId;
    } catch (e) {
      emit(MenuItemErrorState(e.toString()));
      return '';
    }
  }

  Future<List<MenuItemModel>> getMenuItems(
    String cityDocId,
    String restaurantId,
    String itemId) async {
    try {
     emit(MenuItemLoadingState());

    print('cityDocId: $cityDocId');
    print('restaurantId: $restaurantId');
    print('itemId: $itemId');
      final items= await repo.getMenuItems(cityDocId,restaurantId,itemId);
     
      
      

       emit(MenuItemSuccessState(items:items));
     
      return items;
    } catch (e) {
  print('repo error: $e');
  rethrow;
}
  }
}
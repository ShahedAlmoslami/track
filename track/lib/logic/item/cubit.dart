import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:track/data/models/item_model.dart';
import 'package:track/data/services/place_rep.dart';
import 'package:track/logic/item/state.dart';

class ItemCubit extends Cubit<ItemState> {
    final PlacesRepo repo;


  ItemCubit(this.repo):
        super(ItemInitialState());

  Future<String> addItem(
    String cityDocId,
    String restaurantId,
    MenuCategoryModel item,
  ) async {
    try {
      emit(ItemLoadingState());

    final itemId =await repo.addItem(cityDocId, restaurantId, item);   
      // (اختياري) بعد الإضافة حمّلي القائمة من جديد
      final items = await getItems(cityDocId, restaurantId,);
      emit(ItemSuccessState(items: [item]));

      return itemId;
    } catch (e) {
      emit(ItemErrorState(e.toString()));
      return '';
    }
  }

  Future<List<MenuCategoryModel>> getItems(
    String cityDocId,
    String restaurantId,) async {
    try {
     emit(ItemLoadingState());
      final items= await repo.getItems(cityDocId,restaurantId);
      
      

       emit(ItemSuccessState(items:items));
      return items;
    } catch (e) {
      emit(ItemErrorState(e.toString()));
      return [];
    }
  }
}
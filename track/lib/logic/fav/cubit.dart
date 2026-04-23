import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:track/data/models/fav.dart';
import 'package:track/logic/fav/state.dart';

class FavoriteCubit extends Cubit<FavoriteState> {
  FavoriteCubit() : super(FavoriteState(favorites: [])) {
    loadFavorites();
  }

  static const String favKey = 'favorite_items';

  Future<void> loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getStringList(favKey) ?? [];

    final favorites = data
        .map((item) => FavoriteItem.fromJson(item))
        .toList();

    emit(FavoriteState(favorites: favorites));
  }

  Future<void> toggleFavorite(FavoriteItem item) async {
    final prefs = await SharedPreferences.getInstance();
    final current = List<FavoriteItem>.from(state.favorites);

    final exists = current.any((e) => e.id == item.id);

    if (exists) {
      current.removeWhere((e) => e.id == item.id);
    } else {
      current.add(item);
    }

    final data = current.map((e) => e.toJson()).toList();
    await prefs.setStringList(favKey, data);

    emit(FavoriteState(favorites: current));
  }

  bool isFavorite(String id) {
    return state.favorites.any((e) => e.id == id);
  }
}
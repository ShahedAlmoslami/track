import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:track/logic/fav/cubit.dart';
import 'package:track/logic/fav/state.dart';
import 'package:track/presentaion/screen/details.dart';
import 'package:track/presentaion/screen/restaurant_detalies_screen.dart';
import 'package:track/presentaion/widgets/app_bottom_bar.dart';

class FavoriteScreen extends StatelessWidget {
  const FavoriteScreen({super.key, required this.id, required this.idS});
  final String id;
    final String idS;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Favorites')),
      body: BlocBuilder<FavoriteCubit, FavoriteState>(
        builder: (context, state) {
          if (state.favorites.isEmpty) {
            return const Center(
              child: Text('No favorites yet'),
            );
          }

          return ListView.builder(
            itemCount: state.favorites.length,
            itemBuilder: (context, index) {
              final item = state.favorites[index];

              return InkWell(
               onTap: () {
    final item = state.favorites[index];

    if (item.type == 'place') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => DetailsScreen(
placeId: item.idS,   
cityId: item.id,
  
   ),
        ),
      );
    } else if (item.type == 'restaurant') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => RestaurantDetaliesScreen(
            cityIdDoc:item.id, 
            imageNAme: item.image,
            resIdDoc: item.idS,
            resName: item.title,
            
            
          ),
        ),
      );
    }
  },
                child: ListTile(
                  leading: Image.network(
                    item.image,
                    width: 60,
                    height: 60,
                    fit: BoxFit.cover,
                  ),
                  title: Text(item.title),
                  trailing: IconButton(
                    onPressed: () {
                      context.read<FavoriteCubit>().toggleFavorite(item);
                    },
                    icon:  Icon(
                      Icons.favorite,
                      color: Colors.red,
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
                    bottomNavigationBar:  AppBottomBar(currentIndex: 3),

    );
  }
}
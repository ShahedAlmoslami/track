import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:track/core/theme/colors.dart';
import 'package:track/data/models/fav.dart';
import 'package:track/logic/fav/cubit.dart';

class FavoriteButton extends StatelessWidget {
  final FavoriteItem item;

  const FavoriteButton({
    super.key,
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    final isFav = context.watch<FavoriteCubit>().isFavorite(item.id);

    return Stack(
      children:[
        Container(
          height: 50,
          width: 50,
          decoration: BoxDecoration(          color: ColorManager.whiteColorIcon,
          borderRadius: BorderRadius.circular(25)
),
        )
        ,Center(
          child: IconButton(
          onPressed: () {
            context.read<FavoriteCubit>().toggleFavorite(item);
          },
          icon: Icon(
            isFav ? Icons.favorite : Icons.favorite_border,
            color: Colors.red,
          ),
                ),
        ),]
    );
  }
}
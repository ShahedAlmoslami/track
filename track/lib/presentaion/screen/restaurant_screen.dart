import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:track/data/services/place_rep.dart';
import 'package:track/logic/restaurant/cubit.dart';
import 'package:track/logic/restaurant/state.dart';
import 'package:track/presentaion/screen/restaurant_detalies_screen.dart';
import 'package:track/presentaion/widgets/app_bottom_bar.dart';
import 'package:track/presentaion/widgets/back_arrow.dart';
import 'package:track/presentaion/widgets/resturant.dart';

class RestaurantScreen extends StatefulWidget {
  final String cityId;

  RestaurantScreen({
    super.key,
    required this.cityId,
  });

  @override
  State<RestaurantScreen> createState() => _RestaurantScreenState();
}

class _RestaurantScreenState extends State<RestaurantScreen> {
  final String restaurantName = 'restaurant';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RestaurantCubit(PlacesRepo())
        ..getRestaurant(widget.cityId),
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(top: 16.0, left: 16.0, right: 16.0),
            child: Column(
              children: [
                SizedBox(
                  height: 50,
                  child: Row(
                    children: [
                      ArrowBack(),
                      SizedBox(width: 8),
                      const Text(
                        'Restaurants',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 12),

                Expanded(
                  child: BlocBuilder<RestaurantCubit, RestaurantState>(
                    builder: (context, state) {
                      if (state is RestaurantLoadingstate) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      if (state is RestaurantErrorstate) {
                        return Center(child: Text(state.message));
                      }

                      if (state is RestaurantSuccessstate) {
                        if (state.restaurant.isEmpty) {
                          return const Center(child: Text('No restaurants found'));
                        }

                        return ListView.separated(
                          separatorBuilder:  (_, __) => const SizedBox(height: 20),
                          itemCount: state.restaurant.length,
                          itemBuilder: (context, index) {
                            final res = state.restaurant[index];
                            return InkWell(
                              onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (_)=>RestaurantDetaliesScreen(cityIdDoc:widget.cityId, resName: res.name,rating: "dd",imageNAme: res.imageUrl,resIdDoc: res.id,)));

                              },
                              
                              child: ResturantWidget(
                                resturantname: res.name,
                                resturantimage: res.imageUrl,
                              ),
                            );
                          },
                        );
                      }

                      return const SizedBox.shrink();
                    },
                  ),
                ),
              ],
            ),

          ),

        ),
                    bottomNavigationBar:  AppBottomBar(currentIndex:1),

      ),
      
    );
  }
}


  
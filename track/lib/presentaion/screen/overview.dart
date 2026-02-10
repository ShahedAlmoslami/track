import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:track/data/services/place_model.dart';
import 'package:track/logic/place_model/cubit.dart';
import 'package:track/logic/place_model/state.dart';
import 'package:track/presentaion/screen/details.dart';
import 'package:track/presentaion/widgets/button_over_view.dart';
import 'package:track/presentaion/widgets/place.dart';

class Overview extends StatelessWidget {
  final String cityId;
  const Overview({super.key, required this.cityId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => PlaceCubit(PlacesRepo())..getPlacesByCity(cityId),
      child: Scaffold(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 60),
            IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back),
            ),

            Expanded(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children:  [
                      OverView(
                        buttonText: "overview",
                        imageName: "assets/images/bank.png",
                      ),
                      OverView(
                        buttonText: "restaurant",
                        imageName: "assets/images/forkknife.png",
                      ),
                      OverView(
                        buttonText: "hotel",
                        imageName: "assets/images/forkknife.png",
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children:  [
                      OverView(
                        buttonText: "love",
                        imageName: "assets/images/heart.png",
                      ),
                      OverView(
                        buttonText: "book",
                        imageName: "assets/images/book.png",
                      ),
                      OverView(
                        buttonText: "Not populaar",
                        imageName: "assets/images/notpopulaar.png",
                      ),
                    ],
                  ),

                  const SizedBox(height: 80),

                  BlocBuilder<PlaceCubit, PlaceState>(
                    builder: (context, state) {
                      if (state is PlaceLoadingstate) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      } 
                      else if (state is PlaceSuccessstate) {
                        if (state.places.isEmpty) {
                          return const Center(child: Text('No places found'));
                        }

                        return SizedBox(
                          height: 304,
                          child: ListView.separated(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            scrollDirection: Axis.horizontal,
                            itemCount: state.places.length,
                            separatorBuilder: (_, __) => const SizedBox(width: 16),
                            itemBuilder: (context, index) {
                              final p = state.places[index];
                              return InkWell(
                                onTap: () {
                                  // Navigate to details screen with place ID
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => DetailsScreen(placeId: state.places[index].id),
                                    ),
                                  );
                                },
                                child: Place(
                                  placeImage: p.imageUrl,
                                  placeName: p.name,
                                  placeRating: p.rating,
                                  ticketPrice: p.price,
                                ),
                              );
                            },
                          ),
                        );
                      } else {
                        return const Center(child: Text('An error occurred'));
                      }
                    },
                  ),

                  const SizedBox(height: 16),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

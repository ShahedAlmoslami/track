import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:track/data/services/place_rep.dart';
import 'package:track/logic/place_model/cubit.dart';
import 'package:track/logic/place_model/state.dart';
import 'package:track/presentaion/screen/details.dart';
import 'package:track/presentaion/screen/fav_screen.dart';
import 'package:track/presentaion/screen/favorite_screen.dart';
import 'package:track/presentaion/screen/hotelScreen.dart';
import 'package:track/presentaion/screen/restaurant_screen.dart';
import 'package:track/presentaion/widgets/app_bottom_bar.dart';
import 'package:track/presentaion/widgets/back_arrow.dart';
import 'package:track/presentaion/widgets/button_over_view.dart';
import 'package:track/presentaion/widgets/place.dart';

class Overview extends StatefulWidget {
  final String cityId;

  const Overview({super.key, required this.cityId});

  @override
  State<Overview> createState() => _OverviewState();
}

class _OverviewState extends State<Overview> {
  bool isPopular = true;
  late final PlaceCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = PlaceCubit(PlacesRepo());
    _cubit.getPlaces(widget.cityId, isPopular); // أول تحميل
  }

  @override
  void dispose() {
    _cubit.close();
    super.dispose();
  }

  void _loadPopular(bool value) {
    setState(() => isPopular = value);
    _cubit.getPlaces(widget.cityId, value);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _cubit,
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.only(top: 60,),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              
             Padding(
               padding: const EdgeInsets.only(left: 16.0),
               child: ArrowBack(),
             ),
              Expanded(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        InkWell(
                          onTap: () => _loadPopular(true),
                          child: OverView(
                            buttonText: "overview",
                            imageName: "assets/images/bank.png",
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => RestaurantScreen(cityId: widget.cityId),
                              ),
                            );
                          },
                          child: OverView(
                            buttonText: "restaurant",
                            imageName: "assets/images/forkknife.png",
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    Hotelscreen(cityId: widget.cityId),
                              ),
                            );
                          },
                          child: OverView(
                            buttonText: "hotel",
                            imageName: "assets/images/forkknife.png",
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        InkWell(
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (_) => FavoriteScreen(id: '', idS: '',)),
                              );
                            },
                            child: OverView(
                              buttonText: "Love",
                              imageName: "assets/images/heart.png",
                            ),
                          ),
                        ),
                        OverView(
                          buttonText: "book",
                          imageName: "assets/images/book.png",
                        ),
                        InkWell(
                          onTap: () => _loadPopular(false),
                          child: OverView(
                            buttonText: "Not popular",
                            imageName: "assets/images/notpopulaar.png",
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 80),
          
                    BlocBuilder<PlaceCubit, PlaceState>(
                      builder: (context, state) {
                        if (state is PlaceLoadingstate) {
                          return const Center(child: CircularProgressIndicator());
                        }
          
                        if (state is PlaceSuccessstate) {
                          if (state.places.isEmpty) {
                            return Center(
                              child: Text(
                                isPopular
                                    ? 'No popular places'
                                    : 'No not-popular places',
                              ),
                            );
                          }
          
                          return SizedBox(
                            height: 304,
                            child: ListView.separated(
                              padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 16),
                              scrollDirection: Axis.horizontal,
                              itemCount: state.places.length,
                              separatorBuilder: (_, __) =>
                                  const SizedBox(width: 16),
                              itemBuilder: (context, index) {
                                final p = state.places[index];
          
                                return InkWell(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) =>
                                            DetailsScreen(placeId: p.id,cityId: widget.cityId,),
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
                        }
          
                        return Center(child: Text('An error occurred'));
                      },
                    ),
          
                    SizedBox(height: 16),
                  ],
                ),
              ),
            ],
          ),
        ),
                    bottomNavigationBar:  AppBottomBar(currentIndex:1),

      ),
    );
  }
}

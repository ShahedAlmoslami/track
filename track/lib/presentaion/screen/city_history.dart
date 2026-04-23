import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:track/data/services/place_rep.dart';
import 'package:track/logic/city/cubit.dart';
import 'package:track/logic/city/state.dart';
import 'package:track/presentaion/widgets/app_bottom_bar.dart';
import 'package:track/presentaion/widgets/back_arrow.dart';

class CityHistoryScreen extends StatefulWidget {
    final String cityId;


  const CityHistoryScreen({super.key,required this.cityId });

  @override
  State<CityHistoryScreen> createState() => _CityHistoryScreenState();
}

class _CityHistoryScreenState extends State<CityHistoryScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CityCubit(PlacesRepo())..getCities(),
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    ArrowBack(),
                    SizedBox(width: 8),
                    const Text(
                      "History",
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                Expanded(
                  child: BlocBuilder<CityCubit, CityState>(
                    builder: (context, state) {
                      if (state is CityLoading) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }

                      if (state is CityError) {
                        return Center(
                          child: Text(state.message),
                        );
                      }

                      if (state is CitySuccess) {
                        final cities = state.cities ?? [];

                        if (cities.isEmpty) {
                          return const Center(
                            child: Text('No histroy found'),
                          );
                        }

                        return  ListView.builder(
  itemCount: cities.length,
  itemBuilder: (context, index) {
    final history = cities[index];
    final images = history.imageList ?? [];
if(widget.cityId==history.id){
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            history.description ?? '',
            style: const TextStyle(fontSize: 18,
),

            
          ),
          const SizedBox(height: 12),
    
          if (images.isNotEmpty)
            SizedBox(
              height: 200,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: images.length,
                itemBuilder: (context, imageIndex) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        images[imageIndex],
                        width: 300,
                        height: 200,
                        fit: BoxFit.cover,
                      ),
                    ),
                  );
                },
              ),
            )
          else
            const SizedBox(),
        ],
      ),
    );}
  },
);
                      }

                      return const SizedBox();
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
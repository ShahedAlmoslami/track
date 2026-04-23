import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:track/core/theme/colors.dart';
import 'package:track/data/services/place_rep.dart';
import 'package:track/logic/city/cubit.dart';
import 'package:track/logic/city/state.dart';
import 'package:track/presentaion/widgets/app_bottom_bar.dart';
import 'package:track/presentaion/widgets/city_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController searchController = TextEditingController();
  String query = "";

  late final CityCubit _cityCubit;

  @override
  void initState() {
    super.initState();
    _cityCubit = CityCubit(PlacesRepo())..getCities();
  }

  @override
  void dispose() {
    searchController.dispose();
    _cityCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _cityCubit,
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 40),

              // Search
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: SizedBox(
                  height: 55,
                  child: TextField(
                    controller: searchController,
                    onChanged: (value) => setState(() => query = value),
                    decoration: InputDecoration(
                      hintText: 'Search',
                      hintStyle: const TextStyle(color: ColorManager.prymaryColor,fontSize: 20,fontWeight: FontWeight.bold),
                      prefixIcon: const Icon(Icons.search, color: ColorManager.prymaryColor,size: 32,),
                      filled: true,
                      fillColor: ColorManager.secondaryColor,
                      contentPadding: const EdgeInsets.symmetric(vertical: 16),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(32),
                        borderSide: BorderSide.none,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(32),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(32),
                        borderSide: BorderSide.none,
                      ),
                      suffixIcon: query.isEmpty
                          ? null
                          : IconButton(
                              onPressed: () {
                                searchController.clear();
                                setState(() => query = "");
                              },
                              icon: const Icon(Icons.close),
                            ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 10),

              // List from DB
              Expanded(
                child: BlocBuilder<CityCubit, CityState>(
                  builder: (context, state) {
                    if (state is CityLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (state is CityError) {
                      return Center(child: Text(state.message));
                    }

                    if (state is CitySuccess) {
                      final q = query.toLowerCase().trim();

                      final cities = state.cities ?? [];

                      final filtered = q.isEmpty
                          ? cities
                          : cities.where((c) {
                              final name = (c.name ).toLowerCase(); 
                              return name.contains(q);
                            }).toList();

                      if (filtered.isEmpty) {
                        return const Center(child: Text('No cities found'));
                      }

                      return ListView.separated(
                        padding: EdgeInsets.zero,
                        itemCount: filtered.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 5),
                        itemBuilder: (context, index) {
                          final city = filtered[index];
                          return CityWidget(
                            imageName: city.coverImage , 
                            cityName: city.name ,        
                            cityId: city.id ?? '',           
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
              bottomNavigationBar:  AppBottomBar(currentIndex: 0),

      ),
    );
  }
}
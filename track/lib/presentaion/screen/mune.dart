import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:track/core/theme/colors.dart';
import 'package:track/data/services/place_rep.dart';
import 'package:track/logic/menu_item/cubit.dart';
import 'package:track/logic/menu_item/state.dart';
import 'package:track/presentaion/widgets/app_bottom_bar.dart';
import 'package:track/presentaion/widgets/back_arrow.dart';
import 'package:track/presentaion/widgets/dish.dart';

class MuneDeatiels extends StatefulWidget {
  final String cityId;
  final String resId;
  final String item;

  const MuneDeatiels({
    super.key,
    required this.cityId,
    required this.resId,
    required this.item,
  });

  @override
  State<MuneDeatiels> createState() => _MuneDeatielsState();
}

class _MuneDeatielsState extends State<MuneDeatiels> {
  late final MenuItemCubit _menuItemCubit;
  final TextEditingController _searchController = TextEditingController();

  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _menuItemCubit = MenuItemCubit(PlacesRepo())
      ..getMenuItems(widget.cityId, widget.resId, widget.item);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _menuItemCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _menuItemCubit,
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding:  EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                   SizedBox(height: 20),
                  ArrowBack(),
                    SizedBox(height: 20),
                  // Search Field
                  Container(
                    height: 52,
                    decoration: BoxDecoration(
                      color:  ColorManager.secondaryColor,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: TextField(
                      controller: _searchController,
                      onChanged: (value) {
                        setState(() {
                          _searchQuery = value.toLowerCase().trim();
                        });
                      },
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Search',
                        hintStyle: const TextStyle(
                          color: Colors.white70,
                          fontSize: 20,
                        ),
                        prefixIcon: const Icon(
                          Icons.search,
                          color: Colors.white,
                          size: 30,
                        ),
                        suffixIcon: _searchQuery.isNotEmpty
                            ? IconButton(
                                onPressed: () {
                                  _searchController.clear();
                                  setState(() {
                                    _searchQuery = '';
                                  });
                                },
                                icon: const Icon(
                                  Icons.close,
                                  color: Colors.white,
                                ),
                              )
                            : null,
                        border: InputBorder.none,
                        contentPadding:
                            const EdgeInsets.symmetric(vertical: 14),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  BlocBuilder<MenuItemCubit, MenuItemState>(
                    builder: (context, state) {
                      if (state is MenuItemLoadingState) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }

                      if (state is MenuItemErrorState) {
                        return Center(
                          child: Text('Error: ${state.message}'),
                        );
                      }

                      if (state is MenuItemSuccessState) {
                        if (state.items.isEmpty) {
                          return Column(
                            children: [
                              Text(widget.cityId),
                              Text(widget.resId),
                              Text(widget.item),
                            ],
                          );
                        }

                        final filteredItems = state.items.where((dish) {
                          final name = dish.name.toLowerCase();
                          final time = (dish.deshTime ?? '').toLowerCase();

                          return name.contains(_searchQuery) ||
                              time.contains(_searchQuery);
                        }).toList();

                        if (filteredItems.isEmpty) {
                          return const Center(
                            child: Padding(
                              padding: EdgeInsets.only(top: 40),
                              child: Text(
                                'No matching dishes found',
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                          );
                        }

                        return GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: filteredItems.length,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                            childAspectRatio: 0.72,
                          ),
                          itemBuilder: (context, index) {
                            final dish = filteredItems[index];

                            return DishWidget(
                              imagename: dish.image,
                              name: dish.name,
                              price: dish.price,
                              dishTime: dish.deshTime,
                              isAvil: dish.isAvailable,
                            );
                          },
                        );
                      }

                      return const SizedBox();
                    },
                  ),
                ],
              ),
            ),
          ),
          
        ),
                            bottomNavigationBar:  AppBottomBar(currentIndex:1),

      ),
    );
  }
}
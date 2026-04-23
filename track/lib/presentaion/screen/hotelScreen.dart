import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:track/core/theme/colors.dart';
import 'package:track/data/services/place_rep.dart';
import 'package:track/logic/hotel/cubit.dart';
import 'package:track/logic/hotel/state.dart';
import 'package:track/presentaion/screen/hotelDetalisScreen.dart';
import 'package:track/presentaion/widgets/app_bottom_bar.dart';
import 'package:track/presentaion/widgets/back_arrow.dart';
import 'package:track/presentaion/widgets/hotel.dart';

class Hotelscreen extends StatefulWidget {
  final String cityId;
  final String type = 'hotel';

  Hotelscreen({super.key, required this.cityId});

  @override
  State<Hotelscreen> createState() => _HotelscreenState();
}

class _HotelscreenState extends State<Hotelscreen> {
  final TextEditingController _searchController = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          HotelCubit(PlacesRepo())..getHotel(widget.cityId, widget.type),
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 80),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children:  [
                  ArrowBack(),
                  SizedBox(width: 8),
                  Text(
                    'Hotel',
                    style: TextStyle(
                      color: ColorManager.blackColor,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // ✅ Search Field تحت Hotel
              TextField(
                controller: _searchController,
                onChanged: (val) => setState(() => _query = val.trim().toLowerCase()),
                decoration: InputDecoration(
                  hintText: 'Search',
                  hintStyle: TextStyle(
      color: ColorManager.whiteColor, // ✅ لون الـ hint
      fontSize: 16,
      fontWeight: FontWeight.w400,
    ),
                  prefixIcon: const Icon(Icons.search,color: ColorManager.whiteColorIcon,),
                  filled: true,
                  fillColor: const Color.fromRGBO(250, 218, 182, 1), // لون قريب من التصميم
                  contentPadding: const EdgeInsets.symmetric(vertical: 14),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24), // ✅ radius
                    borderSide: BorderSide.none,
                  ),
                ),
              ),

              const SizedBox(height: 14),

              Row(
                children: const [
                  Icon(Icons.location_on),
                  SizedBox(width: 6),
                  Text(
                    'hotel near you',
                    style: TextStyle(
                      color: ColorManager.blackColor,
                      fontSize: 24,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 10),

              BlocConsumer<HotelCubit, HotelState>(
                listener: (context, state) {
                  if (state is HotelErrorstate) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(state.message),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                },
                builder: (context, state) {
                  if (state is HotelLoadingstate) {
                    return const Expanded(
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }

                  if (state is HotelSuccessstate) {
                    final filtered = state.hotel.where((h) {
                      if (_query.isEmpty) return true;
                      return h.name.toLowerCase().contains(_query);
                    }).toList();

                    return Expanded(
                      child: ListView.separated(
                        itemCount: filtered.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 20),
                        itemBuilder: (context, index) {
                          final item = filtered[index];
                          return InkWell(
                            onTap:(){
                              Navigator.push(context, MaterialPageRoute(builder: (_)=>Hoteldetalisscreen(cityIdDoc: widget.cityId, hotelName: item.id,rating: "dd",imageNAme: item.imageUrl,hotelId: item.id,)));
                            },
                            child: Hotelwidget(
                              imageName: item.imageUrl,
                              price: item.priceFrom,
                              hotelName: item.name,
                              rating: item.rating,
                            ),
                          );
                        },
                      ),
                    );
                  }

                  return const SizedBox();
                },
              ),
            ],
          ),
        ),
                            bottomNavigationBar:  AppBottomBar(currentIndex:1),

      ),
    );
  }
}

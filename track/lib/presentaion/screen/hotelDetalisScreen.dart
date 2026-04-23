import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:track/core/theme/colors.dart';
import 'package:track/data/services/place_rep.dart';
import 'package:track/logic/hotel/cubit.dart';
import 'package:track/logic/hotel/state.dart';
import 'package:track/presentaion/widgets/app_bottom_bar.dart';
import 'package:track/presentaion/widgets/button_over_view.dart';
import 'package:track/presentaion/widgets/button_style.dart';
import 'package:track/presentaion/widgets/details.dart';

class Hoteldetalisscreen extends StatefulWidget {
  final String rating;
  final String? cityIdDoc;
    final String hotelId;

  final String? hotelName;
  final String imageNAme;

  const Hoteldetalisscreen({
    super.key,
    required this.rating,
    this.cityIdDoc,
    this.hotelName,
    required this.imageNAme,
    required this.hotelId
  });

  @override
  State<Hoteldetalisscreen> createState() => _HoteldetalisscreenState();
}

class _HoteldetalisscreenState extends State<Hoteldetalisscreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HotelCubit(PlacesRepo())
        ..getHotel(widget.cityIdDoc!, widget.hotelName!),
      child: Scaffold(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DetailsWidget(
              itemCount: 4,
              expName: '',
              imageName: widget.imageNAme,
              idF: widget.hotelId,
              type: 'hotel',
              idS: widget.hotelId,
            ),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      MyButtonStyle(
                        buttonHight: 50,
                        buttonWidth: 170,
                        buttonText: 'Contact Us',
                        raduis:30 ,
                      ),
                      const SizedBox(width: 4),
                      
                    ],
                  ),

                  const SizedBox(height: 10),

                  Row(
                    children: [
                      MyButtonStyle(
                        buttonHight: 50,
                        buttonWidth: 170,
                        raduis: 30,
                        buttonText: "Opening Hourse",
                      ),
                      const SizedBox(width: 10),
                      Text(
                        '10-24',
                        style: TextStyle(
                          color: ColorManager.prymaryColor,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),

                   SizedBox(height: 10),

                  MyButtonStyle(
                    buttonHight: 60,
                    buttonWidth: 314,
                    buttonText: "Get the website",
                    raduis: 30,
                  ),

                  const SizedBox(height: 10),

                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        OverView(
                          buttonText: 'Wifi',
                          buttonColor: ColorManager.prymaryColor,
                          imageName: 'assets/images/wificon.png',
                          buttonHight: 80,
                          buttonWidth: 80,
                          
                        ),
                        OverView(
                          buttonText: 'GYM',
                          buttonColor: ColorManager.prymaryColor,
                          imageName: 'assets/images/barbell.png',
                          buttonHight: 80,
                          buttonWidth: 80,
                        ),
                        OverView(
                          buttonText: 'Breakfast',
                          buttonColor: ColorManager.prymaryColor,
                          imageName: 'assets/images/bread.png',
                          buttonHight: 80,
                          buttonWidth: 80,
                        ),
                        OverView(
                          buttonText: 'Parking',
                          buttonColor: ColorManager.prymaryColor,
                          imageName: 'assets/images/car.png',
                          buttonHight: 80,
                          buttonWidth: 80,
                        ),
                      ],
                    ),
                  ),


                  // ✅ صور المنيو/صور إضافية للفندق الحالي
                  BlocBuilder<HotelCubit, HotelState>(
                    builder: (context, state) {
                      if (state is HotelLoadingstate) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (state is HotelErrorstate) {
                        return Center(child: Text(state.message));
                      } else if (state is HotelSuccessstate) {
                        if (state.hotel.isEmpty) return const SizedBox();

                        // بما ان getHotel بالاسم غالبًا بيرجع فندق واحد
                        final item = state.hotel.first;

                        // ✅ فلترة روابط الصور بشكل آمن
                        final menuImages = List<String>.from(item.imageList ?? const [])
                            .map((e) => e.trim())
                            .where((e) {
                              final u = Uri.tryParse(e);
                              return u != null &&
                                  (u.scheme == 'http' || u.scheme == 'https') &&
                                  u.host.isNotEmpty;
                            })
                            .toList();

                        if (menuImages.isEmpty) return const SizedBox();

                        // ✅ عرض أفقي للصور
                        return SizedBox(
                          height: 200,
                          child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            separatorBuilder: (_, __) => const SizedBox(width: 10),
                            itemCount: menuImages.length, // أو حد أقصى 3
                            itemBuilder: (context, i) {
                              return ClipRRect(borderRadius: BorderRadiusGeometry.circular(12),
                                child: SizedBox(
                                width: 200,
                                  child: Image.network(menuImages[i],      fit: BoxFit.cover,
),),);
                              
                            
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
          ],
        ),
                                  bottomNavigationBar:  AppBottomBar(currentIndex: 2),

      ),
    );
  }
}
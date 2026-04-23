import 'package:flutter/material.dart';
import 'package:track/core/theme/colors.dart';
import 'package:track/presentaion/screen/city_history.dart';
import 'package:track/presentaion/screen/hotelScreen.dart';
import 'package:track/presentaion/screen/overview.dart';

class CityWidget extends StatefulWidget {
  final String imageName;
  final String cityName;
  final String cityId;


  const CityWidget({
    super.key,
    required this.imageName,
    required this.cityName,
    required this.cityId,
  });
  @override
  State<CityWidget> createState() => _CityWidgetState();
}

class _CityWidgetState extends State<CityWidget> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Overview(cityId: widget.cityId,)),
        );
      },

      child: Center(
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(60),
              child: Image.network(widget.imageName, height: 240, width: 345,fit: BoxFit.cover,
)),
            Container(
              height: 240,
              width: 345,

              decoration: BoxDecoration(
                color: ColorManager.containerColor,
                borderRadius: BorderRadius.circular(60),
              ),
            ),
            Positioned.fill(
              child: Align(
                alignment: Alignment.center,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      widget.cityName,
                      style: TextStyle(
                        color: ColorManager.whiteColor,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton( 
                      icon: Image.asset('assets/images/book.png', fit: BoxFit.contain),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => CityHistoryScreen(cityId: widget.cityId)),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

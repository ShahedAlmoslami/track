import 'package:flutter/material.dart';
import 'package:track/core/theme/colors.dart';
import 'package:track/presentaion/screen/overview.dart';

class CityWidget extends StatefulWidget {
  final String imageName;
  final String cityName;

  const CityWidget({
    super.key,
    required this.imageName,
    required this.cityName,
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
          MaterialPageRoute(builder: (context) => Overview()),
        );
      },

      child: Center(
        child: Stack(
          children: [
            Image.asset(widget.imageName, height: 240, width: 345),
            Container(
              height: 240,
              width: 345,

              decoration: BoxDecoration(
                color: ColorManager.ContainerColor,
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
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Image.asset('assets/images/book.png'),
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

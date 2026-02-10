import 'package:flutter/material.dart';
import 'package:track/core/theme/colors.dart';
import 'package:track/presentaion/screen/details.dart';

class Place extends StatefulWidget {
  final String placeImage;
  final String placeName;
  final double placeRating;
  final double ticketPrice;

   Place({
    super.key,
    required this.placeImage,
    required this.placeName,
    required this.placeRating,
    required this.ticketPrice,
  });

  @override
  State<Place> createState() => _PlaceState();
}

class _PlaceState extends State<Place> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Image.network(widget.placeImage, height: 222, width: 205, fit: BoxFit.cover),
        Positioned(
          bottom: -10,
          left: 0,
          right: 0,
          child: Container(
            height: 135,
            width: 207,
            decoration: BoxDecoration(
              color: ColorManager.containerColor,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.placeName,
                    style: TextStyle(
                      color: ColorManager.whiteColor,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Row(
                    children: [
                      Icon(Icons.star, color: ColorManager.yellowColor),
                      Text(
                        widget.placeRating.toString(),
                        style: TextStyle(
                          color: ColorManager.whiteColor,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    '${widget.ticketPrice.toString()}',
                    style: TextStyle(
                      color: ColorManager.whiteColor,
                      fontSize: 16,
                    ),
                  ),
                  Image.asset("assets/images/book.png", height: 40, width: 40),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

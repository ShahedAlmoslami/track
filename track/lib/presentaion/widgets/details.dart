import 'package:flutter/material.dart';
import 'package:track/core/theme/colors.dart';
import 'package:track/data/models/fav.dart';
import 'package:track/presentaion/widgets/back_arrow.dart';
import 'package:track/presentaion/widgets/fav.dart';

class DetailsWidget extends StatefulWidget {
  DetailsWidget({
    super.key,
    this.itemCount,
    this.expName,
    this.rating,
    this.imageName,
    this.isFav,
    this.cuisiens,
    required this.idF,
    required this.idS,
    required this.type,
  });

  final int? itemCount;
  final String? expName;
  final String? imageName;
  final String? rating;
  bool? isFav = false;
  final String? cuisiens;
  final String idF;
  String type;
  String idS;

  @override
  State<DetailsWidget> createState() => _DetailsWidgetState();
}

class _DetailsWidgetState extends State<DetailsWidget> {
  @override
  Widget build(BuildContext context) {
  
    final screenWidth = MediaQuery.of(context).size.width;

    return SizedBox(
      height: 300,
      width: screenWidth,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          SizedBox(
            height: 216,
            width: screenWidth,
            child: Stack(
              children: [
                widget.imageName != null && widget.imageName!.isNotEmpty
                    ? ClipRRect(
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(30),
                          bottomRight: Radius.circular(30),
                        ),
                        child: Image.network(
                          widget.imageName!,
                          height: 250,
                          width: screenWidth,
                          fit: BoxFit.cover,
                        ),
                      )
                    : const Center(child: CircularProgressIndicator()),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ArrowBack(
                            colorManage: ColorManager.whiteColorIcon,
                            arrowColor: ColorManager.prymaryColor,
                          ),
                          FavoriteButton(
                            item: FavoriteItem(
                              id: widget.idF,
                              title: widget.expName ?? '',
                              image: widget.imageName ?? '',
                              type: widget.type,
                              idS: widget.idS,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 40),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.expName ?? '',
                            style: const TextStyle(
                              color: ColorManager.whiteColor,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Icon(
                            Icons.location_on,
                            color: ColorManager.whiteColor,
                          ),
                          const SizedBox(height: 10),
                          Text(
                            widget.cuisiens ?? '',
                            style: const TextStyle(
                              color: ColorManager.whiteColor,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Icon(
                                Icons.star,
                                color: ColorManager.yellowColor,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                widget.rating ?? '',
                                style: const TextStyle(
                                  color: ColorManager.whiteColor,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
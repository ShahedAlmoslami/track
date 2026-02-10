import 'package:flutter/material.dart';
import 'package:track/core/theme/colors.dart';

class DetailsWidget extends StatefulWidget {
   DetailsWidget({super.key, required this.itemCount, required this.detailsName,this.rating,required this.imageName});
  final int itemCount; 
  final String detailsName;
  final List<String> imageName;
  final String? rating;

  @override
  State<DetailsWidget> createState() => _DetailsWidgetState();
}

class _DetailsWidgetState extends State<DetailsWidget> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 216,
      width: 400,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          SizedBox(
              height: 216,
              width: 400,
            child: Stack(
              children: [
                widget.imageName.isNotEmpty
                    ? Image.asset(
                        widget.imageName[0],
                        height: 216,
                        width: 400,
                        fit: BoxFit.cover,
                      )
                    : CircularProgressIndicator(),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      
                        children: [
                          Container(
                            height: 50,
                            width: 50,
                            decoration: BoxDecoration(
                              color: ColorManager.whiteColorIcon,
                              borderRadius: BorderRadius.circular(25),
                              
                            ),
                            child: Icon(Icons.arrow_back, color: ColorManager.prymaryColor),
                          ),
                          Container(
                            height: 50,
                            width: 50,
                            decoration: BoxDecoration(
                              color: ColorManager.whiteColorIcon,
                              borderRadius: BorderRadius.circular(25),
                                
                            ),
                            child: Icon(Icons.favorite_border, color: ColorManager.prymaryColor),
                          ),
                        ],
                      ),
                      SizedBox(height: 40),
                      Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                        Text(widget.detailsName,
                            style: TextStyle(color: ColorManager.whiteColor,fontSize: 24, fontWeight: FontWeight.bold),),
                           Icon(Icons.location_on, color: ColorManager.whiteColor),
                           Row(
                             children: [
                               Icon(Icons.star, color: ColorManager.yellowColor),
                               SizedBox(width: 4),
                                Text(widget.rating ?? '',
                              style: TextStyle(color: ColorManager.whiteColor,fontSize: 14, fontWeight: FontWeight.w600),)
                             ],
                           ),
                           
                      ],)
                    ],
                  ),
                )
                  
              ],
            ),
          )
        ],
      
      
      ),
    );
  }
}
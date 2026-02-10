import 'package:flutter/material.dart';
import 'package:track/core/theme/colors.dart';
import 'package:track/presentaion/widgets/gallery_view.dart';

class ExperienceWidget extends StatefulWidget {
  String experience ;
     List<String> images; 
       String price ;
   ExperienceWidget({super.key, required this.images,required this.experience,required this.price});
  @override
  State<ExperienceWidget> createState() => _ExperienceWidgetState();
}

class _ExperienceWidgetState extends State<ExperienceWidget> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        
        FigmaStackGallery(images: widget.images, ),
        Positioned(
          bottom: 60,
          right: 100,
          child: Container(
            height: 63,
            width: 200,
            decoration: BoxDecoration(
              color: ColorManager.secondaryColor,
              borderRadius: BorderRadius.circular(40),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Column(
                children: [
                  Row(
                    children: [
                      Text(widget.experience,
                          style: TextStyle(color: ColorManager.whiteColor,fontSize: 16, fontWeight: FontWeight.bold),),
                           Text(widget.price,
                      style: TextStyle(color: ColorManager.whiteColor,fontSize: 16, ),),
                    ],
                  ),
                 
                      Row(
                        children: [
                          Icon(Icons.star, color: ColorManager.yellowColor),
                          Text("4.5", style: TextStyle(color: ColorManager.whiteColor,fontSize: 12, ),),
                        ],
                      ),
                     
                ],
              ),
            ),
          ),
        )
        

      ],
    );
  }
}
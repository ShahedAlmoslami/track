import 'package:flutter/material.dart';
import 'package:track/core/theme/colors.dart';
import 'package:track/presentaion/screen/details.dart';

class OverView extends StatefulWidget {
    final String buttonText;
  final  bool isLoading;
  final String imageName;



   OverView({super.key,required this.buttonText,  this.isLoading=false,required this.imageName});

  @override
  State<OverView> createState() => _OverViewState();
}

class _OverViewState extends State<OverView> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        height:100,
        width: 105,
        decoration: BoxDecoration(
        color: ColorManager.prymaryColor,
        borderRadius: BorderRadius.circular(24),),
        child: Center(
          
          child:widget.isLoading? const SizedBox(height: 20,width: 20,child: CircularProgressIndicator(strokeWidth: 2,),):
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [Image.asset(widget.imageName),Text(widget.buttonText,
                        style: TextStyle(color: ColorManager.whiteColor,fontSize: 14, ),),
                        ]
          ),
        ),),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:track/core/theme/colors.dart';
import 'package:track/presentaion/screen/restaurant_screen.dart';

class OverView extends StatefulWidget {
     String buttonText;
  final  bool isLoading;
  String imageName="assets/images/google.png";


   OverView({super.key,required this.buttonText,  this.isLoading=false,required this.imageName});

  @override
  State<OverView> createState() => _OverViewState();
}

class _OverViewState extends State<OverView> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
       Navigator.push(context, MaterialPageRoute(builder: (context)=>RestaurantScreen()));

      },
      child: Padding(
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
      ),
    );
  }
}
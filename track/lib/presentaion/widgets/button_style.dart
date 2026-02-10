import 'package:flutter/material.dart';
import 'package:track/core/theme/colors.dart';


class MyButtonStyle extends StatefulWidget {
  final Color buttonColor =ColorManager.prymaryColor;
  final String buttonText;
  double buttonHight=60;
  double buttonWidth=336;
  final  bool isLoading=false;
    MyButtonStyle({super.key,required buttonHight,required buttonWidth,required this.buttonText, isLoading});
  



  @override
  State<MyButtonStyle> createState() => _MyButtonStyleState();
}

class _MyButtonStyleState extends State<MyButtonStyle> {
  
  @override
  Widget build(BuildContext context) {

    return Container(
      height: widget.buttonHight,
      width: widget.buttonWidth,
      decoration: BoxDecoration(
      color: widget.buttonColor,
      borderRadius: BorderRadius.circular(15),


      ),
      child: Center(
        
        child:widget.isLoading? const SizedBox(height: 20,width: 20,child: CircularProgressIndicator(strokeWidth: 2,),):
        Text(widget.buttonText,
                    style: TextStyle(color: ColorManager.whiteColor,fontSize: 20, ),),
      ),

    );
  }
}
import 'package:flutter/material.dart';
import 'package:track/core/theme/colors.dart';


class ButtonwithRow extends StatefulWidget {
  final Color buttonColor =ColorManager.prymaryColor;
  final String buttonText;
  double? buttonHight;
  double? buttonWidth;
  final  bool isLoading=false;
   final  String buttonIcon;


    ButtonwithRow({super.key,required this.buttonHight,required this.buttonWidth,required this.buttonText, isLoading, this.buttonIcon='assets/images/airplane.png'});
  



  @override
  State<ButtonwithRow> createState() => _ButtonwithRowState();
}

class _ButtonwithRowState extends State<ButtonwithRow> {
  
  @override
  Widget build(BuildContext context) {

    return Container(
      height: widget.buttonHight??60,
      width: widget.buttonWidth??336,
      decoration: BoxDecoration(
      color: widget.buttonColor,
      borderRadius: BorderRadius.circular(30),


      ),
      child: Center(
        
        child:widget.isLoading? const SizedBox(height: 20,width: 20,child: CircularProgressIndicator(strokeWidth: 2,),):
        Padding(
          padding: const EdgeInsets.all(4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children:[ 
Icon(Icons.airplanemode_active,color: Colors.white,size: 32,)             , 
               SizedBox(width: 4,),
          
              Text(widget.buttonText,
                        style: TextStyle(color: ColorManager.whiteColor,fontSize: 20, fontWeight: FontWeight.bold),),
                        ]
          ),
        ),
      ),

    );
  }
}
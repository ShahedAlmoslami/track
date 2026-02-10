import 'package:flutter/material.dart';
import 'package:track/core/theme/colors.dart';


class ButtonwithRow extends StatefulWidget {
  final Color buttonColor =ColorManager.prymaryColor;
  final String buttonText;
  double buttonHight=60;
  double buttonWidth=336;
  final  bool isLoading=false;
    ButtonwithRow({super.key,required buttonHight,required buttonWidth,required this.buttonText, isLoading});
  



  @override
  State<ButtonwithRow> createState() => _ButtonwithRowState();
}

class _ButtonwithRowState extends State<ButtonwithRow> {
  
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
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children:[ 
              Image.asset('assets/images/airplane.png'),
               SizedBox(width: 8,),
          
              Text(widget.buttonText,
                        style: TextStyle(color: ColorManager.whiteColor,fontSize: 20, ),),
                        ]
          ),
        ),
      ),

    );
  }
}
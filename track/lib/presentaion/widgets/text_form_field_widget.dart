import 'package:flutter/material.dart';
import 'package:track/core/theme/colors.dart';

class TextFormFieldWidget extends StatefulWidget {
   String ?hintText;
  final TextEditingController controller ;
   double ?hight;
     double? width;
   TextFormFieldWidget({super.key, this.hintText,required this.controller,this.hight,this.width});

  @override
  State<TextFormFieldWidget> createState() => _TextFormFieldWidgetState();
}

class _TextFormFieldWidgetState extends State<TextFormFieldWidget> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height:widget.hight,
      width: widget.width,
      child: TextFormField(
      
        
          controller: widget.controller,
          style: TextStyle(color:ColorManager.whiteColor)
          ,decoration: InputDecoration(
            fillColor: ColorManager.prymaryColor,
            filled: true,
            hintText:widget.hintText, 
            hintStyle: TextStyle(color: ColorManager.whiteColor),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: ColorManager.prymaryColor,width: 2),
              borderRadius: BorderRadius.circular(30)
            ),
             focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15),
             borderSide: BorderSide(color: ColorManager.prymaryColor,width: 2),                                   )
          ),
          
      ),
    );
    
}}
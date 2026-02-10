import 'package:flutter/material.dart';
import 'package:track/core/theme/colors.dart';

class TextFormFieldWidget extends StatefulWidget {
  final String hintText;
  final TextEditingController controller ;
  final double hight=60;
    final double width=329;


  const TextFormFieldWidget({super.key,required this.hintText,required this.controller,});

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
          style: TextStyle(color:ColorManager.blackColor)
          ,decoration: InputDecoration(
          
            fillColor: ColorManager.whiteColor,
            filled: true,
            hintText:widget.hintText, 
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: ColorManager.prymaryColor,width: 2),
              borderRadius: BorderRadius.circular(15)
            ),
             focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15),
             borderSide: BorderSide(color: ColorManager.prymaryColor,width: 2),                                   )
          ),
          
      ),
    );
    
}}
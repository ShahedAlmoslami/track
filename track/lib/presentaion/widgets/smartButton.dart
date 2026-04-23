import 'package:flutter/material.dart';
import 'package:track/core/theme/colors.dart';

class Smartbutton extends StatefulWidget {
     bool forDetails=false;
     String ?buttonName;

   Smartbutton({super.key,required this.forDetails,required this.buttonName});

  @override
  State<Smartbutton> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<Smartbutton> {
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeInOut,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color:widget. forDetails ? ColorManager.secondaryColor : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color:widget. forDetails ? ColorManager.secondaryColor : Colors.grey.shade300,
        ),
        boxShadow:widget. forDetails
            ? [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                )
              ]
            : [],
      ),
      child: AnimatedDefaultTextStyle(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
        style: TextStyle(
          fontSize: 16,
          fontWeight:widget. forDetails ? FontWeight.w700 : FontWeight.w500,
          color:widget. forDetails ? Colors.white : Colors.black,
        ),
        child: const Text('buttonName'),
      ),
    );

  }
}
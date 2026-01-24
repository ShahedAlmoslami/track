import 'package:flutter/material.dart';
import 'package:track/core/theme/colors.dart';

class SearchWidget extends StatefulWidget {
  final String hintText;
  final  TextEditingController controller ;
    double hight;
    double width;

   SearchWidget({super.key,required this.hintText,required this.controller,required this.hight,required this.width});

  @override
  State<SearchWidget> createState() => _SearchWidgetState();
}

class _SearchWidgetState extends State<SearchWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body:Column(
      
    ),)
    ;
  }
}
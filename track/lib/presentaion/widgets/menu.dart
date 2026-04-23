import 'package:flutter/material.dart';
import 'package:track/core/theme/colors.dart';

class Menu extends StatefulWidget {
  String menu;
  final String images;
  

   Menu({super.key, required this.menu, required this.images});

  @override
  State<Menu> createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ClipRRect(
                borderRadius: BorderRadius.circular(15),

          child: Image.network(
            widget.images,
            height: 150,
            width: 150,
            fit: BoxFit.cover,
          
            
          ),
        ),
        Positioned(
          bottom: 30
          ,
          left: 0,
          right: 0,
          child: Container(
            height: 42,
            width: 150,
          decoration:   BoxDecoration(
      
      borderRadius: BorderRadius.circular(15),
           
            color: ColorManager.menuColor,),
            child: Center(
              child: Text(
                widget.menu,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
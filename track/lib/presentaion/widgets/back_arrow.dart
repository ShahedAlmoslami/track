import 'package:flutter/material.dart';
import 'package:track/core/theme/colors.dart';

class ArrowBack extends StatelessWidget {
  Color? colorManage;
  Color? arrowColor;

  ArrowBack({
    super.key,
    this.colorManage = ColorManager.prymaryColor,
    this.arrowColor = ColorManager.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: 50,
      decoration: BoxDecoration(
        color: colorManage,
        borderRadius: BorderRadius.circular(25),
      ),
      child: IconButton(
        icon: Icon(Icons.arrow_back, size: 24, color: arrowColor),
        onPressed: () => Navigator.pop(context),
      ),
    );
  }
}

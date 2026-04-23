import 'package:flutter/material.dart';
import 'package:track/core/theme/colors.dart';

class MyButtonStyle extends StatefulWidget {
  final Color buttonColor = ColorManager.prymaryColor;
  final String buttonText;
  final double buttonHight;
  final double buttonWidth;
  final bool isLoading = false;
  double? raduis;
  MyButtonStyle({
    super.key,
    required this.buttonHight,
    required this.buttonWidth,
    required this.buttonText,
    isLoading,
    this.raduis,
  });
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
        borderRadius: BorderRadius.circular(widget.raduis ?? 15),
      ),
      child: Center(
        child: widget.isLoading
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : Center(
                child: Text(
                  widget.buttonText,
                  style: TextStyle(
                    color: ColorManager.whiteColor,
                    fontSize: 20,
                  ),
                ),
              ),
      ),
    );
  }
}

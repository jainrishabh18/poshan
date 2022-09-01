import 'package:flutter/material.dart';
import 'package:poshan/constants/constant_colors.dart';

class CustomButton extends StatelessWidget {
  String text;
  dynamic Function()? onTap;
  double fontSize;

  CustomButton({required this.text, required this.onTap, this.fontSize = 25.0});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: width / 40.0,
          horizontal: width / 6.0,
        ),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(
              width / 30.0,
            ),
            border: Border.all(color: ConstantColors.BLACK)),
        child: Text(
          text,
          style: TextStyle(
            color: ConstantColors.BLACK,
            fontSize: fontSize,
          ),
        ),
      ),
    );
  }
}

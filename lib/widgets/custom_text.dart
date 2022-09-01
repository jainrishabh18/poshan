import 'package:flutter/material.dart';
import 'package:poshan/constants/constant_colors.dart';

class CustomText extends StatelessWidget {
  final String text;
  final bool isRequired;
  final bool isBold;
  final double fontSize;

  CustomText(
      {required this.text,
        required this.isRequired,
        this.isBold = true,
        this.fontSize = 20,
      });

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        text: text,
        style: TextStyle(
          color: ConstantColors.BLACK,
          fontSize: fontSize,
          fontWeight: isBold ? FontWeight.w600 : null,
        ),
        children: [
          isRequired
              ? const TextSpan(
            text: ' *',
            style: TextStyle(
              color: ConstantColors.RED,
            ),
          )
              : const TextSpan(),
        ],
      ),
    );
  }
}

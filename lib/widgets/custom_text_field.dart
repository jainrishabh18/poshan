import 'package:flutter/material.dart';
import 'package:poshan/constants/constant_colors.dart';

class AuthTextField extends StatelessWidget {

  final TextEditingController controller;
  final String hintText;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;
  final Widget? suffixIcon;
  final Color borderColor;
  final bool obscureText;

  AuthTextField({
    required this.controller,
    required this.hintText,
    required this.keyboardType,
    required this.validator,
    this.borderColor = Colors.black,
    this.obscureText = false,
    this.suffixIcon,
  });

  // const AuthTextField({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      decoration: new InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(
            color: ConstantColors.GREY,
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: borderColor,
            ),
            borderRadius: BorderRadius.circular(10.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: borderColor,
            ),
            borderRadius: BorderRadius.circular(10.0),
          ),
          errorBorder: OutlineInputBorder(
            borderSide: BorderSide(),
            borderRadius: BorderRadius.circular(10.0),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderSide: BorderSide(),
            borderRadius: BorderRadius.circular(10.0),
          ),
          suffixIcon: suffixIcon
      ),
      keyboardType: keyboardType,
      style: new TextStyle(
        color: ConstantColors.BLACK,
        fontWeight: FontWeight.w400,
      ),
      validator: validator,
    );
  }
}

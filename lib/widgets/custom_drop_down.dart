import 'package:flutter/material.dart';
import 'package:poshan/constants/constant_colors.dart';

class CustomDropDown extends StatelessWidget {

  final String? value, labelText;
  final List<String> items;
  final Function(String?)? onChanged;
  final String? Function(String?)? validator;
  final bool isExpanded;
  final Color borderColor;

  CustomDropDown(
      {required this.value,
        required this.labelText,
        required this.items,
        required this.onChanged,
        required this.validator,
        this.isExpanded = true,
        this.borderColor = ConstantColors.GREY});

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField(
      value: value == '' ? null : value,
      isExpanded: isExpanded,
      items: items.toSet().toList().map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value,),
        );
      }).toList(),
      onChanged: onChanged,
      decoration: InputDecoration(
        hintText: labelText,
        hintStyle: const TextStyle(
            color: ConstantColors.GREY,
            fontWeight: FontWeight.w400,
            fontFamily: 'RedHatDisplay'
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: borderColor,),
          borderRadius: BorderRadius.circular(10.0,),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: borderColor,),
          borderRadius: BorderRadius.circular(10.0,),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: ConstantColors.RED,),
          borderRadius: BorderRadius.circular(10.0,),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: ConstantColors.RED,
          ),
          borderRadius: BorderRadius.circular(10.0,),
        ),
      ),
      validator: validator,
    );
  }
}

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

class Utils {

  String getDateTimeFormString(String date) {
    DateTime dateTime = DateFormat('ddMMyyyy').parse(date);
    return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
  }

  void showToast(String msg) {
    Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

}

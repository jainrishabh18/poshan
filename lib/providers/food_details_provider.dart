import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:poshan/models/food_details.dart';

class FoodDetailsProvider extends ChangeNotifier {

  List<Parsed> _foodDetails = [];

  void setFoodDetails(Parsed foodDetails) {
    _foodDetails.add(foodDetails);
    notifyListeners();
  }

  void removeFoodDetailsAt(int index) {
    _foodDetails.removeAt(index);
    notifyListeners();
  }

  double getTotalCalories() {
    double calorie = 0;
    _foodDetails.forEach((element) {
      calorie += element.food.nutrients.enercKcal;
    });
    return calorie;
  }

  List<Parsed> getFoodDetails() {
    return _foodDetails;
  }

}

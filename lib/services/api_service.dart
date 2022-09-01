import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:poshan/models/food_details.dart';

class ApiService {

  Future<FoodDetails> getFoodDetails(String foodName) async {
    Uri url = Uri.parse('https://api.edamam.com/api/food-database/v2/parser?app_id=de1d08c1&app_key=1a558a73aad54663743e3127c1066da9&ingr=$foodName&cuisineType=Indian');
    var response = await http.get(url);
    return FoodDetails.fromJson(json.decode(response.body));
  }

}

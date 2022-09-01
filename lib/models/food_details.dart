import 'dart:convert';

FoodDetails foodDetailsFromJson(String str) => FoodDetails.fromJson(json.decode(str));

String foodDetailsToJson(FoodDetails data) => json.encode(data.toJson());

class FoodDetails {
  FoodDetails({
    required this.text,
    required this.parsed,
  });

  String text;
  List<Parsed> parsed;

  factory FoodDetails.fromJson(Map<String, dynamic> json) => FoodDetails(
    text: json["text"],
    parsed: List<Parsed>.from(json["parsed"].map((x) => Parsed.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "text": text,
    "parsed": List<dynamic>.from(parsed.map((x) => x.toJson())),
  };

  @override
  String toString() {
    return 'FoodDetails{text: $text, parsed: $parsed}';
  }

}

class Parsed {
  Parsed({
    required this.food,
  });

  Food food;

  factory Parsed.fromJson(Map<String, dynamic> json) => Parsed(
    food: Food.fromJson(json["food"]),
  );

  Map<String, dynamic> toJson() => {
    "food": food.toJson(),
  };

  @override
  String toString() {
    return 'Parsed{food: $food}';
  }

}

class Food {
  Food({
    required this.foodId,
    required this.label,
    required this.nutrients,
    required this.category,
    required this.categoryLabel,
    required this.image,
  });

  String foodId;
  String label;
  Nutrients nutrients;
  String category;
  String categoryLabel;
  String image;

  factory Food.fromJson(Map<String, dynamic> json) => Food(
    foodId: json["foodId"],
    label: json["label"],
    nutrients: Nutrients.fromJson(json["nutrients"]),
    category: json["category"],
    categoryLabel: json["categoryLabel"],
    image: json["image"],
  );

  Map<String, dynamic> toJson() => {
    "foodId": foodId,
    "label": label,
    "nutrients": nutrients.toJson(),
    "category": category,
    "categoryLabel": categoryLabel,
    "image": image,
  };

  @override
  String toString() {
    return 'Food{foodId: $foodId, label: $label, nutrients: $nutrients, category: $category, categoryLabel: $categoryLabel, image: $image}';
  }

}

class Nutrients {
  Nutrients({
    required this.enercKcal,
    required this.procnt,
    required this.fat,
    required this.chocdf,
    required this.fibtg,
  });

  double enercKcal;
  double procnt;
  double fat;
  double chocdf;
  double fibtg;

  factory Nutrients.fromJson(Map<String, dynamic> json) => Nutrients(
    enercKcal: json["ENERC_KCAL"].toDouble(),
    procnt: json["PROCNT"].toDouble(),
    fat: json["FAT"].toDouble(),
    chocdf: json["CHOCDF"].toDouble(),
    fibtg: json["FIBTG"].toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "ENERC_KCAL": enercKcal,
    "PROCNT": procnt,
    "FAT": fat,
    "CHOCDF": chocdf,
    "FIBTG": fibtg,
  };

  @override
  String toString() {
    return 'Nutrients{enercKcal: $enercKcal, procnt: $procnt, fat: $fat, chocdf: $chocdf, fibtg: $fibtg}';
  }

}

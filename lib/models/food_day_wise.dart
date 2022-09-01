class FoodDayWise {
  FoodDayWise({
    required this.name,
    required this.calorie,
    required this.protein,
    required this.imageFromApi,
  });

  String name;
  double calorie;
  double protein;
  String imageFromApi;

  factory FoodDayWise.fromJson(Map<String, dynamic> json) => FoodDayWise(
    name: json["name"],
    calorie: json["calorie"].toDouble(),
    protein: json["protein"].toDouble(),
    imageFromApi: json["imageFromApi"] == null ? '' : json["imageFromApi"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "calorie": calorie,
    "protein": protein,
    "imageFromApi": imageFromApi,
  };

  @override
  String toString() {
    return 'FoodDayWise{name: $name, calorie: $calorie, protein: $protein}';
  }

}

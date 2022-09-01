class CalorieTracker {

  double calorie;
  double protein;
  String date;

  CalorieTracker({required this.calorie, required this.protein, required this.date});

  @override
  String toString() {
    return 'CalorieTracker{calorie: $calorie, protein: $protein, date: $date}';
  }

}

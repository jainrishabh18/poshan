import 'dart:convert';

class DayAttendance {

  Map<String, Attendance> attendance = {};
  String docID = '';

  DayAttendance();

  factory DayAttendance.fromJson(Map<String, dynamic> json, String documentID) {
    DayAttendance dayAttendance = DayAttendance();
    final data = json['attendance'] as Map;
    for (final att in data.keys) {
      dayAttendance.attendance[att.toString()] = Attendance.fromJson(data[att]);
    }
    dayAttendance.docID = documentID;
    return dayAttendance;
  }

  Map<String, dynamic> toJson() => {
    "attendance": Map.from(attendance).map((k, v) => MapEntry<String, dynamic>(k, v.toJson())),
  };

  int getPercentageForGraph() {
    int totalPresent = 0;
    attendance.forEach((key, value) {
      if (value.type == 1) {
        totalPresent++;
      }
    });
    return ((totalPresent / attendance.length) * 100).ceil();
  }

  @override
  String toString() {
    return 'DayAttendance{attendance: $attendance}';
  }

}

class Attendance {

  String className;
  String name;
  int type;

  Attendance({required this.className, required this.name, required this.type});

  factory Attendance.fromJson(Map<String, dynamic> json) => Attendance(
    className: json["class"],
    name: json["name"],
    type: json["type"],
  );

  Map<String, dynamic> toJson() => {
    "class": className,
    "name": name,
    "type": type,
  };

  @override
  String toString() {
    return 'Attendance{className: $className, name: $name, type: $type}';
  }

}

import 'dart:convert';

Teacher teacherFromJson(String str) => Teacher.fromJson(json.decode(str));

String teacherToJson(Teacher data) => json.encode(data.toJson());

class Teacher {
  Teacher({
    required this.id,
    required this.name,
    required this.districtName,
    required this.pin,
    required this.schoolName,
    required this.stateName,
  });

  int id;
  String name;
  String districtName;
  String pin;
  String schoolName;
  String stateName;

  factory Teacher.fromJson(Map<String, dynamic> json) => Teacher(
    id: json["id"],
    name: json["name"],
    districtName: json["districtName"],
    pin: json["pin"],
    schoolName: json["schoolName"],
    stateName: json["stateName"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "districtName": districtName,
    "pin": pin,
    "schoolName": schoolName,
    "stateName": stateName,
  };

  @override
  String toString() {
    return 'Teacher{id: $id, name: $name, districtName: $districtName, pin: $pin, schoolName: $schoolName, stateName: $stateName}';
  }

}

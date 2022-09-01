import 'dart:convert';

import 'package:poshan/models/food_details.dart';
import 'package:poshan/models/teacher.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PrefsHelper {

  void saveAuthCode(int authCode) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setInt('authCode', authCode);
  }

  Future<int> getAuthCode() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    int? authCode = await preferences.getInt('authCode');
    return authCode == null ? 0 : authCode;
  }

  void saveParsedList(List<Parsed> parsedList) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('parsedList', jsonEncode(
        parsedList
            .map<Map<String, dynamic>>((parsed) => parsed.toJson())
            .toList(),
    ));
  }

  Future<List<Parsed>> getParsedList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? parsedListString = prefs.getString('parsedList') ?? null;
    if(parsedListString == null) {
      return [];
    } else {
      return (jsonDecode(parsedListString) as List<dynamic>)
          .map<Parsed>((item) => Parsed.fromJson(item))
          .toList();
    }
  }

  void removeParsedFromList(int index) async {
    List<Parsed> parsedList = await getParsedList();
    parsedList.removeAt(index);
    saveParsedList(parsedList);
  }

  void saveStateName(String stateName) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString('stateName', stateName);
  }

  Future<String> getStateName() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? stateName = await preferences.getString('stateName');
    return stateName == null ? '' : stateName;
  }

  void saveDistrictName(String districtName) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString('districtName', districtName);
  }

  Future<String> getDistrictName() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? districtName = await preferences.getString('districtName');
    return districtName == null ? '' : districtName;
  }

  void saveTeacher(Teacher teacher) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Map map = teacher.toJson();
    String json = jsonEncode(map);
    prefs.setString('teacher', json);
  }

  Future<Teacher?> getTeacher() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? teacherFromPrefs = prefs.getString('teacher');
    if (teacherFromPrefs == null) {
      return null;
    } else {
      return Teacher.fromJson(jsonDecode(teacherFromPrefs));
    }
  }

}

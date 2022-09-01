import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:poshan/models/day_attendance.dart';
import 'package:poshan/models/food_day_wise.dart';
import 'package:poshan/models/teacher.dart';
import 'package:poshan/services/prefs_helper.dart';

class FirebaseService {
  
  Future<bool> isAdminExist(String userType, String pin) async {
    var snapshot = await FirebaseFirestore.instance.collection(userType == 'Central' ? 'centralLogin' : userType == 'State' ? 'stateLogin' : 'districtLogin').where('pin', isEqualTo: pin).limit(1).get();
    if (userType == 'State') {
      PrefsHelper().saveStateName(snapshot.docs.elementAt(0).data()['state']);
    } else if (userType == 'District') {
      PrefsHelper().saveStateName(snapshot.docs.elementAt(0).data()['state']);
      PrefsHelper().saveStateName(snapshot.docs.elementAt(0).data()['district']);
    }
    return snapshot.docs.isNotEmpty;
  }
  
  Future<List<String>> getStatesList() async {
    var response = await FirebaseFirestore.instance.collection('states').get();
    List<String> states = [];
    response.docs.forEach((element) {
      states.add(element.get('name'));
    });
    return states;
  }

  Future<List<String>> getDistrictsList(String stateName) async {
    var response = await FirebaseFirestore.instance.collection('states').doc(stateName).collection('districts').get();
    List<String> districts = [];
    response.docs.forEach((element) {
      districts.add(element.get('name'));
    });
    return districts;
  }

  Future<List<String>> getSchoolsList(String stateName, String districtName) async {
    var response = await FirebaseFirestore.instance.collection('states').doc(stateName).collection('districts').doc(districtName).collection('school').get();
    List<String> schools = [];
    response.docs.forEach((element) {
      schools.add(element.get('name'));
    });
    return schools;
  }

  Future<List<DayAttendance>> getDayAttendance(String stateName, String districtName, String schoolName) async {
    var response = await FirebaseFirestore.instance.collection('states').doc(stateName).collection('districts').doc(districtName).collection('school').doc(schoolName).collection('attendance').get();
    List<DayAttendance> dayAttendanceList = [];
    if (response.docs.isEmpty) {
      return dayAttendanceList;
    } else {
      response.docs.forEach((element) {
        dayAttendanceList.add(DayAttendance.fromJson(element.data(), element.id));
      });
      return dayAttendanceList;
    }
  }

  Future<bool> isTeacherExist(String id, String pin) async {
    var response = await FirebaseFirestore.instance.collectionGroup('teachers').where('id', isEqualTo: int.parse(id)).where('pin', isEqualTo: pin).limit(1).get();
    return response.docs.isNotEmpty;
  }

  Future<Teacher> getTeacher(String id, String pin) async {
    var response = await FirebaseFirestore.instance.collectionGroup('teachers').where('id', isEqualTo: int.parse(id)).where('pin', isEqualTo: pin).limit(1).get();
    return Teacher.fromJson(response.docs.elementAt(0).data());
  }

  void saveFoodsInFirestore(String stateName, String districtName, String schoolName, List<FoodDayWise> foodDayWiseList) async {
    var response = await FirebaseFirestore.instance.collection('states').doc(stateName).collection('districts').doc(districtName).collection('school').doc(schoolName).collection('meals').doc('26032022').set({
      'food': List<dynamic>.from(foodDayWiseList.map((x) => x.toJson())),
    }, SetOptions(merge: true));
  }

  Future<Pair<List<List<FoodDayWise>>, List<String>>> getFoodDayWise(String stateName, String districtName, String schoolName) async {
    var response = await FirebaseFirestore.instance.collection('states').doc(stateName).collection('districts').doc(districtName).collection('school').doc(schoolName).collection('meals').get();
    List<List<FoodDayWise>> mainList = [];
    List<String> docIds = [];
    response.docs.forEach((element) {
      Map<String, dynamic>? json = element.data();
      List<FoodDayWise> list = List<FoodDayWise>.from(json["food"].map((x) => FoodDayWise.fromJson(x)));
      mainList.add(list);
    });
    response.docs.forEach((element) {
      docIds.add(element.id);
    });
    return Pair(mainList, docIds);
  }
  
}

class Pair<T1, T2> {
  final T1 a;
  final T2 b;

  Pair(this.a, this.b);
}

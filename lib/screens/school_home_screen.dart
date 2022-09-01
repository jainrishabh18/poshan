import 'package:date_picker_timeline/date_picker_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:poshan/constants/constant_colors.dart';
import 'package:poshan/handlers/auth_handler.dart';
import 'package:poshan/models/teacher.dart';
import 'package:poshan/screens/manage_attendance_screen.dart';
import 'package:poshan/screens/nutrition_screen.dart';
import 'package:poshan/screens/school_login_screen.dart';
import 'package:poshan/services/prefs_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SchoolHomeScreen extends StatefulWidget {
  const SchoolHomeScreen({Key? key}) : super(key: key);

  @override
  State<SchoolHomeScreen> createState() => _SchoolHomeScreenState();
}

class _SchoolHomeScreenState extends State<SchoolHomeScreen> {
  DateTime? _selectedDate;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: ConstantColors.WHITE,
        title: const Text(
          'Today',
          style: TextStyle(
            color: ConstantColors.BLACK,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () async {
              SharedPreferences sharedPrefs = await SharedPreferences.getInstance();
              sharedPrefs.clear();
              Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const AuthHandler()), (Route<dynamic> route) => false);
            },
            child: const Text(
              'Logout',
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: width * 0.01, vertical: height * 0.02),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FutureBuilder(
                future: PrefsHelper().getTeacher(),
                builder: (_, snapshot) {
                  Teacher teacher = snapshot.data as Teacher;
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else {
                    return Text(
                      teacher.schoolName,
                      style: const TextStyle(
                        color: ConstantColors.BLACK,
                        fontSize: 25.0,
                      ),
                    );
                  }
                },
              ),
              SizedBox(
                height: width / 30.0,
              ),
              DatePicker(
                DateTime.now(),
                height: height * 0.15,
                initialSelectedDate: DateTime.now(),
                selectionColor: ConstantColors.RED,
                selectedTextColor: Colors.white,
                onDateChange: (date) {
                  setState(() {
                    _selectedDate = date;
                  });
                },
              ),
              SizedBox(
                height: width / 30.0,
              ),
              FutureBuilder(
                future: PrefsHelper().getTeacher(),
                builder: (_, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else {
                    Teacher teacher = snapshot.data as Teacher;
                    return Text(
                      teacher.schoolName,
                      style: const TextStyle(
                        color: ConstantColors.BLACK,
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    );
                  }
                },
              ),
              SizedBox(
                height: width / 30.0,
              ),
              Card(
                elevation: 3.0,
                child: ListTile(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => NutritionScreen()));
                  },
                  leading: FaIcon(
                    FontAwesomeIcons.bowlFood,
                    color: ConstantColors.RED,
                    size: width / 10.0,
                  ),
                  title: Text(
                    'Nutrition',
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(
                    'Take upto 700 Cal',
                  ),
                  trailing: IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.add_box_rounded,
                      color: ConstantColors.RED,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: width / 30.0,
              ),
              Card(
                elevation: 3.0,
                child: ListTile(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const ManageAttendanceScreen()));
                  },
                  leading: Icon(
                    Icons.person,
                    size: width / 10.0,
                    color: ConstantColors.RED,
                  ),
                  title: Text(
                    'Manage Attendance',
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(
                    'Mark student attendance',
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

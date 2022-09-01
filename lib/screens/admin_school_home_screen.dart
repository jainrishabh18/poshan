import 'package:flutter/material.dart';
import 'package:poshan/constants/constant_colors.dart';
import 'package:poshan/models/calorie_tracker.dart';
import 'package:poshan/models/day_attendance.dart';
import 'package:poshan/models/food_day_wise.dart';
import 'package:poshan/services/firebase_service.dart';
import 'package:poshan/services/prefs_helper.dart';
import 'package:poshan/services/utils.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class AdminSchoolHomeScreen extends StatefulWidget {

  String schoolName;

  AdminSchoolHomeScreen({required this.schoolName});

  // const AdminSchoolHomeScreen({Key? key}) : super(key: key);

  @override
  State<AdminSchoolHomeScreen> createState() => _AdminSchoolHomeScreenState();
}

class _AdminSchoolHomeScreenState extends State<AdminSchoolHomeScreen> {

  String stateName = '', districtName = '';
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    getFromSharedPreferences();
  }

  void getFromSharedPreferences() {
    setState(() {
      isLoading = true;
    });
    PrefsHelper().getStateName().then((state) {
      setState(() {
        stateName = state;
      });
      PrefsHelper().getDistrictName().then((district) {
        setState(() {
          districtName = district;
          isLoading = false;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: ConstantColors.WHITE,
        iconTheme: const IconThemeData(
          color: ConstantColors.BLACK,
        ),
        title: Text(
          widget.schoolName,
          style: const TextStyle(
            color: ConstantColors.BLACK,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        child: isLoading ? const Center(
          child: CircularProgressIndicator(),
        ) : SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: width * 0.01, vertical: height * 0.02),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FutureBuilder(
                  future: FirebaseService().getDayAttendance(stateName, districtName, widget.schoolName),
                  builder: (_, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    } else {
                      List<DayAttendance> dayAttendanceList = snapshot.data as List<DayAttendance>;
                      return SfCartesianChart(
                        enableSideBySideSeriesPlacement: true,
                        primaryXAxis: CategoryAxis(
                          title: AxisTitle(
                            text: 'Percentage',
                            textStyle: const TextStyle(
                              color: ConstantColors.BLACK,
                            ),
                          ),
                        ),
                        title: ChartTitle(
                          text: 'Attendance Report',
                          textStyle: const TextStyle(
                            color: ConstantColors.BLACK,
                          ),
                        ),
                        onDataLabelRender: (DataLabelRenderArgs args) {
                          args.textStyle = const TextStyle(
                            color: ConstantColors.BLACK,
                          );
                        },
                        series: <AreaSeries<DayAttendance, String>>[
                          AreaSeries<DayAttendance, String>(
                            // color: Color(0xff2658e5),
                            gradient: LinearGradient(
                              colors: [
                                Colors.red,
                                Colors.red[200]!,
                                Colors.red[50]!,
                              ],
                              stops: [0.0, 0.5, 1.0],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            ),
                            borderColor: Colors.red,
                            borderWidth: 2.0,
                            dataSource: dayAttendanceList,
                            xValueMapper: (DayAttendance dayAttendance, _) => '${dayAttendance.docID.substring(0, 2)}/${dayAttendance.docID.substring(2, 4)}/${dayAttendance.docID.substring(4)}',
                            yValueMapper: (DayAttendance dayAttendance, _) => dayAttendance.getPercentageForGraph(),
                            dataLabelSettings: DataLabelSettings(isVisible: true),
                          )
                        ],
                      );
                    }
                  },
                ),
                FutureBuilder(
                  future: FirebaseService().getFoodDayWise(stateName, districtName, widget.schoolName),
                  builder: (_, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    } else {
                      Pair<List<List<FoodDayWise>>, List<String>> data = snapshot.data as Pair<List<List<FoodDayWise>>, List<String>>;
                      List<CalorieTracker> calorieTrackerList = [];
                      for (int i = 0; i < data.a.length; i++) {
                        double calorie = 0;
                        double protein = 0;
                        for (FoodDayWise foodDayWise in data.a.elementAt(i)) {
                          calorie += foodDayWise.calorie;
                          protein += foodDayWise.protein;
                        }
                        calorieTrackerList.add(CalorieTracker(calorie: calorie, protein: protein, date: data.b.elementAt(i)));
                      }
                      return SfCartesianChart(
                        enableSideBySideSeriesPlacement: true,
                        primaryXAxis: CategoryAxis(
                          title: AxisTitle(
                            text: 'Calorie',
                            textStyle: const TextStyle(
                              color: ConstantColors.BLACK,
                            ),
                          ),
                        ),
                        title: ChartTitle(
                          text: 'Calorie Report',
                          textStyle: const TextStyle(
                            color: ConstantColors.BLACK,
                          ),
                        ),
                        onDataLabelRender: (DataLabelRenderArgs args) {
                          args.textStyle = const TextStyle(
                            color: ConstantColors.BLACK,
                          );
                        },
                        series: <LineSeries<CalorieTracker, String>>[
                          LineSeries<CalorieTracker, String>(
                            dataSource: calorieTrackerList,
                            xValueMapper: (CalorieTracker calorieTracker, _) => '${calorieTracker.date.substring(0, 2)}/${calorieTracker.date.substring(2, 4)}/${calorieTracker.date.substring(4)}',
                            yValueMapper: (CalorieTracker calorieTracker, _) => calorieTracker.calorie,
                            dataLabelSettings: DataLabelSettings(isVisible: true),
                          )
                        ],
                      );
                    }
                  },
                ),
                FutureBuilder(
                  future: FirebaseService().getFoodDayWise(stateName, districtName, widget.schoolName),
                  builder: (_, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    } else {
                      Pair<List<List<FoodDayWise>>, List<String>> data = snapshot.data as Pair<List<List<FoodDayWise>>, List<String>>;
                      List<CalorieTracker> calorieTrackerList = [];
                      for (int i = 0; i < data.a.length; i++) {
                        double calorie = 0;
                        double protein = 0;
                        for (FoodDayWise foodDayWise in data.a.elementAt(i)) {
                          calorie += foodDayWise.calorie;
                          protein += foodDayWise.protein;
                        }
                        calorieTrackerList.add(CalorieTracker(calorie: calorie, protein: protein, date: data.b.elementAt(i)));
                      }
                      return SfCartesianChart(
                        enableSideBySideSeriesPlacement: true,
                        primaryXAxis: CategoryAxis(
                          title: AxisTitle(
                            text: 'Protein',
                            textStyle: const TextStyle(
                              color: ConstantColors.BLACK,
                            ),
                          ),
                        ),
                        title: ChartTitle(
                          text: 'Protein Report',
                          textStyle: const TextStyle(
                            color: ConstantColors.BLACK,
                          ),
                        ),
                        onDataLabelRender: (DataLabelRenderArgs args) {
                          args.textStyle = const TextStyle(
                            color: ConstantColors.BLACK,
                          );
                        },
                        series: <LineSeries<CalorieTracker, String>>[
                          LineSeries<CalorieTracker, String>(
                            dataSource: calorieTrackerList,
                            xValueMapper: (CalorieTracker calorieTracker, _) => '${calorieTracker.date.substring(0, 2)}/${calorieTracker.date.substring(2, 4)}/${calorieTracker.date.substring(4)}',
                            yValueMapper: (CalorieTracker calorieTracker, _) => calorieTracker.protein,
                            dataLabelSettings: DataLabelSettings(isVisible: true),
                          )
                        ],
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

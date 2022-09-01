import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:poshan/constants/constant_colors.dart';
import 'package:poshan/handlers/auth_handler.dart';
import 'package:poshan/models/day_attendance.dart';
import 'package:poshan/screens/district_home_screen.dart';
import 'package:poshan/services/firebase_service.dart';
import 'package:poshan/services/prefs_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StateHomeScreen extends StatefulWidget {
  const StateHomeScreen({Key? key}) : super(key: key);

  @override
  State<StateHomeScreen> createState() => _StateHomeScreenState();
}

class _StateHomeScreenState extends State<StateHomeScreen> {

  String stateName = '';
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    getStateNameFromPrefs();
  }

  void getStateNameFromPrefs() {
    setState(() {
      isLoading = true;
    });
    PrefsHelper().getStateName().then((value) {
      setState(() {
        stateName = value;
        isLoading = false;
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
        title: FutureBuilder(
          future: PrefsHelper().getStateName(),
          builder: (_, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else {
              return Text(
                snapshot.data as String,
                style: const TextStyle(
                  color: ConstantColors.BLACK,
                  fontSize: 25.0,
                  fontWeight: FontWeight.bold,
                ),
              );
            }
          },
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
                  future: FirebaseService().getDistrictsList(stateName),
                  builder: (_, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    } else {
                      List<String> districtsList = snapshot.data as List<String>;
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Districts',
                            style: TextStyle(
                              color: ConstantColors.BLACK,
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Divider(
                            color: ConstantColors.BLACK,
                          ),
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: districtsList.length,
                            itemBuilder: (_, index) {
                              String districtName = districtsList.elementAt(index);
                              return Card(
                                child: ListTile(
                                  onTap: () {
                                    PrefsHelper().saveDistrictName(districtName);
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => const DistrictHomeScreen()));
                                  },
                                  title: Text(
                                    districtName,
                                  ),
                                  trailing: const Icon(
                                    Icons.arrow_forward_ios,
                                    color: ConstantColors.BLACK,
                                  ),
                                ),
                              );
                            },
                          ),
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

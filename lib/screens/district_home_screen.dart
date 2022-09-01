import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:poshan/constants/constant_colors.dart';
import 'package:poshan/handlers/auth_handler.dart';
import 'package:poshan/screens/admin_school_home_screen.dart';
import 'package:poshan/services/firebase_service.dart';
import 'package:poshan/services/prefs_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DistrictHomeScreen extends StatefulWidget {
  const DistrictHomeScreen({Key? key}) : super(key: key);

  @override
  State<DistrictHomeScreen> createState() => _DistrictHomeScreenState();
}

class _DistrictHomeScreenState extends State<DistrictHomeScreen> {

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
        title: FutureBuilder(
          future: PrefsHelper().getDistrictName(),
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
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: width * 0.01, vertical: height * 0.02),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FutureBuilder(
                  future: FirebaseService().getSchoolsList(stateName, districtName),
                  builder: (_, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    } else {
                      List<String> schoolsList = snapshot.data as List<String>;
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Schools',
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
                            itemCount: schoolsList.length,
                            itemBuilder: (_, index) {
                              String schoolName = schoolsList.elementAt(index);
                              return Card(
                                child: ListTile(
                                  onTap: () {
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => AdminSchoolHomeScreen(schoolName: schoolName,)));
                                  },
                                  title: Text(
                                    schoolName,
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

import 'package:flutter/material.dart';
import 'package:poshan/constants/constant_colors.dart';
import 'package:poshan/handlers/auth_handler.dart';
import 'package:poshan/screens/state_home_screen.dart';
import 'package:poshan/services/firebase_service.dart';
import 'package:poshan/services/prefs_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CentralHomeScreen extends StatefulWidget {
  const CentralHomeScreen({Key? key}) : super(key: key);

  @override
  State<CentralHomeScreen> createState() => _CentralHomeScreenState();
}

class _CentralHomeScreenState extends State<CentralHomeScreen> {

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
        title: const Text(
          'Central',
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
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: width * 0.01, vertical: height * 0.02),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FutureBuilder(
                  future: FirebaseService().getStatesList(),
                  builder: (_, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    } else {
                      List<String> statesList = snapshot.data as List<String>;
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'States',
                            style: TextStyle(
                              color: ConstantColors.BLACK,
                              fontSize: 25.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Divider(
                            color: ConstantColors.BLACK,
                          ),
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: statesList.length,
                            itemBuilder: (_, index) {
                              String stateName = statesList.elementAt(index);
                              return Card(
                                child: ListTile(
                                  onTap: () {
                                    PrefsHelper().saveStateName(stateName);
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => const StateHomeScreen()));
                                  },
                                  title: Text(
                                    stateName,
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

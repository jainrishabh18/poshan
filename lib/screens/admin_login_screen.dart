import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:poshan/constants/constant_colors.dart';
import 'package:poshan/screens/central_home_screen.dart';
import 'package:poshan/screens/district_home_screen.dart';
import 'package:poshan/screens/state_home_screen.dart';
import 'package:poshan/services/firebase_service.dart';
import 'package:poshan/services/prefs_helper.dart';
import 'package:poshan/widgets/custom_drop_down.dart';
import 'package:poshan/widgets/custom_text.dart';
import 'package:poshan/widgets/custom_text_field.dart';

class AdminLoginScreen extends StatefulWidget {
  const AdminLoginScreen({Key? key}) : super(key: key);

  @override
  State<AdminLoginScreen> createState() => _AdminLoginScreenState();
}

class _AdminLoginScreenState extends State<AdminLoginScreen> {
  bool isPasswordShown = true;
  String userName = '';
  TextEditingController passwordController = TextEditingController();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Admin Login',
        ),
      ),
      body: SafeArea(
        child: isLoading ? const Center(
          child: CircularProgressIndicator(),
        ) : Padding(
          padding: EdgeInsets.all(
            width / 50.0,
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(text: 'Login', isRequired: false, fontSize: 30,),
                SizedBox(
                  height: width / 10.0,
                ),
                CustomText(text: 'Select User', isRequired: false),
                CustomDropDown(
                  value: userName,
                  labelText: '',
                  borderColor: ConstantColors.BLACK,
                  items: const ['Central', 'State', 'District',],
                  onChanged: (value) {
                    setState(() {
                      userName = value!;
                    });
                  },
                  validator: (value) {},
                ),
                SizedBox(
                  height: width / 30.0,
                ),
                CustomText(text: 'Pin', isRequired: false),
                AuthTextField(
                  controller: passwordController,
                  hintText: '',
                  keyboardType: TextInputType.text,
                  obscureText: isPasswordShown,
                  suffixIcon: Padding(
                    padding: const EdgeInsets.only(right: 5.0),
                    child: IconButton(
                      onPressed: () {
                        setState(() {
                          isPasswordShown = !isPasswordShown;
                        });
                      },
                      icon: Icon(
                        isPasswordShown
                            ? FontAwesomeIcons.eyeSlash
                            : FontAwesomeIcons.eye,
                        color: Colors.black,
                        size: 20.0,
                      ),
                    ),
                  ),
                  validator: (value) {},
                ),
                SizedBox(
                  height: width / 10.0,
                ),
                Center(
                  child: Container(
                    width: width,
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          isLoading = true;
                        });
                        FirebaseService().isAdminExist(userName, passwordController.text.toString()).then((value) {
                          if (value) {
                            if (userName == 'Central') {
                              PrefsHelper().saveAuthCode(1);
                              Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const CentralHomeScreen()), (Route<dynamic> route) => false);
                            } else if (userName == 'State') {
                              PrefsHelper().saveAuthCode(2);
                              Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const StateHomeScreen()), (Route<dynamic> route) => false);
                            } else {
                              PrefsHelper().saveAuthCode(3);
                              Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const DistrictHomeScreen()), (Route<dynamic> route) => false);
                            }
                          }
                          setState(() {
                            isLoading = false;
                          });
                        });
                      },
                      child: const Text(
                        'LOGIN',
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

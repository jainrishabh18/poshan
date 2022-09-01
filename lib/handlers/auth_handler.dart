import 'package:flutter/material.dart';
import 'package:poshan/constants/constant_colors.dart';
import 'package:poshan/screens/central_home_screen.dart';
import 'package:poshan/screens/district_home_screen.dart';
import 'package:poshan/screens/on_board_screen.dart';
import 'package:poshan/screens/school_home_screen.dart';
import 'package:poshan/screens/state_home_screen.dart';
import 'package:poshan/services/prefs_helper.dart';

class AuthHandler extends StatefulWidget {
  const AuthHandler({Key? key}) : super(key: key);

  @override
  State<AuthHandler> createState() => _AuthHandlerState();
}

class _AuthHandlerState extends State<AuthHandler> {
  @override
  void initState() {
    super.initState();
    PrefsHelper().getAuthCode().then((value) {
      switch (value) {
        case 0:
          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const OnBoardScreen()), (Route<dynamic> route) => false);
          break;
        case 1:
          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const CentralHomeScreen()), (Route<dynamic> route) => false);
          break;
        case 2:
          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const StateHomeScreen()), (Route<dynamic> route) => false);
          break;
        case 3:
          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const DistrictHomeScreen()), (Route<dynamic> route) => false);
          break;
        case 4:
          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const SchoolHomeScreen()), (Route<dynamic> route) => false);
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        child: Center(
          child: CircularProgressIndicator(
            color: ConstantColors.RED,
          ),
        ),
      ),
    );
  }
}

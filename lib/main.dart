import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:poshan/constants/constant_colors.dart';
import 'package:poshan/handlers/auth_handler.dart';
import 'package:poshan/providers/food_details_provider.dart';
import 'package:poshan/screens/school_home_screen.dart';
import 'package:poshan/services/api_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => FoodDetailsProvider()),
    ],
    child: MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          color: ConstantColors.RED,
        ),
      ),
      home: const AuthHandler(),
      // home: SchoolHomeScreen(),
    ),
  );
}

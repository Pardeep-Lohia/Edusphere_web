import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/AuthenticationScreens/LoginScreen.dart'
    as LoginScreen;
import 'package:flutter_application_1/AuthenticationScreens/SignUp.dart';
import 'package:flutter_application_1/Screens/CommunityScreen.dart';
import 'package:flutter_application_1/Screens/HomeScreenFinal.dart';
// import 'package:flutter_application_1/Screens/HomeScreen.dart';
// import 'package:flutter_application_1/Screens/HomeScreennew.dart';
// import 'package:flutter_application_1/Screens/InputForRoadmapScreen.dart';
import 'package:flutter_application_1/Screens/RippleEffectOfRoadmapScreen.dart';
import 'package:flutter_application_1/Screens/TestScreen.dart';
import 'package:flutter_application_1/SplashScreen/SplashScreen.dart';
import 'package:flutter_application_1/firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      // home: CommunityPage(userId: "LbuQm4OJMUMo6AeC96xgq8elHJH3"),
      // home: CommunityPage(userId: "QXyx9HP6SrXKefA7ZRmYgSog0L02"),
      // home: HomeScreen(),
      home: Splashscreen(),
      // routes: {'/home': (context) => HomeScreen()},
    );
  }
}

import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter_application_1/AuthenticationScreens/LoginScreen.dart'; // Import Timer
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_application_1/Screens/HomeScreenFinal.dart';
import 'package:provider/provider.dart';
import 'package:flutter_application_1/user_provider.dart';

class Splashscreen extends StatefulWidget {
  const Splashscreen({super.key});

  @override
  State<Splashscreen> createState() => _SplashscreenState();
}

class _SplashscreenState extends State<Splashscreen> {
  double _opacity = 0.0; // State variable for opacity

  @override
  void initState() {
    super.initState();
    // Set a timer to change the opacity
    Timer(const Duration(seconds: 1), () async {
      setState(() {
        _opacity = 1.0; // Fade in after 1 second
      });
      Timer(const Duration(seconds: 4), () async {
        User? currentUser = FirebaseAuth.instance.currentUser;
        if (currentUser != null) {
          // Set user in UserProvider
          final userProvider = Provider.of<UserProvider>(context, listen: false);
          userProvider.setUser(currentUser);
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => HomeScreen()));
        } else {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => LoginScreen()));
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(10),
        child: Container(
          decoration: BoxDecoration(
              color: theme.colorScheme.background,
              borderRadius: BorderRadius.circular(15)),
          child: Center(
            child: AnimatedOpacity(
              opacity: _opacity, // Use the opacity state variable
              duration: const Duration(seconds: 3), // Duration of the fade
              child: Image.asset('Assets/learnsphere.png'),
            ),
          ),
        ),
      ),
    );
  }
}

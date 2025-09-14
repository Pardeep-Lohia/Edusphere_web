import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter_application_1/AuthenticationScreens/LoginScreen.dart'; // Import Timer

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
    Timer(const Duration(seconds: 1), () {
      setState(() {
        _opacity = 1.0; // Fade in after 1 second
      });
      Timer(const Duration(seconds: 4), () {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => LoginScreen()));
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(10),
        child: Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('Assets/blackbg.webp'),
                fit: BoxFit.fill,
              ),
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

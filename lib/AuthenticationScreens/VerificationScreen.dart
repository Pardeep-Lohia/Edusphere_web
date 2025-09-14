import 'package:flutter/material.dart';

class VerificationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Verification"),
      ),
      body: Center(
        child: Text("Fill in your verification details here."),
      ),
    );
  }
}

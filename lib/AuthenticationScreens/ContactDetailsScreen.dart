import 'package:flutter/material.dart';

class ContactDetailsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Contact Details"),
      ),
      body: Center(
        child: Text("Fill in your contact details here."),
      ),
    );
  }
}

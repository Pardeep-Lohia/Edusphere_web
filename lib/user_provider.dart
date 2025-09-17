import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserProvider with ChangeNotifier {
  User? _user;
  Map<String, dynamic>? _userData;

  User? get user => _user;
  Map<String, dynamic>? get userData => _userData;

  void setUser(User? user) {
    _user = user;
    if (user != null) {
      _loadUserData(user.uid);
    } else {
      _userData = null;
    }
    notifyListeners();
  }

  Future<void> _loadUserData(String uid) async {
    try {
      DocumentSnapshot doc = await FirebaseFirestore.instance.collection('Users').doc(uid).get();
      if (doc.exists) {
        _userData = doc.data() as Map<String, dynamic>;
      } else {
        _userData = null;
      }
    } catch (e) {
      print('Error loading user data: $e');
      _userData = null;
    }
    notifyListeners();
  }

  Future<void> updateUserData(Map<String, dynamic> data) async {
    if (_user != null) {
      await FirebaseFirestore.instance.collection('Users').doc(_user!.uid).set(data, SetOptions(merge: true));
      _userData = {...?_userData, ...data};
      notifyListeners();
    }
  }

  void logout() {
    _user = null;
    _userData = null;
    notifyListeners();
  }
}

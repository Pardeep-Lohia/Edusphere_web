import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'themes.dart';

class ThemeProvider with ChangeNotifier {
  bool _isDarkMode = false;

  bool get isDarkMode => _isDarkMode;

  ThemeData get currentTheme => _isDarkMode ? AppThemes.darkTheme : AppThemes.lightTheme;

  ThemeProvider() {
    _loadTheme();
  }

  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    _saveTheme(_isDarkMode);
    notifyListeners();
  }

  void _loadTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? isDark = prefs.getBool('isDarkMode');
    if (isDark != null) {
      _isDarkMode = isDark;
    } else {
      _isDarkMode = false;
    }
    notifyListeners();
  }

  void _saveTheme(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('isDarkMode', value);
  }
}

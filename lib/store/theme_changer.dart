import 'package:flutter/material.dart';

class ThemeChanger with ChangeNotifier {
  bool _isDark = false;
  bool get isDark => _isDark;

  void toggleTheme() {
    print("toggling theme");
    _isDark = !_isDark;
    notifyListeners();
  }
}
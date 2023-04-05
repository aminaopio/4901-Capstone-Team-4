import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeMode themeMode = ThemeMode.dark;
  bool get isDarkMode => themeMode == ThemeMode.dark;

  void toggleTheme(bool isOn) {
    themeMode = isOn ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }
}

class MyThemes {
  static final darkTheme = ThemeData(
    scaffoldBackgroundColor: Colors.grey.shade900,
    colorScheme: ColorScheme.dark(),
    primaryColor: Colors.grey.shade900,
    backgroundColor: Colors.grey.shade900,
  );

  static final lightTheme = ThemeData(
      scaffoldBackgroundColor: Colors.grey,
      colorScheme: ColorScheme.light(),
      primaryColor: Colors.grey,
      backgroundColor: Colors.grey,
      iconTheme: IconThemeData(color: Colors.green.shade300, opacity: 0.8));
}

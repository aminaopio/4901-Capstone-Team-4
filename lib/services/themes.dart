import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeMode themeMode = ThemeMode.dark;
  bool get isDarkMode => themeMode == ThemeMode.dark;

  GoogleMapController? mapController;
  late BitmapDescriptor userIcon;

  late String _darkMapStyle;
  late String _lightMapStyle;

  ThemeProvider() {
    loadMapStyles(); // Call the loadMapStyles method to initialize the map styles
  }

  Future<void> loadMapStyles() async {
    _darkMapStyle =
        await rootBundle.loadString('lib/assets/map_styles/dark.json');
    _lightMapStyle =
        await rootBundle.loadString('lib/assets/map_styles/light.json');
  }

  String get mapStyle => isDarkMode ? _darkMapStyle : _lightMapStyle;

  void toggleTheme(bool isOn) {
    themeMode = isOn ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }
}

class MyThemes {
  static final darkTheme = ThemeData(
    scaffoldBackgroundColor: Colors.grey.shade900,
    primaryColor: Colors.grey.shade900,
    backgroundColor: Colors.grey.shade700,
    brightness: Brightness.dark,
  );

  static final lightTheme = ThemeData(
      scaffoldBackgroundColor: Colors.grey,
      primaryColor: Colors.grey,
      backgroundColor: Colors.grey[400],
      iconTheme: IconThemeData(color: Color(0xFF81C784), opacity: 0.8),
      brightness: Brightness.light);
}

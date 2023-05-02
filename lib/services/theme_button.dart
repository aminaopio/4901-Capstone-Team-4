import 'package:flutter/material.dart';
import 'package:flutter_mmh/services/themes.dart';
import 'package:provider/provider.dart';

class ChangeThemeButtonWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Switch.adaptive(
      value: themeProvider.isDarkMode,
      activeThumbImage: new NetworkImage(
          'https://w7.pngwing.com/pngs/163/715/png-transparent-dark-mode-moon-night-forecast-weather-multimedia-solid-px-icon.png'),
      inactiveThumbImage: new NetworkImage(
          'https://cdn0.iconfinder.com/data/icons/multimedia-line-30px/30/sun_light_mode_day-512.png'),
      onChanged: (value) {
        final provider = Provider.of<ThemeProvider>(context, listen: false);
        provider.toggleTheme(value);
      },
    );
  }
}

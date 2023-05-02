import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

import '../../services/themes.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: SizedBox(
                width: 300,
                height: 215,
                child: Lottie.asset('lib/assets/animations/spinning.json'),
              ),
            ),
            Text(
              'Theme',
              style: Theme.of(context).textTheme.headline6,
            ),
            ListTile(
              title: Text('Dark Mode'),
              leading: Icon(Icons.dark_mode),
              trailing: Switch(
                value: themeProvider.isDarkMode,
                onChanged: (value) {
                  themeProvider.toggleTheme(value);
                },
              ),
            ),
            const Divider(height: 20, thickness: 1),
            const SizedBox(height: 20),
            Text(
              'Notification Settings',
              style: Theme.of(context).textTheme.headline6,
            ),
            ListTile(
              title: Text('Push Notifications'),
              leading: Icon(Icons.notifications),
              trailing: Switch(
                value: true,
                onChanged: (value) {},
              ),
            ),
            ListTile(
              title: Text('Email Notifications'),
              leading: Icon(Icons.email),
              trailing: Switch(
                value: true,
                onChanged: (value) {},
              ),
            ),
            const Divider(height: 20, thickness: 1),
            const SizedBox(height: 20),
            Text(
              'Privacy Settings',
              style: Theme.of(context).textTheme.headline6,
            ),
            ListTile(
              title: Text('Location Sharing'),
              leading: Icon(Icons.my_location),
              trailing: Switch(
                value: true,
                onChanged: (value) {},
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mmh/screens/pages/welcome_screen.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../screens/pages/about_page.dart';

class MenuPage extends StatefulWidget {
  @override
  _MenuPageState createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  final FirebaseAuth auth = FirebaseAuth.instance;

  signOut() async {
    await FirebaseAuth.instance.signOut();
    await GoogleSignIn().signOut();

    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => WelcomeScreen(
                  onTap: () {},
                )));
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).primaryColor,
      child: Column(
        children: [
          // Drawer header
          const DrawerHeader(
            child: Center(
              child: Icon(
                Icons.location_pin,
                color: Colors.red,
                size: 64,
              ),
            ),
          ),

          const SizedBox(height: 25),

          // ABOUT PAGE
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: GestureDetector(
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AboutPage(),
                  ),
                );
              },
              child: ListTile(
                leading: const Icon(Icons.info),
                title: Text(
                  "A B O U T",
                ),
              ),
            ),
          ),
          //Theme toggle
          // Padding(
          //   padding: const EdgeInsets.symmetric(horizontal: 25.0),
          //   child: AppBar(
          //     actions: [
          //       ChangeThemeButtonWidget(),
          //     ],
          //     title: Text(
          //       "T H E M E",
          //       style: TextStyle(color: Colors.grey[700]),
          //     ),
          //   ),
          // ),
          // LOGOUT BUTTON
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: ListTile(
              leading: const Icon(Icons.logout),
              onTap: () => signOut(),
              title: Text(
                "L O G O U T",
              ),
            ),
          ),
        ],
      ),
    );
  }
}

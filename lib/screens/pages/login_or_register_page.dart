import 'package:flutter/material.dart';
import 'package:flutter_mmh/screens/pages/register_page.dart';
import 'package:flutter_mmh/screens/pages/welcome_screen.dart';

class LoginOrRegisterPage extends StatefulWidget {
  const LoginOrRegisterPage({super.key});

  @override
  State<LoginOrRegisterPage> createState() => _LoginOrRegisterPageState();
}

class _LoginOrRegisterPageState extends State<LoginOrRegisterPage> {
  //initially welcome screen
  bool showWelcomeScreen = true;

  //toggle between login and register
  void togglePages() {
    setState(() {
      showWelcomeScreen = !showWelcomeScreen;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showWelcomeScreen) {
      return WelcomeScreen(
        onTap: togglePages,
      );
    } else
      return RegisterPage(
        onTap: togglePages,
      );
  }
}

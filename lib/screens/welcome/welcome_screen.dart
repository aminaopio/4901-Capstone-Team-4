// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables
import 'package:flutter_mmh/screens/auth/sign_in_screen.dart';
import 'package:flutter_mmh/screens/auth/sign_up_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_mmh/screens/myapp.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
          child: Center(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
            //hello!
            Icon(
              Icons.map_outlined,
              size: 100,
            ),
            Text('Meet Me Halfway',
                style: GoogleFonts.bebasNeue(
                  fontSize: 52,
                )),
            SizedBox(height: 10),
            Text(
              'Welcome!',
              style: TextStyle(
                fontSize: 20,
              ),
            ),
            SizedBox(height: 20),
            //sign in button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Center(
                child: Container(
                  padding: EdgeInsets.all(20),
                  child: ElevatedButton(
                    onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SignInScreen(),
                        )),
                    style: TextButton.styleFrom(
                      backgroundColor: Color.fromARGB(255, 121, 62, 249),
                      minimumSize: Size.fromHeight(50),
                    ),
                    child: Text(
                      "Sign In",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            //sign up button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Center(
                child: Container(
                  padding: EdgeInsets.all(20),
                  child: ElevatedButton(
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SignUpScreen(),
                      ),
                    ),
                    style: TextButton.styleFrom(
                      backgroundColor: Color.fromARGB(255, 121, 62, 249),
                      minimumSize: Size.fromHeight(50),
                    ),
                    child: Text(
                      "Sign Up",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),
              ),
            ),

            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Dont want to become a member?'),
                TextButton(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MapSample(),
                    ),
                  ),
                  child: Text(
                    'Skip to App!',
                    style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
              ],
            ),
          ]))),
    );
  }
}

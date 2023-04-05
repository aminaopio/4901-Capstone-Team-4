// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables
import 'package:flutter/material.dart';
import 'package:flutter_mmh/components/square_tile.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../services/auth_services.dart';
import '../../services/theme_button.dart';
import '../auth/main_page.dart';

class WelcomeScreen extends StatefulWidget {
  final Function()? onTap;
  const WelcomeScreen({super.key, required this.onTap});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  //text controllers
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  // void signInWithGoogle() async {
  //   Navigator.pop(context);
  //   Navigator.push(
  //     context,
  //     MaterialPageRoute(
  //       builder: (context) => const Auth(),
  //     ),
  //   );
  // }

  void signIn() async {
    // once user is authenticated, direct them to the main page
    Navigator.pop(context);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const Auth(),
      ),
    );
    // //loading
    // showDialog(
    //   context: context,
    //   builder: (context) {
    //     return const Center(
    //       child: CircularProgressIndicator(),
    //     );
    //   },

    //sign in
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      //stop loading
      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context);
      //show error message
      showErrorMessage(e.code);
    }
  }

  //error message to user
  void showErrorMessage(String message) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
              backgroundColor: Colors.transparent,
              title: Center(
                  child: Text(
                message,
                style: const TextStyle(color: Colors.white),
              )));
        });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).backgroundColor,
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ChangeThemeButtonWidget(),
          ),
        ],
      ),
      backgroundColor: Theme.of(context).primaryColor,
      body: SafeArea(
          child: Center(
              child: SingleChildScrollView(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          //hello!
          Icon(
            Icons.map_outlined,
            size: 100,
          ),

          Text('Meet Me Halfway',
              style: GoogleFonts.bebasNeue(
                fontSize: 52,
              )),
          const SizedBox(height: 10),
          Text(
            'Welcome!',
            style: TextStyle(
              fontSize: 20,
            ),
          ),
          const SizedBox(height: 20),

          //email textfield
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey[200],
                border: Border.all(color: Colors.white),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 20.0),
                child: TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'E-mail',
                    hintStyle: TextStyle(color: Colors.grey[500]),
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(height: 10),

          //password textfield
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey[200],
                border: Border.all(color: Colors.white),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 20.0),
                child: TextField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Password',
                    hintStyle: TextStyle(color: Colors.grey[500]),
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(height: 10),

          //forgot password?
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Text(
                  'Forgot Password?',
                  style: TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 25),
          //signin button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: GestureDetector(
              onTap: signIn,
              child: Container(
                padding: EdgeInsets.all(25),
                decoration: BoxDecoration(
                  color: Colors.green[300],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Center(
                  child: Text(
                    'Sign In',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(height: 25),

          //or continue to
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: Row(
              children: [
                Expanded(
                    child: Divider(
                  thickness: 0.5,
                  color: Colors.grey[400],
                )),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Text(
                    'Or continue with',
                    style: TextStyle(color: Colors.grey[700]),
                  ),
                ),
                Expanded(
                    child: Divider(
                  thickness: 0.5,
                  color: Colors.grey[400],
                ))
              ],
            ),
          ),

          const SizedBox(height: 20),

          //sign in with google or apple
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              //google button
              SquareTile(
                onTap: () => AuthService().signInWithGoogle(),
                imagePath: 'lib/images/google.png',
              ),

              SizedBox(width: 25),

              //apple button
              SquareTile(onTap: () {}, imagePath: 'lib/images/apple.png'),
            ],
          ),

          const SizedBox(height: 25),

          //not a memeber and skip to app
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Not a member?",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              GestureDetector(
                onTap: widget.onTap,
                child: Text(
                  '  Register here!',
                  style: TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              // Text(
              //   ' or',
              //   style: TextStyle(
              //     fontWeight: FontWeight.bold,
              //   ),
              // ),
              // TextButton(
              //   onPressed: () => Navigator.push(
              //     context,

              //     MaterialPageRoute(
              //       builder: (context) => MapSample(

              //       ),

              //     ),
              //   ),

              //   child: Text(
              //     'Skip to the App!',
              //     style: TextStyle(
              //       color: Colors.blue,
              //       fontWeight: FontWeight.bold,
              //     ),
              //   ),
              // ),
            ],
          ),
        ]),
      ))),
    );
  }
}

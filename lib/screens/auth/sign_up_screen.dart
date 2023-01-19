import 'package:flutter_mmh/constants.dart';
import 'package:flutter_mmh/screens/auth/sign_in_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'components/sign_up_form.dart';
import '../../services/auth.dart';

class SignUpScreen extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();

  final _emailTextController = TextEditingController();
  final _passwordTextController = TextEditingController();
  final _userNameTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        fit: StackFit.expand,
        children: [
          Center(
            child: SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Create Account",
                      style: Theme.of(context)
                          .textTheme
                          .headline5!
                          .copyWith(fontWeight: FontWeight.bold),
                    ),
                    Row(
                      children: [
                        Text("Already have an account?"),
                        TextButton(
                          onPressed: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SignInScreen(),
                              )),
                          child: Text(
                            "Sign In!",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: defaultPadding * 2),
                    SignUpForm(formKey: _formKey),
                    const SizedBox(height: defaultPadding * 2),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            User? user = await FireAuth.registerEmailPass(
                                username: _userNameTextController.text,
                                email: _emailTextController.text,
                                password: _passwordTextController.text);

                            _formKey.currentState!.save();
                          }
                        },
                        style: TextButton.styleFrom(
                          backgroundColor: Color.fromARGB(255, 121, 62, 249),
                          minimumSize: Size.fromHeight(50),
                        ),
                        child: Text("Sign Up"),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

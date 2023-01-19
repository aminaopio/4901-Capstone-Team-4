import 'package:flutter_mmh/screens/auth/sign_up_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../constants.dart';
import 'components/sign_in_form.dart';
import '../../services/auth.dart';

final _emailController = TextEditingController();
final _passwordController = TextEditingController();

Future signIn() async {
  await FirebaseAuth.instance.signInWithEmailAndPassword(
    email: _emailController.text.trim(),
    password: _passwordController.text.trim(),
  );
}

@override
void dispose() {
  _emailController.dispose();
  _passwordController.dispose();
}

class SignInScreen extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        fit: StackFit.expand,
        children: [
          Padding(
            padding:
                EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.1),
            child: SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Sign In",
                      style: Theme.of(context)
                          .textTheme
                          .headline5!
                          .copyWith(fontWeight: FontWeight.bold),
                    ),
                    Row(
                      children: [
                        Text("Don't have an account?"),
                        TextButton(
                          onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SignUpScreen(),
                            ),
                          ),
                          child: Text(
                            "Sign Up!",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: defaultPadding * 2),
                    SignInForm(formKey: _formKey),
                    const SizedBox(height: defaultPadding * 2),
                    SizedBox(
                      width: double.infinity,
                      child: GestureDetector(
                        onTap: signIn,
                        child: Container(
                          child: Text("Sign In"),
                        ),
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

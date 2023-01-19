import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';

import '../../../constants.dart';

class SignUpForm extends StatelessWidget {
  SignUpForm({
    Key? key,
    required this.formKey,
  }) : super(key: key);

  final GlobalKey formKey;

  late String _userName, _email, _password;

  final _emailTextController = TextEditingController();
  final _passwordTextController = TextEditingController();
  final _userNameTextController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFieldName(text: "Username"),
          TextFormField(
            decoration: InputDecoration(hintText: "meetmehalfway"),
            validator: RequiredValidator(errorText: "Username is required"),
            controller: _userNameTextController,
            onSaved: (username) => _userName = username!,
          ),
          const SizedBox(height: defaultPadding),
          TextFieldName(text: "Email"),
          TextFormField(
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(hintText: "test@email.com"),
            validator: EmailValidator(errorText: "Use a valid email!"),
            controller: _emailTextController,
            onSaved: (email) => _email = email!,
          ),
          const SizedBox(height: defaultPadding),
          TextFieldName(text: "Name"),
          TextFormField(
            keyboardType: TextInputType.phone,
            decoration: InputDecoration(hintText: "Name"),
            validator: RequiredValidator(errorText: "Name is required"),
            controller: _passwordTextController,
            onSaved: (username) => _userName = username!,
          ),
          const SizedBox(height: defaultPadding),
          TextFieldName(text: "Password"),
          TextFormField(
            obscureText: true,
            decoration: InputDecoration(hintText: "******"),
            validator: passwordValidator,
            onSaved: (password) => _password = password!,
            //validate password
            onChanged: (pass) => _password = pass,
          ),
          const SizedBox(height: defaultPadding),
          TextFieldName(text: "Confirm Password"),
          TextFormField(
            obscureText: true,
            decoration: InputDecoration(hintText: "*****"),
            validator: (pass) =>
                MatchValidator(errorText: "Passwords do not match")
                    .validateMatch(pass!, _password),
          ),
        ],
      ),
    );
  }
}

class TextFieldName extends StatelessWidget {
  const TextFieldName({
    Key? key,
    required this.text,
  }) : super(key: key);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: defaultPadding / 3),
      child: Text(
        text,
        style: TextStyle(fontWeight: FontWeight.w600, color: Colors.black54),
      ),
    );
  }
}

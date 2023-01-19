import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import '../../../constants.dart';
import 'sign_up_form.dart';
import '../sign_in_screen.dart';

final _emailTextController = TextEditingController();
final _passwordTextController = TextEditingController();

class SignInForm extends StatelessWidget {
  SignInForm({
    Key? key,
    required this.formKey,
  }) : super(key: key);

  final _focusEmail = FocusNode();
  final _focusPassword = FocusNode();

  final GlobalKey formKey;

  late String _email, _password;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFieldName(text: "Email"),
          TextFormField(
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(hintText: "test@email.com"),
            controller: _emailTextController,
            focusNode: _focusEmail,
            validator: EmailValidator(errorText: "Use a valid email!"),
            onSaved: (email) => _email = email!,
          ),
          const SizedBox(height: defaultPadding),
          TextFieldName(text: "Password"),
          TextFormField(
            //hide password
            obscureText: true,
            decoration: InputDecoration(hintText: "******"),
            controller: _passwordTextController,
            focusNode: _focusPassword,
            validator: passwordValidator,
            onSaved: (password) => _password = password!,
          ),
          const SizedBox(height: defaultPadding),
        ],
      ),
    );
  }
}

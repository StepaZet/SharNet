import 'package:flutter/material.dart';

import '../../api/profile.dart';
import '../../models/config.dart';
import '../../models/profile_info.dart';
import '../main_pages/main_profile_page.dart';
import '../navigation_bar.dart';


class LoginPage extends StatefulWidget {
  final String email;

  LoginPage({this.email = ""});

  @override
  _LoginPageState createState() => _LoginPageState(email);
}

class _LoginPageState extends State<LoginPage> {
  final String email;
  String _loginError = '';

  final _formKey = GlobalKey<FormState>();
  TextEditingController _passwordController = TextEditingController();

  _LoginPageState(this.email);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Authorization'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Form(
              key: _formKey,
              child: TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Password',
                  suffixIcon: Icon(Icons.visibility_off),
                  errorText: _loginError.isNotEmpty ? _loginError : null,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty || value.length < 6) {
                    return 'Password must be at least 6 characters long';
                  }
                  return null;
                },
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {
                  // TODO: Add Forgot Password functionality
                },
                child: Text('Forgot password?'),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                if (!_formKey.currentState!.validate()) {
                  return;
                }

                var loginResult = await loginUser(email, _passwordController.text);

                if (loginResult.resultStatus == ResultEnum.wrongPassword) {
                  setState(() {
                    _loginError = 'Incorrect password';
                  });
                  return;
                }

                Config.accessToken = loginResult.resultData!;

                Navigator.popUntil(context, (Route<dynamic> route) => route.isFirst);

                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (BuildContext context) => MyHomePage()),
                );

              },
              child: Text('Continue'),
            ),
            Divider(),
            TextButton(
              onPressed: () {
                // TODO: Add Sign up with Google functionality
              },
              child: Text('Sign up with Google'),
            ),
            TextButton(
              onPressed: () {
                // TODO: Add Sign up with Apple functionality
              },
              child: Text('Sign up with Apple'),
            ),
            Spacer(),
            TextButton(
              onPressed: () {
                // TODO: Navigate to sign up page
              },
              child: Text("Don't have an account? Sign up"),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }
}
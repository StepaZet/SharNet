import 'package:flutter/material.dart';

import 'main_enter_page.dart';

class RegisterSuccessPage extends StatefulWidget {
  final String email;

  RegisterSuccessPage({required this.email});

  @override
  _RegisterSuccessPageState createState() => _RegisterSuccessPageState(email);
}

class _RegisterSuccessPageState extends State<RegisterSuccessPage> {
  final String email;

  _RegisterSuccessPageState(this.email);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min, // This centers the children vertically.
          children: <Widget>[
            Icon(
              Icons.check_circle,
              size: 120,
              color: Colors.green,
            ),
            SizedBox(height: 24),
            Text(
              'A verification email has been sent to ${email}. Please confirm to activate your account.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 48),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => EnterPage(email: email)),
                );
              },
              child: Text('Return to Login'),
            ),
          ],
        ),
      ),
    );
  }
}
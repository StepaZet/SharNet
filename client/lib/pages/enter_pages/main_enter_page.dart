import 'package:client/pages/enter_pages/register_page.dart';
import 'package:flutter/material.dart';

import '../../api/profile.dart';
import '../../models/profile_info.dart';
import 'LoginPage.dart';


class EnterPage extends StatefulWidget {
  final String email;

  EnterPage({this.email = ""});

  @override
  _EnterPageState createState() => _EnterPageState(email);
}


class _EnterPageState extends State<EnterPage> {
  final _emailController = TextEditingController();
  String _emailError = '';

  _EnterPageState(String email){
    _emailController.text = email;
  }

  bool isEmailValid(String email) {
    final emailRegExp = RegExp(r'^[a-zA-Z0-9._]+@[a-zA-Z0-9]+\.[a-zA-Z]+');
    return emailRegExp.hasMatch(email);
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var baseSizeWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text('Registration'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Image.network(
              'https://minio.nplus1.ru/app-images/145704/c46ee6b7386db337f9502645742ca36a.jpg',
              fit: BoxFit.scaleDown,
              // Изображение будет заполнять всю высоту карточки
              width: baseSizeWidth * 0.5,
            ),
            SizedBox(height: 24),
            Text(
              'Become a part of shark lovers community!',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 24),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
                errorText: _emailError.isNotEmpty ? _emailError : null,
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                if (!isEmailValid(_emailController.text)) {
                  setState(() {
                    _emailError = 'Please enter a valid email address.';
                  });
                  return;
                }

                var checkResult = await checkMailExist(_emailController.text);

                if (checkResult.resultStatus == ResultEnum.emailNotVerified) {
                  setState(() {
                    _emailError = 'Email exists, but not verified. Please check your email';
                  });
                } else if (checkResult.resultStatus == ResultEnum.emailNotFound) {

                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => RegisterPage(email: _emailController.text)),
                  );

                } else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPage(email: _emailController.text)),
                  );
                }

              },
              child: Text('Continue'),
            ),
            Divider(height: 32),
            TextButton(
              onPressed: () {
                // TODO: Добавьте функциональность
              },
              child: Text('Sign up with Google'),
            ),
            TextButton(
              onPressed: () {
                // TODO: Добавьте функциональность
              },
              child: Text('Sign up with Apple'),
            ),
            SizedBox(height: 16),
            Text(
              'By creating an account, you agree with Privacy Policy',
              textAlign: TextAlign.center,
            ),
            TextButton(
              onPressed: () {
                // TODO: Перенаправьте на страницу входа
              },
              child: Text('Already have an account? Log in'),
            ),
          ],
        ),
      ),
    );
  }
}
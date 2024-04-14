import 'package:client/pages/enter_pages/registration_success_page.dart';
import 'package:flutter/material.dart';

import '../../api/profile.dart';
import '../../models/profile_info.dart';

class RegisterPage extends StatefulWidget {
  final String email;

  const RegisterPage({super.key, this.email = ""});

  @override
  _RegisterPageState createState() => _RegisterPageState(email);
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  _RegisterPageState(String email){
    _emailController.text = email;
    _usernameController.text = email.split('@')[0];
  }

  bool isEmailValid(String email) {
    final emailRegExp = RegExp(r'^[a-zA-Z0-9._]+@[a-zA-Z0-9]+\.[a-zA-Z]+');
    return emailRegExp.hasMatch(email);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create an account'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: 'Name',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your name';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _usernameController,
                  decoration: InputDecoration(
                    labelText: 'Username',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your username';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty || !isEmailValid(value)) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    suffixIcon: Icon(Icons.visibility_off),
                  ),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty || value.length < 6) {
                      return 'Password must be at least 6 characters long';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _confirmPasswordController,
                  decoration: InputDecoration(
                    labelText: 'Repeat the password',
                    suffixIcon: Icon(Icons.visibility_off),
                  ),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value != _passwordController.text) {
                      return 'Passwords do not match';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () async {
                    if (!_formKey.currentState!.validate()) {
                      return;
                    }

                    var registerResult = await registerUser(
                      _nameController.text,
                      _usernameController.text,
                      _emailController.text,
                      _passwordController.text,
                    );

                    if (registerResult.resultStatus == ResultEnum.emailAlreadyExist) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text('This email is already registered'),
                      ));
                      return;
                    }

                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => RegisterSuccessPage(email: _emailController.text)),
                    );

                  },
                  child: Text('Continue'),
                ),
                SizedBox(height: 24),
                Text(
                  'By creating an account, you agree with Privacy Policy',
                  textAlign: TextAlign.center,
                ),
                TextButton(
                  onPressed: () {

                  },
                  child: Text('Already have an account? Log in'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }
}
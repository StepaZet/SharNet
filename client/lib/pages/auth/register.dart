import 'package:client/pages/auth/registration_success.dart';
import 'package:flutter/material.dart';

import 'package:client/api/profile.dart';
import 'package:client/models/profile_info.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final obscurePasswordProvider = StateProvider<bool>((ref) => true);
final obscureConfirmPasswordProvider = StateProvider<bool>((ref) => true);

class RegisterPage extends ConsumerWidget {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  RegisterPage({super.key, String email = ""}) {
    _emailController.text = email;
    _usernameController.text = email.split('@')[0];
  }

  bool isEmailValid(String email) {
    final emailRegExp = RegExp(r'^[a-zA-Z0-9._]+@[a-zA-Z0-9]+\.[a-zA-Z]+');
    return emailRegExp.hasMatch(email);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create an account'),
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
                  decoration: const InputDecoration(
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
                  decoration: const InputDecoration(
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
                  decoration: const InputDecoration(
                    labelText: 'Email',
                  ),
                  validator: (value) {
                    if (value == null ||
                        value.isEmpty ||
                        !isEmailValid(value)) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                ),
                Consumer(builder: (context, ref, child) {
                  final obscurePassword = ref.watch(obscurePasswordProvider);
                  return TextFormField(
                    controller: _passwordController,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      suffixIcon: IconButton(
                        icon: Icon(obscurePassword ? Icons.visibility_off : Icons.visibility),
                        onPressed: () {
                          ref.read(obscurePasswordProvider.notifier).state = !obscurePassword;
                        },
                      ),
                    ),
                    obscureText: obscurePassword,
                    validator: (value) {
                      if (value == null || value.isEmpty || value.length < 6) {
                        return 'Password must be at least 6 characters long';
                      }
                      return null;
                    },
                  );
                }),
                Consumer(builder: (context, ref, child) {
                  final obscureConfirmPassword = ref.watch(obscureConfirmPasswordProvider);
                  return TextFormField(
                    controller: _confirmPasswordController,
                    decoration: InputDecoration(
                      labelText: 'Repeat the password',
                      suffixIcon: IconButton(
                        icon: Icon(obscureConfirmPassword ? Icons.visibility_off : Icons.visibility),
                        onPressed: () {
                          ref.read(obscureConfirmPasswordProvider.notifier).state = !obscureConfirmPassword;
                        },
                      ),
                    ),
                    obscureText: obscureConfirmPassword,
                    validator: (value) {
                      if (value == null || value != _passwordController.text) {
                        return 'Passwords do not match';
                      }
                      return null;
                    },
                  );
                }),
                const SizedBox(height: 24),
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

                    if (registerResult.resultStatus == ResultEnum.unknownError) {
                      var messages = registerResult.resultData;
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(messages.join('\n')),
                      ));
                      return;
                    }

                    if (registerResult.resultStatus ==
                        ResultEnum.emailAlreadyExists) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text('This email is already registered'),
                      ));
                      return;
                    }

                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => RegisterSuccessPage(
                              email: _emailController.text)),
                    );
                  },
                  child: const Text('Continue'),
                ),
                const SizedBox(height: 24),
                const Text(
                  'By creating an account, you agree with Privacy Policy',
                  textAlign: TextAlign.center,
                ),
                TextButton(
                  onPressed: () {},
                  child: const Text('Already have an account? Log in'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

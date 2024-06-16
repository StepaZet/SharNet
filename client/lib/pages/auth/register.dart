import 'package:client/components/styles.dart';
import 'package:client/pages/auth/registration_success.dart';
import 'package:flutter/material.dart';

import 'package:client/api/profile.dart';
import 'package:client/models/profile_info.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final obscurePasswordProvider = StateProvider<bool>((ref) => true);
final obscureConfirmPasswordProvider = StateProvider<bool>((ref) => true);

class RegisterPage extends ConsumerWidget {
  final _formKey = GlobalKey<FormState>();
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
                  style: formTextStyle,
                  controller: _usernameController,
                  decoration: formFieldStyleWithLabel('Username'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your username';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                TextFormField(
                  style: formTextStyle,
                  controller: _emailController,
                  decoration: formFieldStyleWithLabel('Email'),
                  validator: (value) {
                    if (value == null ||
                        value.isEmpty ||
                        !isEmailValid(value)) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                Consumer(builder: (context, ref, child) {
                  final obscurePassword = ref.watch(obscurePasswordProvider);
                  return TextFormField(
                    style: formTextStyle,
                    controller: _passwordController,
                    decoration: formFieldStyleWithLabel(
                      'Password',
                      iconButton: IconButton(
                        icon: Icon(obscurePassword
                            ? Icons.visibility_off
                            : Icons.visibility),
                        onPressed: () {
                          ref.read(obscurePasswordProvider.notifier).state =
                              !obscurePassword;
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
                const SizedBox(height: 12),
                Consumer(builder: (context, ref, child) {
                  final obscureConfirmPassword =
                      ref.watch(obscureConfirmPasswordProvider);
                  return TextFormField(
                    style: formTextStyle,
                    controller: _confirmPasswordController,
                    decoration: formFieldStyleWithLabel(
                      'Repeat the password',
                      iconButton: IconButton(
                        icon: Icon(obscureConfirmPassword
                            ? Icons.visibility_off
                            : Icons.visibility),
                        onPressed: () {
                          ref
                              .read(obscureConfirmPasswordProvider.notifier)
                              .state = !obscureConfirmPassword;
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
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: accentButtonStyle,
                    onPressed: () async {
                      if (!_formKey.currentState!.validate()) {
                        return;
                      }

                      var registerResult = await registerUser(
                        _usernameController.text,
                        _emailController.text,
                        _passwordController.text,
                      );

                      if (registerResult.resultStatus ==
                          ResultEnum.unknownError) {
                        var messages = registerResult.resultData;
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(messages.join('\n')),
                        ));
                        return;
                      }

                      if (registerResult.resultStatus ==
                          ResultEnum.emailAlreadyExists) {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(
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
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

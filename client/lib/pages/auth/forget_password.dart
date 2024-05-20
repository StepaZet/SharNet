import 'package:client/api/profile.dart';
import 'package:client/models/profile_info.dart';
import 'package:client/pages/auth/reset_password.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final emailErrorProvider = StateProvider<String>((ref) => '');

bool isEmailValid(String email) {
  final emailRegExp = RegExp(r'^[a-zA-Z0-9._]+@[a-zA-Z0-9]+\.[a-zA-Z]+');
  return emailRegExp.hasMatch(email);
}


class ForgetPasswordPage extends ConsumerWidget {
  const ForgetPasswordPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formKey = GlobalKey<FormState>();
    final emailController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Forget password'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Consumer(builder: (context, ref, child) {
                final passwordError = ref.watch(emailErrorProvider);

                return TextFormField(
                  controller: emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    errorText: passwordError.isNotEmpty ? passwordError : null,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    return null;
                  },
                );
              }),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  if (formKey.currentState!.validate()) {

                    if (!isEmailValid(emailController.text)) {
                      ref.read(emailErrorProvider.notifier).state =
                      'Please enter a valid email address.';
                      return;
                    }

                    var response = await sendPasswordResetEmail(emailController.text);

                    if (response.resultStatus == ResultEnum.emailNotFound) {
                      ref.read(emailErrorProvider.notifier).state = 'Email not found';
                      return;
                    }

                    ref.read(emailErrorProvider.notifier).state = '';

                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ResetPasswordPage(),
                      ),
                    );
                  }
                },
                child: const Text('Send email'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
import 'package:client/pages/auth/register.dart';
import 'package:flutter/material.dart';

import 'package:client/api/profile.dart';
import 'package:client/models/profile_info.dart';
import 'login.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

final emailProvider = StateProvider<String>((ref) => '');
final emailErrorProvider = StateProvider<String>((ref) => '');

bool isEmailValid(String email) {
  final emailRegExp = RegExp(r'^[a-zA-Z0-9._]+@[a-zA-Z0-9]+\.[a-zA-Z]+');
  return emailRegExp.hasMatch(email);
}

class EnterPage extends ConsumerWidget {

  const EnterPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final emailError = ref.watch(emailErrorProvider);
    final existedEmail = ref.read(emailProvider);
    final emailController = TextEditingController();

    emailController.text = existedEmail;

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Image.network(
              'https://minio.nplus1.ru/app-images/145704/c46ee6b7386db337f9502645742ca36a.jpg',
              fit: BoxFit.scaleDown,
              width: MediaQuery.of(context).size.width * 0.5,
            ),
            const SizedBox(height: 24),
            const Text(
              'Become a part of shark lovers community!',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            Consumer(builder: (context, ref, child) {
              final emailError = ref.watch(emailErrorProvider);
              return TextField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: const OutlineInputBorder(),
                  errorText: emailError.isNotEmpty ? emailError : null,
                ),
                keyboardType: TextInputType.emailAddress,
              );
            }),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                final email = emailController.text;
                if (!isEmailValid(email)) {
                  ref.read(emailErrorProvider.notifier).state =
                      'Please enter a valid email address.';
                  return;
                }

                final result = await checkMailExist(email);

                switch (result.resultStatus) {
                  case ResultEnum.emailNotVerified:
                    ref.read(emailErrorProvider.notifier).state =
                        'Email exists, but not verified. Please check your email';
                    break;
                  case ResultEnum.emailNotFound:
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => RegisterPage(email: email)),
                    );
                    break;
                  default:
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => LoginPage(email: email)),
                    );
                }
              },
              child: const Text('Continue'),
            ),
            const Divider(height: 32),
            TextButton(
              onPressed: () {},
              child: const Text('Sign up with Google'),
            ),
            TextButton(
              onPressed: () {},
              child: const Text('Sign up with Apple'),
            ),
            const SizedBox(height: 16),
            const Text(
              'By creating an account, you agree with Privacy Policy',
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

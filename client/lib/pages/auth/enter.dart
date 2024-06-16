import 'package:client/api/firebase.dart';
import 'package:client/components/styles.dart';
import 'package:client/models/config.dart';
import 'package:client/pages/auth/register.dart';
import 'package:client/pages/navigation_bar.dart';
import 'package:flutter/material.dart';

import 'package:client/api/profile.dart';
import 'package:client/models/profile_info.dart';
import 'package:flutter_svg/svg.dart';
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              SvgPicture.asset('assets/SharkIcon.svg',
                  semanticsLabel: 'MapIcon', color: Colors.blue),
              const SizedBox(height: 24),
              const Text(
                'Become a part of\n\nshark lovers community!',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 24),
              Consumer(builder: (context, ref, child) {
                final emailError = ref.watch(emailErrorProvider);
                return TextField(
                  style: formTextStyle,
                  controller: emailController,
                  decoration: formFieldStyleWithLabel('Email', errorText: emailError.isNotEmpty ? emailError : null),
                  keyboardType: TextInputType.emailAddress,
                );
              }),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: accentButtonStyle,
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
              ),
              const SizedBox(height: 12),
              const Row(
                children: <Widget>[
                  Expanded(
                    child: Divider(
                      color: Colors.blue,
                      thickness: 2,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text('or',
                        style: TextStyle(
                            color: Colors.blue,
                            fontSize: 16,
                            fontWeight: FontWeight.w500)),
                  ),
                  Expanded(
                    child: Divider(
                      color: Colors.blue,
                      thickness: 2,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: buttonStyle,
                  onPressed: () async {
                    var loginResult = await signInWithGoogle();

                    if (loginResult.resultStatus != ResultEnum.ok) {
                      return;
                    }

                    Config.accessToken = loginResult.resultData!["access"];
                    Config.refreshToken = loginResult.resultData!["refresh"];

                    Navigator.popUntil(context, (route) => route.isFirst);
                    Navigator.pushReplacement(
                      context,
                      PageRouteBuilder(
                        transitionDuration: Duration.zero,
                        pageBuilder: (_, __, ___) => const MyHomePage(),
                      ),
                    );
                  },
                  child: const Text('Sign up with Google'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

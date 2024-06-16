import 'package:client/components/styles.dart';
import 'package:client/pages/navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'enter.dart';

class RegisterSuccessPage extends ConsumerWidget {
  final String email;

  const RegisterSuccessPage({super.key, required this.email});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            // This centers the children vertically.
            children: <Widget>[
              const Icon(
                Icons.check_circle,
                size: 120,
                color: Colors.green,
              ),
              const SizedBox(height: 24),
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  // Note: Styles for TextSpans must be explicitly defined.
                  // Child text spans will inherit styles from parent
                  style: const TextStyle(
                    fontSize: 18.0,
                    color: Colors.black,
                  ),
                  children: <TextSpan>[
                    const TextSpan(
                        text: 'A verification email has been sent to '),
                    TextSpan(
                      text: email,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const TextSpan(text: '\n\n'),
                    const TextSpan(
                        text: 'Please confirm to activate your account'),
                  ],
                ),
              ),
              // Text(
              //   'A verification email has been sent to $email\n\nPlease confirm to activate your account',
              //   textAlign: TextAlign.center,
              //   style: const TextStyle(
              //     fontSize: 18,
              //     // fontWeight: FontWeight.bold,
              //   ),
              // ),
              const SizedBox(height: 48),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: accentButtonStyle,
                  onPressed: () {
                    ref.read(emailProvider.notifier).state = email;

                    Navigator.popUntil(context, (route) => route.isFirst);
                    Navigator.pushReplacement(
                      context,
                      PageRouteBuilder(
                        transitionDuration: Duration.zero,
                        pageBuilder: (_, __, ___) => const MyHomePage(),
                      ),
                    );
                  },
                  child: const Text('Return to Authorization'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

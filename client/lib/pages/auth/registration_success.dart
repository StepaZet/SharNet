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
            Text(
              'A verification email has been sent to $email. Please confirm to activate your account.',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 48),
            ElevatedButton(
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
              child: const Text('Return to Login'),
            ),
          ],
        ),
      ),
    );
  }
}

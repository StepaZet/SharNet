import 'package:client/api/firebase.dart';
import 'package:client/pages/auth/forget_password.dart';
import 'package:flutter/material.dart';

import 'package:client/api/profile.dart';
import 'package:client/models/config.dart';
import 'package:client/models/profile_info.dart';
import 'package:client/pages/navigation_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final passwordErrorProvider = StateProvider<String>((ref) => '');
final obscureTextProvider = StateProvider<bool>((ref) => true);


class LoginPage extends ConsumerWidget {
  final String email;

  const LoginPage({super.key, this.email = ""});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = TextEditingController();
    final formKey = GlobalKey<FormState>();


    return Scaffold(
      appBar: AppBar(
        title: const Text('Authorization'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Consumer(builder: (context, ref, child) {
              final passwordError = ref.watch(passwordErrorProvider);
              final obscureText = ref.watch(obscureTextProvider);

              return Form(
                key: formKey,
                child: TextFormField(
                  controller: controller,
                  obscureText: obscureText,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    border: const OutlineInputBorder(),
                    suffixIcon: IconButton(
                      icon: Icon(obscureText ? Icons.visibility_off : Icons.visibility),
                      onPressed: () {
                        ref.read(obscureTextProvider.notifier).state = !obscureText;
                      },
                    ),
                    errorText: passwordError.isNotEmpty ? passwordError : null,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty || value.length < 6) {
                      return 'Password must be at least 6 characters long';
                    }
                    return null;
                  },
                ),
              );
            }),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ForgetPasswordPage(),
                    ),
                  );
                },
                child: const Text('Forgot password?'),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                if (!formKey.currentState!.validate()) {
                  return;
                }

                var loginResult = await loginUser(email, controller.text);

                if (loginResult.resultStatus == ResultEnum.wrongPassword) {
                  ref.read(passwordErrorProvider.notifier).state = 'Incorrect password';
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
              child: const Text('Continue'),
            ),
            const Divider(),
            TextButton(
              onPressed: () {

              },
              child: const Text('Sign up with Google'),
            ),
            TextButton(
              onPressed: () {
                // TODO: Add Sign up with Apple functionality
              },
              child: const Text('Sign up with Apple'),
            ),
            const Spacer(),
            // TextButton(
            //   onPressed: () {
            //     // TODO: Navigate to sign up page
            //   },
            //   child: const Text("Don't have an account? Sign up"),
            // ),
          ],
        ),
      ),
    );
  }
}
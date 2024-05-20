import 'package:client/models/profile_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:client/api/profile.dart';

final passwordErrorProvider = StateProvider<String>((ref) => '');
final obscureTextProvider = StateProvider<bool>((ref) => true);

final tokenErrorProvider = StateProvider<String>((ref) => '');

final showReturnButtonProvider = StateProvider<bool>((ref) => false);

class ResetPasswordPage extends ConsumerWidget {
  const ResetPasswordPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formKey = GlobalKey<FormState>();
    final passwordController = TextEditingController();
    final tokenController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Reset password'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Consumer(builder: (context, ref, child) {
                final tokenError = ref.watch(tokenErrorProvider);

                return TextFormField(
                  controller: tokenController,
                  decoration: InputDecoration(
                    labelText: 'Token',
                    errorText: tokenError.isNotEmpty ? tokenError : null,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your code from email';
                    }
                    return null;
                  },
                );
              }),
              const SizedBox(height: 16),
              Consumer(builder: (context, ref, child) {
                final passwordError = ref.watch(passwordErrorProvider);
                final obscureText = ref.watch(obscureTextProvider);

                return TextFormField(
                  controller: passwordController,
                  obscureText: obscureText,
                  decoration: InputDecoration(
                    labelText: 'New password',
                    errorText: passwordError.isNotEmpty ? passwordError : null,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty || value.length < 6) {
                      return 'Password must be at least 6 characters long';
                    }
                    return null;
                  },
                );
              }),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  if (formKey.currentState!.validate()) {
                    var response = await resetPassword(
                      passwordController.text,
                      tokenController.text,
                    );

                    if (response.resultStatus == ResultEnum.unknownToken) {
                      ref.read(tokenErrorProvider.notifier).state =
                          'Unknown code';
                      return;
                    } else {
                      ref.read(tokenErrorProvider.notifier).state = '';
                    }

                    if (response.resultStatus == ResultEnum.wrongPassword) {
                      var messages = response.resultData;

                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(messages.join('\n')),
                      ));
                      return;
                    }

                    ref.read(showReturnButtonProvider.notifier).state = true;
                  }
                },
                child: const Text('Reset password'),
              ),
              const SizedBox(height: 16),
              Consumer(builder: (context, ref, child) {
                final showReturnButton = ref.watch(showReturnButtonProvider);

                if (showReturnButton) {
                  return ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('Return'),
                  );
                }

                return const SizedBox.shrink();
              }),
            ],
          ),
        ),
      ),
    );
  }
}

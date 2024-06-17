import 'package:client/firebase_options.dart';
import 'package:client/pages/navigation_bar.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: "assets/.env");
  Stripe.publishableKey=dotenv.env["STRIPE_PUBLISH_KEY"]!;
  await Stripe.instance.applySettings();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SharkNet',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

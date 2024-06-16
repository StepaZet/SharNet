import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;


Future<String?> initPaymentSheet(String amount) async {
  try {
    final data = await createPaymentIntent(amount: amount);

    await Stripe.instance.initPaymentSheet(
      paymentSheetParameters: SetupPaymentSheetParameters(
        // Set to true for custom flow
        customFlow: false,
        merchantDisplayName: 'Test Merchant',
        paymentIntentClientSecret: data['client_secret'],
        // Customer keys
        customerEphemeralKeySecret: data['ephemeralKey'],
        customerId: data['id'],

        style: ThemeMode.dark,
      ),
    );

    return null;

    // await Stripe.instance.confirmSetupIntent(
    //   paymentIntentClientSecret: 'seti_1PBH6nDLM6oDWN5zWtTlMQBF_secret_Q1JkP13A2dfF16CnEMb97qd4I16T0SB',
    //   params: const PaymentMethodParams.card(
    //     paymentMethodData: PaymentMethodData(
    //       billingDetails: BillingDetails()
    //     ),
    //   ),
    // );
  } catch (e) {
    return e.toString();
  }
}

Future<dynamic> createPaymentIntent({required String amount}) async {

  final params = {
    "amount": "${amount}00",
    "currency": "usd",
    "automatic_payment_methods[enabled]": "true",
    "description": "Test donate",
    "shipping[name]": "anim",
    "receipt_email": "sckremyulock@gmail.com",
    "shipping[address][line1]": "foo",
    "shipping[address][postal_code]": "228",
    "shipping[address][city]": "bar",
    "shipping[address][state]": "test",
    "shipping[address][country]": "russia"
  };

  var url = Uri.https("api.stripe.com", "/v1/payment_intents", params);
  final secretKey = dotenv.env["STRIPE_SECRET_KEY"]!;

  var response = await http.post(url,
      headers: {
        'Authorization': 'Bearer $secretKey',
        'Content-Type': 'application/x-www-form-urlencoded'
      },
  );

  if (response.statusCode == 200) {
    var json = jsonDecode(response.body);
    print(json);
    return json;
  } else {
    return null;
  }
}

import 'package:client/components/styles.dart';
import 'package:client/pages/profile/payment.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

final donateProvider = StateProvider<String>((ref) => '');

class DonatePage extends StatelessWidget {
  const DonatePage({super.key});

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    final _amountController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Donate'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Consumer(builder: (context, ref, child) {
                final dataModel = ref.watch(donateProvider);

                _amountController.text = dataModel;

                return TextField(
                  style: formTextStyle,
                  controller: _amountController,
                  decoration: formFieldStyleWithLabel('Amount',
                      iconButton: const IconButton(
                        icon: Icon(Icons.attach_money_outlined, color: Colors.black38),
                        onPressed: null,
                      )),
                  keyboardType: TextInputType.emailAddress,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  onChanged: (value) {
                    ref.read(donateProvider.notifier).state = value;
                  },
                );
              }),
              const SizedBox(height: 16),
              Consumer(builder: (context, ref, child) {
                const paymentCounts = [1, 5, 10, 20];

                return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: paymentCounts.map((paymentCount) {
                      return ElevatedButton(
                        style: buttonStyle,
                        onPressed: () {
                          ref.read(donateProvider.notifier).state = paymentCount.toString();
                        },
                        child: Text('$paymentCount\$'),
                      );
                    }).toList());
              }),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: accentButtonStyle,
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      var error = await initPaymentSheet(_amountController.text);

                      if (error != null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Error: $error'),
                          ),
                        );
                        return;
                      }

                      try {
                        await Stripe.instance.presentPaymentSheet();

                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text(
                            "Payment Successful",
                            style: TextStyle(color: Colors.white),
                          ),
                          backgroundColor: Colors.green,
                        ));
                      } catch (e) {
                        print("payment sheet failed");
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text(
                            "Payment Failed",
                            style: TextStyle(color: Colors.white),
                          ),
                          backgroundColor: Colors.redAccent,
                        ));
                      }
                    }
                  },
                  child: const Text('Donate'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

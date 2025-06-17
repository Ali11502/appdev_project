import '../components/my_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';
import 'package:provider/provider.dart';
import 'delivery_progress_page.dart';
import '../providers/payment_provider.dart';

class PaymentPage extends StatelessWidget {
  const PaymentPage({super.key});

  void userTappedPay(BuildContext context, PaymentProvider paymentProvider) {
    // Check if form is valid before showing dialog
    if (paymentProvider.validateForm()) {
      showDialog(
        context: context,
        builder:
            (context) => AlertDialog(
              title: const Text("Confirm payment"),
              content: SingleChildScrollView(
                child: ListBody(
                  children: [
                    Text("Card Number: ${paymentProvider.cardNumber}"),
                    Text("Expiry Date: ${paymentProvider.expiryDate}"),
                    Text("Card Holder name: ${paymentProvider.cardHolderName}"),
                    Text("CVV: ${paymentProvider.cvvCode}"),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Cancel"),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const DeliveryProgressPage(),
                      ),
                    );
                  },
                  child: const Text("Yes"),
                ),
              ],
            ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => PaymentProvider(),
      child: Consumer<PaymentProvider>(
        builder: (context, paymentProvider, child) {
          return Scaffold(
            backgroundColor: Theme.of(context).colorScheme.surface,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              foregroundColor: Theme.of(context).colorScheme.inversePrimary,
              title: const Text("Checkout"),
              centerTitle: true,
            ),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  CreditCardWidget(
                    cardNumber: paymentProvider.cardNumber,
                    expiryDate: paymentProvider.expiryDate,
                    cardHolderName: paymentProvider.cardHolderName,
                    cvvCode: paymentProvider.cvvCode,
                    showBackView: paymentProvider.isCvvFocused,
                    onCreditCardWidgetChange: (p0) {},
                  ),
                  CreditCardForm(
                    cardNumber: paymentProvider.cardNumber,
                    expiryDate: paymentProvider.expiryDate,
                    cardHolderName: paymentProvider.cardHolderName,
                    cvvCode: paymentProvider.cvvCode,
                    onCreditCardModelChange: (data) {
                      paymentProvider.updateCreditCardData(
                        cardNumber: data.cardNumber,
                        expiryDate: data.expiryDate,
                        cardHolderName: data.cardHolderName,
                        cvvCode: data.cvvCode,
                      );
                    },
                    formKey: paymentProvider.formKey,
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.1),
                  MyButton(
                    text: "Pay now",
                    onTap: () => userTappedPay(context, paymentProvider),
                  ),
                  const SizedBox(height: 25),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

import 'package:flutter/material.dart';

class PaymentProvider extends ChangeNotifier {
  String _cardNumber = '';
  String _expiryDate = '';
  String _cardHolderName = '';
  String _cvvCode = '';
  bool _isCvvFocused = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String get cardNumber => _cardNumber;
  String get expiryDate => _expiryDate;
  String get cardHolderName => _cardHolderName;
  String get cvvCode => _cvvCode;
  bool get isCvvFocused => _isCvvFocused;
  GlobalKey<FormState> get formKey => _formKey;

  void updateCreditCardData({
    required String cardNumber,
    required String expiryDate,
    required String cardHolderName,
    required String cvvCode,
  }) {
    _cardNumber = cardNumber;
    _expiryDate = expiryDate;
    _cardHolderName = cardHolderName;
    _cvvCode = cvvCode;
    notifyListeners();
  }

  bool validateForm() {
    return _formKey.currentState?.validate() ?? false;
  }
}

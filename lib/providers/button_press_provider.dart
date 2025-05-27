import 'package:flutter/material.dart';

class ButtonPressProvider extends ChangeNotifier {
  bool _isPressed = false;

  bool get isPressed => _isPressed;

  void setPressed(bool pressed) {
    if (_isPressed != pressed) {
      _isPressed = pressed;
      notifyListeners();
    }
  }

  void onTapDown() {
    setPressed(true);
  }

  void onTapUp() {
    setPressed(false);
  }

  void onTapCancel() {
    setPressed(false);
  }
}

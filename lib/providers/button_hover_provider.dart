import 'package:flutter/material.dart';

class ButtonHoverProvider extends ChangeNotifier {
  bool _isHovered = false;

  bool get isHovered => _isHovered;

  void setHovered(bool hovered) {
    if (_isHovered != hovered) {
      _isHovered = hovered;
      notifyListeners();
    }
  }

  void onEnter() {
    setHovered(true);
  }

  void onExit() {
    setHovered(false);
  }
}

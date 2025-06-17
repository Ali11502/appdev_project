import 'package:flutter/material.dart';
import '../services/auth/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();

  bool _isEmailLoginLoading = false;
  bool _isEmailRegisterLoading = false;
  bool _isGoogleLoginLoading = false;

  String? _errorMessage;

  bool get isEmailLoginLoading => _isEmailLoginLoading;
  bool get isEmailRegisterLoading => _isEmailRegisterLoading;
  bool get isGoogleLoginLoading => _isGoogleLoginLoading;
  String? get errorMessage => _errorMessage;
  bool get isAnyLoading =>
      _isEmailLoginLoading || _isEmailRegisterLoading || _isGoogleLoginLoading;

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  Future<void> signInWithEmail(String email, String password) async {
    if (_isEmailLoginLoading) return;

    _isEmailLoginLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _authService.signInWithEmailPassword(email, password);
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isEmailLoginLoading = false;
      notifyListeners();
    }
  }

  Future<void> signUpWithEmail(
    String email,
    String password,
    String confirmPassword,
  ) async {
    if (_isEmailRegisterLoading) return;

    if (password != confirmPassword) {
      _errorMessage = "Passwords don't match";
      notifyListeners();
      return;
    }

    _isEmailRegisterLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _authService.signUpWithEmailPassword(email, password);
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isEmailRegisterLoading = false;
      notifyListeners();
    }
  }

  Future<void> signInWithGoogle() async {
    if (_isGoogleLoginLoading) return;

    _isGoogleLoginLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _authService.signInWithGoogle();
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isGoogleLoginLoading = false;
      notifyListeners();
    }
  }

  Future<void> signOut() async {
    try {
      await _authService.signOut();
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  String? getCurrentUserEmail() {
    return _authService.getCurrentUser()?.email;
  }

  String? getCurrentUserName() {
    return _authService.getUserDisplayName();
  }

  String? getCurrentUserPhotoURL() {
    return _authService.getUserPhotoURL();
  }

  bool isSignedInWithGoogle() {
    return _authService.isSignedInWithGoogle();
  }
}

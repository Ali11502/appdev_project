import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

//164181385221-h4il770q0qc922n29qcdvhs1tvcv0q6t.apps.googleusercontent.com
import 'package:flutter/foundation.dart' show kIsWeb;

class AuthService {
  // Get instance of firebase auth
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  // Initialize GoogleSignIn with web client ID for web platform
  late final GoogleSignIn _googleSignIn = GoogleSignIn(
    // Replace with your actual web client ID from Firebase Console
    clientId:
        kIsWeb
            ? '164181385221-h4il770q0qc922n29qcdvhs1tvcv0q6t.apps.googleusercontent.com'
            : null,
  );

  // Get current user
  User? getCurrentUser() {
    return _firebaseAuth.currentUser;
  }

  // Sign in with email and password
  Future<UserCredential> signInWithEmailPassword(String email, password) async {
    try {
      UserCredential userCredential = await _firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);

      return userCredential;
    }
    // Catch any errors
    on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }
  }

  // Sign up with email and password
  Future<UserCredential> signUpWithEmailPassword(String email, password) async {
    try {
      UserCredential userCredential = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);

      return userCredential;
    }
    // Catch any errors
    on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }
  }

  // Sign in with Google
  Future<UserCredential?> signInWithGoogle() async {
    try {
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      // If user cancels the sign-in process
      if (googleUser == null) {
        return null;
      }

      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in to Firebase with the Google credentials
      UserCredential userCredential = await _firebaseAuth.signInWithCredential(
        credential,
      );

      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    } catch (e) {
      throw Exception('Google sign-in failed: $e');
    }
  }

  // Sign out
  Future<void> signOut() async {
    // Sign out from Firebase
    await _firebaseAuth.signOut();

    // Sign out from Google (if signed in with Google)
    await _googleSignIn.signOut();
  }

  // Check if user is signed in with Google
  bool isSignedInWithGoogle() {
    final user = _firebaseAuth.currentUser;
    if (user != null) {
      for (UserInfo userInfo in user.providerData) {
        if (userInfo.providerId == 'google.com') {
          return true;
        }
      }
    }
    return false;
  }

  // Get user display name (useful for Google sign-in)
  String? getUserDisplayName() {
    return _firebaseAuth.currentUser?.displayName;
  }

  // Get user photo URL (useful for Google sign-in)
  String? getUserPhotoURL() {
    return _firebaseAuth.currentUser?.photoURL;
  }
}

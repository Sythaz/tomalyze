import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class AuthenticationProvider with ChangeNotifier {
  User? user;

  AuthenticationProvider() {
    FirebaseAuth.instance.authStateChanges().listen((userData) {
      user = userData;
      notifyListeners();
    });
  }

  User? get currentUser => user;

  bool get isLoggedIn => user != null;

  Future<void> logout() async {
    await FirebaseAuth.instance.signOut();
  }
}

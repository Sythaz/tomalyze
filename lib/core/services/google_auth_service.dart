import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleAuthService {
  static final GoogleSignIn _googleSignIn = GoogleSignIn.instance;

  static bool isInitialize = false;

  static Future<void> initSignIn() async {
    if (!isInitialize) {
      await _googleSignIn.initialize();
      isInitialize = true;
    }
  }

  Future<UserCredential?> signInWithGoogleFirebase() async {
    await GoogleSignIn.instance.initialize();

    await initSignIn();

    // STEP 1 - Google Sign-In
    final GoogleSignInAccount googleUser = await _googleSignIn.authenticate();

    final googleAuth = googleUser.authentication;

    // STEP 2 - Login ke Firebase
    final credential = GoogleAuthProvider.credential(
      idToken: googleAuth.idToken,
    );
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }
}

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

class FirebaseService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FacebookAuth _facebookAuth = FacebookAuth.instance;

  Stream<User?> get onAuthStateChanged {
    return _firebaseAuth.authStateChanges();
  }

  Future<User?> signInWithFaceBook() async {
    try {
      final LoginResult loginResult = await _facebookAuth.login();
      if (loginResult.status == LoginStatus.success) {
        final OAuthCredential oAuthCredential =
            FacebookAuthProvider.credential(loginResult.accessToken!.token);
        UserCredential userCredential = await _firebaseAuth.signInWithCredential(oAuthCredential);
        return userCredential.user;
      }
      return null;
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future signOut() async {
    try {
      await _firebaseAuth.signOut();
    } catch (e) {
      print(e);
    }
  }
}

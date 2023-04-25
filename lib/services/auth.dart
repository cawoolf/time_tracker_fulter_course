import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';

abstract class AuthBase {
  User? get currentUser;

  Stream<User?> authStateChanges();

  Future<User?> signInAnonymously();

  Future<void> signOut();

  Future<User?> signInWithGoogle();

  Future<User?> signInWithGoogleWeb();

}

class Auth extends AuthBase {
  final _firebaseAuth = FirebaseAuth.instance;

  // Notifies about changes to the User's signIn state
  @override
  Stream<User?> authStateChanges() => _firebaseAuth.authStateChanges();

  @override
  User? get currentUser => _firebaseAuth.currentUser;

  @override
  Future<User?> signInAnonymously() async {
    final userCredential = await _firebaseAuth.signInAnonymously();
    return userCredential.user;
  }

  @override
  Future<User?> signInWithGoogle() async {

    final googleClientID = '445096508808-94jffvm1fkj3qnnut0cosmcs9trl3n7f.apps.googleusercontent.com';
    final googleSignIn = GoogleSignIn(clientId: googleClientID);

    final googleUser = await googleSignIn.signIn();

    if (googleUser != null) {
      final googleAuth = await googleUser.authentication;
      if (googleAuth.idToken != null) {
        final userCredential = await _firebaseAuth.signInWithCredential(
            GoogleAuthProvider.credential(
                idToken: googleAuth.idToken,
                accessToken: googleAuth.accessToken));

        return userCredential.user;
      } else {
        throw FirebaseAuthException(
            code: 'ERROR MISSING GOOGLE ID TOKEN',
            message: 'Missing Google ID Token');
      }
    } else {
      throw FirebaseAuthException(
          code: 'ERROR ABORTED BY USER', message: 'Sign in aborted by User');
    }
  }


  // I don't really understand why this works.. TBH.
  // Where is the clientID and why don't I need it for the web signIn
  @override
  Future<User?> signInWithGoogleWeb() async {

    if (kIsWeb) {
      GoogleAuthProvider authProvider = GoogleAuthProvider();

      try {
        final UserCredential userCredential =
        await _firebaseAuth.signInWithPopup(authProvider);

        return userCredential.user;
      } catch (e) {
        print(e);
      }
  }

}

  @override
  Future<void> signOut() {
    // TODO: implement signOut
    throw UnimplementedError();
  }
}


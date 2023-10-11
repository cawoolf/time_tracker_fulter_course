import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:time_tracker_flutter_course/services/web_config.dart';

abstract class AuthBase {
  User? get currentUser;

  Stream<User?> authStateChanges();

  Future<User?> signInAnonymously();

  Future<void> signOut();

  Future<User?> signInWithGoogle();

  Future<User?> signInWithGoogleWeb();

  Future<User?> signInWithEmailAndPassword(String email, String password);

  Future<User?> createUserWithEmailAndPassword(String email, String password);
}

class Auth extends AuthBase {
  final _firebaseAuth = FirebaseAuth.instance;

  // When logging into web apparently you don't' need to pass the googleClientId to FireBaseAuth. I don't fully understand it. But you do need it to SignOut();
  String? get _googleClientId => kIsWeb
      ? WebConfig.googleClientId // Grab the googleClientId from a .gitignore config file for web. This should theoretically work for all platforms.
      : Platform.environment['google_client_id']; // Grab the googleClientId from the system environment variables for mobile

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
  Future<User?> signInWithEmailAndPassword(
      String email, String password) async {
    final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
    return userCredential.user;
  }

  @override
  Future<User?> createUserWithEmailAndPassword(
      String email, String password) async {
    final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);
    return userCredential.user;
  }

  @override
  Future<User?> signInWithGoogle() async {
    final googleSignIn = GoogleSignIn(clientId: _googleClientId);

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
    GoogleAuthProvider authProvider = GoogleAuthProvider();
    try {
      final UserCredential userCredential =
          await _firebaseAuth.signInWithPopup(authProvider);

      return userCredential.user;
    } catch (e) {
      print(e);
    }
    return null;
  }

  @override
  Future<void> signOut() async {
    print("Sign Out Clicked");
    final googleSignIn = GoogleSignIn(clientId: _googleClientId);
    await googleSignIn.signOut();
    await _firebaseAuth.signOut();
  }
}

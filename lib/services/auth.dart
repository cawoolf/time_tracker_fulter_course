import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthBase {
  User?  get currentUser;
  Stream<User?> authStateChanges ();
  Future<User?> signInAnonymously ();
  Future<void> signOut();

}

class Auth extends AuthBase {


  final _firebaseAuth = FirebaseAuth.instance;

  // Notifies about changes to the User's signIn state
  @override
  Stream<User?> authStateChanges ()=> _firebaseAuth.authStateChanges();

  @override
  User?  get currentUser => _firebaseAuth.currentUser;

  @override
  Future<User?> signInAnonymously () async {
    final userCredential = await _firebaseAuth.signInAnonymously();
    return userCredential.user;
  }

  @override
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

}
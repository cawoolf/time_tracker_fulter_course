import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:time_tracker_flutter_course/services/auth.dart';


class SignInBloc {
  SignInBloc({required this.auth, required this.isLoading});
  final AuthBase auth;
  final ValueNotifier<bool> isLoading;

  // Converting to from StreamController to Value Notifier
  // final StreamController<bool> _isLoadingController =
  //     StreamController<bool>(); // Constructor with type <Type>, Only takes boolean values into the Stream? Correct
  //
  // Stream<bool> get isLoadingStream =>
  //     _isLoadingController.stream; // Public getter Accessed by the SignInPage
  //
  // void dispose() {
  //   _isLoadingController.close();
  // }
  //
  // // adds the isLoading var to the Sink of the Controller
  // // Only takes boolean values into the Stream. Other types give an error;
  // void _setIsLoading(bool isLoading) => _isLoadingController.add(isLoading);


  // method that takes another method as an argument
  Future<User?> _signIn(Future<User?> Function() signInMethod) async {
    try {
      isLoading.value = true;
      return await signInMethod();

    } catch (e) {
      isLoading.value = false;
      rethrow;
    }
  }

  Future<void> signInAnonymously() async => await _signIn(auth.signInAnonymously);
  Future<void> signInWithGoogleWeb() async => await _signIn(auth.signInWithGoogleWeb);
  Future<void> signInWithGoogle() async => await _signIn(auth.signInWithGoogle);
  Future<void> signInWithFacebook() async => await _signIn(auth.signInAnonymously);
}

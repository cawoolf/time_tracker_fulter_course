import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker_flutter_course/app/sign_in/email_sign_in_page.dart';
import 'package:time_tracker_flutter_course/app/sign_in/sign_in_bloc.dart';
import 'package:time_tracker_flutter_course/app/sign_in/sign_in_button.dart';
import 'package:time_tracker_flutter_course/app/sign_in/social_sign_in_button.dart';
import 'package:time_tracker_flutter_course/common_widgets/show_exception_alert_dialog.dart';
import 'package:time_tracker_flutter_course/services/auth.dart';


class SignInBloc {
  SignInBloc({required this.auth});
  final AuthBase auth;

  final StreamController<bool> _isLoadingController =
      StreamController<bool>(); // Constructor with type <Type>, Only takes boolean values into the Stream? Correct

  Stream<bool> get isLoadingStream =>
      _isLoadingController.stream; // Public getter Accessed by the SignInPage

  void dispose() {
    _isLoadingController.close();
  }

  // adds the isLoading var to the Sink of the Controller
  // Only takes boolean values into the Stream. Other types give an error;
  void _setIsLoading(bool isLoading) => _isLoadingController.add(isLoading);


  // method that takes another method as an argument
  Future<User?> _signIn(Future<User?> Function() signInMethod) async {
    try {
      _setIsLoading(true);
      return await signInMethod();
    } catch (e) {
      rethrow; // Toss the exception back to the calling method
    }
    finally {
      _setIsLoading(false);
    }
  }

  Future<void> signInAnonymously() async => await _signIn(auth.signInAnonymously);
  Future<void> signInWithGoogleWeb() async => await _signIn(auth.signInWithGoogleWeb);
  Future<void> signInWithGoogle() async => await _signIn(auth.signInWithGoogle);
  Future<void> signInWithFacebook() async => await _signIn(auth.signInAnonymously);
}

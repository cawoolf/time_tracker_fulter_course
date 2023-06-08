import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/diagnostics.dart';
import 'auth.dart';

class AuthProvider extends InheritedWidget {
  const AuthProvider({super.key, required this.auth, required super.child});

  final AuthBase auth;

  // AuthProvider needs a child so that it can be inserted into the WidgetTree


  @override
  bool updateShouldNotify(InheritedWidget oldWidget) =>
      false; // Will explain later

  // Static methods can be directly called with out creating an Object of the parent class.
  // Used to define class members of variables.
  static AuthBase? of(BuildContext context) {
    final AuthProvider? provider = context.dependOnInheritedWidgetOfExactType<AuthProvider>();
    return provider?.auth;
  }
// final auth = AuthProvider.of(context)

}
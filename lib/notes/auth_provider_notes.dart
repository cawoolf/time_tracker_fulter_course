import 'package:flutter/material.dart';
import '../services/auth.dart';


class AuthProviderNotes extends InheritedWidget {
  const AuthProviderNotes({super.key, required this.auth, required super.child});

  final AuthBase auth;

  // AuthProvider needs a child so that it can be inserted into the WidgetTree


  @override
  bool updateShouldNotify(InheritedWidget oldWidget) =>
      false; // Will explain later

  // Static methods can be directly called with out creating an Object of the parent class.
  // Used to define class members of variables.
  // Traverses up the widget tree to find a the Provider
  static AuthBase? of(BuildContext context) {
    final AuthProviderNotes? provider = context.dependOnInheritedWidgetOfExactType<AuthProviderNotes>();
    return provider?.auth;
  }
// final auth = AuthProvider.of(context)

}
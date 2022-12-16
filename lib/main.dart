import 'package:flutter/material.dart';
import 'package:time_tracker_flutter_course/app/sign_in/sign_in_page.dart';

// Main entry point for the entire Flutter app
void main() {
  runApp(const MyApp()); // Takes a root/home Widget for the app
}

// The Home/Root Widget for the App
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // MaterialApp container for the Widget. Pretty standard.
    return MaterialApp(
      title: "Time Tracker",

      theme: ThemeData(
        primarySwatch: Colors.indigo
      ),

      home: const SignInPage(),

    );
  }
  
}
import 'package:flutter/material.dart';
import 'package:time_tracker_flutter_course/app/sign_in/sign_in_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

// Main entry point for the entire Flutter app
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  //await stops code execution until the Future has been returned.
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
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
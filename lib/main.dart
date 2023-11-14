import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker_flutter_course/app/landing_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:time_tracker_flutter_course/services/auth.dart';
import 'package:time_tracker_flutter_course/services/database.dart';
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
    /*
    MaterialApp is the container for the Parent Widget of the whole app. It's a child
    of AuthProvider so that other Widgets can navigate up the tree to access Auth.
     */
    print('main.dart line 29: App Launched');
    return Provider<AuthBase>(
        create: (context) => Auth(),
        child: MaterialApp(
          title: "Time Tracker",
          theme: ThemeData(primarySwatch: Colors.indigo),
          home: LandingPage(databaseBuilder: (uid) => FirestoreDatabase(uid: uid)),
        ));
  }
}

import 'package:flutter/material.dart';
import 'package:time_tracker_flutter_course/app/sign_in/email_sign_in_form_change_notifier.dart';

class EmailSignInPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sign In"),
        elevation: 2.0,
      ),
      body: SingleChildScrollView( // Wrapping with a ScrollView adds Scrolling for small Screens. A single widget can be Scrolled.
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Card(child: EmailSignInFormChangeNotifier.create(context)),
        ),
      ),
      backgroundColor: Colors.grey[200],
    );
  }
}

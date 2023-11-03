import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:time_tracker_flutter_course/common_widgets/show_alert_dialog.dart';

// Useful for handling different types of Exceptions

Future<void> showExceptionAlertDialog(BuildContext context,
        {required String title, required Exception exception}) async => //Arrow notation to return a showAlertDialog
    showAlertDialog(context,
        title: title, content: _message(exception).toString(), defaultActionText: 'Okayyzzz');


// Longhand and version. Use this becuase we are getting some kind of Firebase Exception issue
// Can't get the web app to throw Firebase Exceptions. Only generic Objects.
Future<void> showExceptionAlertDialog2(BuildContext context,
    {required String title, required String errorMessage}) async {

  return showAlertDialog(context,
      title: title, content: errorMessage.toString(), defaultActionText: 'Ok');
}

String? _message(Exception exception) {
  if(exception is FirebaseException) {
    return exception.message;
  }
  return exception.toString();
}

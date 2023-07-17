import 'dart:html';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:time_tracker_flutter_course/common_widgets/show_alert_dialog.dart';

// Useful for handling different types of Exceptions

Future<void> showExceptionAlertDialog(BuildContext context,
        {required String title, required Exception exception}) async => //Arrow notation to return a showAlertDialog
    showAlertDialog(context,
        title: title, content: _message(exception).toString(), defaultActionText: 'Okayyzzz');


// Longhand and version
Future<void> showExceptionAlertDialog2(BuildContext context,
    {required String title, required Exception exception}) async {

  return showAlertDialog(context,
      title: title, content: exception.toString(), defaultActionText: 'Ok');
}

String? _message(Exception exception) {
  if(exception is FirebaseException) {
    return exception.message;
  }
  return exception.toString();
}
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/* The { } are used to define named parameters. When you use this method in other classes,
you will see the name of the variable you are passing an argument to. */
Future showAlertDialog(
  BuildContext context, {
  required String title,
  required String content,
  required String defaultActionText,
  String? cancelActionText,
}) {
  // Returns a regularAlertDialog if the Platform is web or any other OS beside iOS
  if (kIsWeb || !Platform.isIOS) {
    print('Inside Platform if');
    return showDialog(
        context: context,
        barrierDismissible: false, // Makes it so you cannot dismiss the dialog by clicking outside it.
        builder: (context) => AlertDialog(
                title: Text(title),
                content: Text(content),
                actions: <Widget>[
                  if (cancelActionText !=
                      null) // Example of collection if in dart. It's inside the builder.
                    ElevatedButton(
                        onPressed: () => Navigator.of(context).pop(false), // Does not pop the last displayed page off the stack, and causes the method to return false
                        child: Text(cancelActionText)),
                  ElevatedButton(
                      onPressed: () => Navigator.of(context).pop(true), // Pops the last displayed page off the stack, and causes the method to return true
                      child: Text(defaultActionText))
                ]));
  }
  return showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
              title: Text(title),
              content: Text(content),
              actions: <Widget>[
                if (cancelActionText !=
                    null) // Example of collection if in dart. It's inside the builder.
                  CupertinoButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      child: Text(cancelActionText)),
               CupertinoButton(
                    onPressed: () => Navigator.of(context).pop(true),
                    child: Text(defaultActionText))
              ]));
}

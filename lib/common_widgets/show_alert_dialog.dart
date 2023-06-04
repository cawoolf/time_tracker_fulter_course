import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Future showAlertDialog(BuildContext context,
    {required String title,
    required String content,
    required String defaultActionText}) {
  if (!Platform.isIOS) { // Bug is occuring here for Error: Unsupported operation: Platform._operatingSystem
    print('Inside Platform if');
    return showDialog(
        context: context,
        builder: (context) => AlertDialog(
                title: Text(title),
                content: Text(content),
                actions: <Widget>[
                  ElevatedButton(
                      onPressed: () => Navigator.of(context).pop(true),
                      child: Text(defaultActionText))
                ]));
  }
  return showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
          title: Text(title),
          content: Text(content),
          actions: <Widget>[
            ElevatedButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: Text(defaultActionText))
          ]));
}

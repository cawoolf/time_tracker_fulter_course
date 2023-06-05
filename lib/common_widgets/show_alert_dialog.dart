import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

Future showAlertDialog(BuildContext context,
    {required String title,
    required String content,
    required String defaultActionText}) {
  // Returns a regularAlertDialog if the Platform is web or any other OS beside iOS
  if (kIsWeb || !Platform.isIOS) {
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

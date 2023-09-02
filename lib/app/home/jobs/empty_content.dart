import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class EmptyContent extends StatelessWidget {

  const EmptyContent(
      {Key? key}) : super(key: key);

  final String title = 'Nothing here';
  final String message = 'Add a new item to get started.';

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(title,
        style: const TextStyle(
          fontSize: 30,
          color: Colors.black,
        )),
        Text(title,
        style: const TextStyle(
          fontSize: 30,
          color: Colors.black
        ),),

      ],
    );
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SignInPage extends StatelessWidget {
  const SignInPage({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: const Text("Time Tracker"),
        elevation: 2.0,
      ),
      body: _buildContent(),
    );
  }

  // the _methodName is convention for making the method private
  // only accessible at the file level
  Widget _buildContent() {
    return Container(
      color: Colors.yellow,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Container(
              color: Colors.orange,
              child: const SizedBox(
                //width: 100, Don't need width field if Alignment set to stretch
                height: 100,
              )),
          Container(
              color: Colors.red,
              child: const SizedBox(
                //width: 100, Don't need width field if Alignment set to stretch
                height: 100,
              )),
          Container(
              color: Colors.purple,
              child: const SizedBox(
                //width: 100, Don't need width field if Alignment set to stretch
                height: 100,
              )),
        ],
      ), // The child of a Container can be any Widget in Flutter
    );
  }
}

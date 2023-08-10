import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AddJobPage extends StatefulWidget {
  const AddJobPage({super.key});

  static Future<void> show(BuildContext context) async {
    await Navigator.of(context).push(MaterialPageRoute( // Pushes a new route to the Navigation stack
      builder: (context) => AddJobPage(),
      fullscreenDialog: true,
    ));
  }

  @override
  State<AddJobPage> createState() => _AddJobPageState();
}

class _AddJobPageState extends State<AddJobPage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold();
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AddJobPage extends StatefulWidget {
  const AddJobPage({super.key});

  static Future<void> show(BuildContext context) async {
    await Navigator.of(context).push(MaterialPageRoute(
      // Pushes a new route to the Navigation stack
      builder: (context) => const AddJobPage(),
      fullscreenDialog: true,
    ));
  }

  @override
  State<AddJobPage> createState() => _AddJobPageState();
}

class _AddJobPageState extends State<AddJobPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 2,
        title: const Text('New Job'),
        // backgroundColor: Colors.grey[200],
      ),
      body: _buildContent(),
    );
  }

  Widget _buildContent() {
    return const SingleChildScrollView( // Essentially wrap_content with a ScrollView
      child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Card(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Placeholder(
                  color: Colors.amber,
                  fallbackHeight: 200,
                ),
          ))),
    );
  }
}

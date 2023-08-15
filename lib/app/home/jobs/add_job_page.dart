import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker_flutter_course/app/home/models/job.dart';
import 'package:time_tracker_flutter_course/services/database.dart';

class AddJobPage extends StatefulWidget {
  const AddJobPage({super.key, required this.database});
  final Database database; // Gets the database from the JobsPage context, through the show() method

  static Future<void> show(BuildContext context) async { // show() is called from the context of the JobsPage(), and can use the Provider.of<Database>
    final database = Provider.of<Database>(context, listen: false);
    await Navigator.of(context).push(MaterialPageRoute( // This creates a new Widget off the MaterialApp Widget, AddJobPage() won't have access to the Database with out constructor, since it's lower on the widget tree.
      // Pushes a new route to the Navigation stack
      builder: (context) =>  AddJobPage(database: database),
      fullscreenDialog: true,
    ));
  }

  @override
  State<AddJobPage> createState() => _AddJobPageState();
}

class _AddJobPageState extends State<AddJobPage> {
  final _formKey = GlobalKey<FormState>();
  late String _name;
  late int _ratePerHour;

  bool _validateAndSaveForm() {
    final form = _formKey.currentState;
    if(form!.validate()) {
      form.save();
      return true;
    }
      return false;
  }

  Future<void> _submit() async {

    if(_validateAndSaveForm()) {
      //final database = Provider.of<Database>(context, listen: false);
      // This won't work since the AddJobPage gets it's context from Material App.
      print('form saved, name: $_name ratePerHour: $_ratePerHour');
      final job = Job(name: _name, ratePerHour: _ratePerHour);
      await widget.database.createJob(job);
      Navigator.of(context).pop();

    }


  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 2,
        title: const Text('New Job'),
        actions: <Widget>[
          ElevatedButton(
              onPressed: _submit,
              child: const Text('Save',
                  style: TextStyle(fontSize: 18, color: Colors.white)))
        ],

        // backgroundColor: Colors.grey[200],
      ),
      body: _buildContent(),
    );
  }

  Widget _buildContent() {
    return SingleChildScrollView(
        child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Card(
                child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: _buildForm()))));
  }

  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: _buildFormChildren(),
      ),
    );
  }

  List<Widget> _buildFormChildren() {
    return [
      TextFormField(
        decoration: const InputDecoration(labelText: 'Job name'),
        validator: (value) => value!.isNotEmpty ?  null : 'Name cannot be empty',
        onSaved: (value) => _name = value!,
      ),
      TextFormField(
        decoration: const InputDecoration(labelText: 'Rate per hour'),
        keyboardType: const TextInputType.numberWithOptions(
            signed: false, decimal: false),
        onSaved: (value) => _ratePerHour = int.tryParse(value!) ?? 0,
      )
    ];
  }

}

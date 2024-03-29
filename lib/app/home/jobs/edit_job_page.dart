import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker_flutter_course/app/home/models/job.dart';
import 'package:time_tracker_flutter_course/common_widgets/show_alert_dialog.dart';
import 'package:time_tracker_flutter_course/common_widgets/show_exception_alert_dialog.dart';
import 'package:time_tracker_flutter_course/services/database.dart';

class EditJobPage extends StatefulWidget {
  const EditJobPage({super.key, required this.database, this.job});
  final Job? job;

  final Database
      database; // Gets the database from the JobsPage context, through the show() method

  static Future<void> show(BuildContext context, {required Database database, Job? job}) async {
    // show() is called from the context of the JobsPage(), and can use the Provider.of<Database>
    // rootNavigator: true alows the EditJobPage to be displayed full screen. Doesn't Navigate from the BottomNav.
    await Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(
      // This creates a new Widget off the MaterialApp Widget, AddJobPage() won't have access to the Database with out constructor, since it's lower on the widget tree.
      // Pushes a new route to the Navigation stack
      builder: (context) => EditJobPage(database: database, job: job),
      fullscreenDialog: true,
    ));
  }

  @override
  State<EditJobPage> createState() => _EditJobPageState();
}

class _EditJobPageState extends State<EditJobPage> {
  final _formKey = GlobalKey<FormState>();

  // Initial values used when the user wants to create a new Job
  String _name = '';
  int _ratePerHour = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if(widget.job != null) {
      _name = widget.job!.name;
      _ratePerHour = widget.job!.ratePerHour;

    }
  }

  bool _validateAndSaveForm() {
    final form = _formKey.currentState;
    if (form!.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  Future<void> _submit() async {
    if (_validateAndSaveForm()) {
      try {
        print('form saved, name: $_name ratePerHour: $_ratePerHour');
        final jobs = await widget.database
            .jobsStream()
            .first; // Gets the first most up to date value on the stream
        final allNames = jobs.map((job) => job?.name).toList();
        if(widget.job != null) {
          allNames.remove(widget.job?.name); // Removes the current job name from the list, and allows editing.
        }
        if (allNames.contains(_name)) { // Ensures job names are unique
          showAlertDialog(context,
              title: 'Name already used',
              content: 'Please choose a diffrent job name',
              defaultActionText: 'Ok');
        } else {
          final id = widget.job?.id ?? documentIdFromCurrentDate();  // Creates a new Job id if widget.job is null, else uses the current document id to edit a job
          final job = Job(name: _name, ratePerHour: _ratePerHour, id: id);
          await widget.database.setJob(job); // Creates a new job or edits an existing job
          Navigator.of(context).pop();
        }
      } on Exception catch (e) {
        showExceptionAlertDialog(context,
            title: 'Firebase: add_job_page -> _submit() failed', exception: e);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 2,
        title: Text(widget.job == null ? 'New Job' : 'Edit Job'),
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
        initialValue: _name,
        validator: (value) => value!.isNotEmpty ? null : 'Name cannot be empty',
        onSaved: (value) => _name = value!,
      ),
      TextFormField(
        decoration: const InputDecoration(labelText: 'Rate per hour'),
        initialValue: _ratePerHour != 0 ? '$_ratePerHour' : '',
        keyboardType: const TextInputType.numberWithOptions(
            signed: false, decimal: false),
        onSaved: (value) => _ratePerHour = int.tryParse(value!) ?? 0,
      )
    ];
  }
}

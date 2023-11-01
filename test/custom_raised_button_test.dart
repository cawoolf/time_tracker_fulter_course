import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:time_tracker_flutter_course/common_widgets/custom_raised_button.dart';

void main() {
  testWidgets('onPressed callback',(WidgetTester tester ) async {
    var pressed = false;

    await tester.pumpWidget(MaterialApp(home:CustomRaisedButton(color: Colors.black12, //Widgets should always have an ancestor MaterialApp()
    onPressed: () => pressed = true,
    child: const Text('tap me'),)));

    final button = find.byType(ElevatedButton);
    expect(button, findsOneWidget); //Finds a Widget of the type declared by button inside the hierarchy of the Widget under test.
    expect(find.byType(FloatingActionButton), findsNothing); // Expects not the find a Widget of the declared type
    expect(find.text('tap me'), findsOneWidget); //Expects to find a Widget with the text 'tap me'

    // Can test the functionality of call backs using variables and tester
    // tester has many gestures that can be tested. Must use await
    await tester.tap(button);  // Calls the onPressed callback.
    expect(pressed, true);



  });
}
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:time_tracker_flutter_course/common_widgets/custom_raised_button.dart';

void main() {
  testWidgets('',(WidgetTester tester ) async {
    await tester.pumpWidget(MaterialApp(home:CustomRaisedButton(color: Colors.black12, //Widgets should always have an ancestor MaterialApp()
    onPressed: () {  },
    child: Container(),)));
  });
}
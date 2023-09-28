import 'package:flutter/material.dart';
import 'package:time_tracker_flutter_course/app/home/tab_item.dart';

// Creates a HomeScaffold that knows about which tab we are on
// Knows how to show the bottom navigation on screen
// Allows us to swap out the UI easily if we want
class CupertinoHomeScaffold extends StatelessWidget {
  const CupertinoHomeScaffold({Key? key,
    required this.currentTab,
    required this.onSelectTab}) : super(key: key);

  final TabItem currentTab;
  final ValueChanged<TabItem> onSelectTab; //Callback
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

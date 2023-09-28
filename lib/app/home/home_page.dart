
import 'package:flutter/material.dart';
import 'package:time_tracker_flutter_course/app/home/cupertino_home_scaffold.dart';
import 'package:time_tracker_flutter_course/app/home/tab_item.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

// Keeps track of which tab we are on
class _HomePageState extends State<HomePage> {
  TabItem _currentTab = TabItem.jobs;

  void _select(TabItem tabItem) {
    setState(() => _currentTab = tabItem);
  }
  @override
  Widget build(BuildContext context) {
    return CupertinoHomeScaffold(
        currentTab: _currentTab,
        onSelectTab: _select); //Callback. Rebuilds the HomePage when tab selected
  }

}

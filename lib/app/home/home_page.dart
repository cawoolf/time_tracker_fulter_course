import 'package:flutter/material.dart';
import 'package:time_tracker_flutter_course/app/home/account/account_page.dart';
import 'package:time_tracker_flutter_course/app/home/cupertino_home_scaffold.dart';
import 'package:time_tracker_flutter_course/app/home/tab_item.dart';

import 'jobs/jobs_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

// Keeps track of which tab we are on
class _HomePageState extends State<HomePage> {
  TabItem _currentTab = TabItem.jobs;

  final Map<TabItem, GlobalKey<NavigatorState>> navigatorKeys = {
    TabItem.jobs: GlobalKey<NavigatorState>(),
    TabItem.entries: GlobalKey<NavigatorState>(),
    TabItem.account: GlobalKey<NavigatorState>(),
  };

  Map<TabItem, WidgetBuilder> get widgetBuilders {
    return {
      //Takes a context argument, but passing _ since we don't need it.
      TabItem.jobs: (_) => const JobsPage(),
      TabItem.entries: (_) => Container(),
      TabItem.account: (_) => const AccountPage(),
    };
  }

  void _select(TabItem tabItem) {
    if(tabItem == _currentTab) {
      //pop to first route
      navigatorKeys[tabItem]?.currentState?.popUntil((route) => route.isFirst);
    }
    else {
      setState(() => _currentTab = tabItem);
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async{
        // Used for handling back navigation on Android.
        // Pops the stack one at a time until it exits the app on the last pop.
        final currentState = navigatorKeys[_currentTab]?.currentState;
        if (currentState != null && currentState.canPop()) {
          currentState.pop();
          return false; // Prevents the app from closing
        } else {
          return true; // Allow the app to close
        }
      },
      child: CupertinoHomeScaffold(
          navigatorKeys: navigatorKeys,
          widgetBuilders: widgetBuilders,
          currentTab: _currentTab,
          onSelectTab: _select),
    ); //Callback. Rebuilds the HomePage when tab selected
  }
}

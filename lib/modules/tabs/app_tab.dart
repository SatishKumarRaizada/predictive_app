import 'package:flutter/material.dart';
import 'package:predictive_app/modules/home/home.dart';
import 'package:predictive_app/modules/predictive/predictive.dart';
import 'package:predictive_app/modules/prescriptive/prescriptive.dart';
import 'package:predictive_app/theme/app_color.dart';

class AppTabs extends StatefulWidget {
  const AppTabs({Key? key}) : super(key: key);
  @override
  State<AppTabs> createState() => _AppTabsState();
}

class _AppTabsState extends State<AppTabs> {
  int _selectedIndex = 1;
  NavigationRailLabelType labelType = NavigationRailLabelType.all;
  bool showLeading = false;
  bool showTrailing = false;
  double groupAligment = -1.0;
  static const _appTabs = <Widget>[HomePage(), PredictiveHome(), PrescriptiveHome()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: <Widget>[
          NavigationRail(
            selectedIndex: _selectedIndex,
            groupAlignment: groupAligment,
            useIndicator: true,
            indicatorColor: AppColor.appColor.withOpacity(0.2),
            onDestinationSelected: (int index) {
              setState(() {
                _selectedIndex = index;
              });
            },
            labelType: labelType,
            destinations: const <NavigationRailDestination>[
              NavigationRailDestination(
                icon: Icon(Icons.home_outlined),
                selectedIcon: Icon(Icons.home),
                label: Text('Home'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.analytics_outlined),
                selectedIcon: Icon(Icons.analytics),
                label: Text('Predictive Analytics'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.document_scanner_outlined),
                selectedIcon: Icon(Icons.document_scanner),
                label: Text('Prescriptive Analytics'),
              ),
            ],
          ),
          const VerticalDivider(thickness: 1, width: 1),
          // This is the main content.
          Expanded(
            child: _appTabs[_selectedIndex],
          ),
        ],
      ),
    );
  }
}

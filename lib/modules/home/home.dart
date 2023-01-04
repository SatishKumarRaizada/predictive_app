import 'package:flutter/material.dart';
import 'package:predictive_app/theme/app_color.dart';
import 'package:predictive_app/theme/app_style.dart';
import 'package:predictive_app/widgets/calendar.dart';
import 'package:table_calendar/table_calendar.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final height = size.height;
    final width = size.width;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
        actions: _getActionHeaderWidgets(),
      ),
      body: SingleChildScrollView(
          child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    width: width * 0.9,
                    child: Column(
                      children: [
                        Row(
                          children: [
                            const Text('Predictive Analytics of Gases Trends'),
                            SizedBox(width: width * 0.02),
                            Chip(
                              label: Text('Day', style: Styles.whiteText14),
                              backgroundColor: AppColor.appColor,
                            ),
                            SizedBox(width: width * 0.01),
                            const Chip(label: Text('Hour')),
                            SizedBox(width: width * 0.01),
                            const Chip(label: Text('month')),
                          ],
                        ),
                        SizedBox(height: height * 0.02),
                        Column(children: <Widget>[
                          Table(
                            border: TableBorder.all(color: AppColor.blackColor, width: 0.2),
                            children: [
                              TableRow(
                                decoration: BoxDecoration(color: AppColor.appColor),
                                children: [
                                  tableRowWidget("Gases", style: Styles.whiteText18),
                                  tableRowWidget("Check", style: Styles.whiteText18),
                                  tableRowWidget("Risk", style: Styles.whiteText18),
                                  tableRowWidget("PPM", style: Styles.whiteText18),
                                  tableRowWidget("Date", style: Styles.whiteText18),
                                  tableRowWidget("Status", style: Styles.whiteText18),
                                ],
                              ),
                              TableRow(
                                children: [
                                  tableRowWidget("Methane"),
                                  IconButton(
                                    onPressed: () {},
                                    icon: const Icon(Icons.square_outlined),
                                  ),
                                  tableRowWidget("Hydrogen"),
                                  tableRowWidget("Hydrogen"),
                                  tableRowWidget("Hydrogen"),
                                  tableRowWidget("Hydrogen"),
                                ],
                              ),
                              TableRow(
                                children: [
                                  tableRowWidget("Methane"),
                                  IconButton(
                                    onPressed: () {},
                                    icon: const Icon(Icons.square_outlined),
                                  ),
                                  tableRowWidget("Hydrogen"),
                                  tableRowWidget("Hydrogen"),
                                  tableRowWidget("Hydrogen"),
                                  tableRowWidget("Hydrogen"),
                                ],
                              ),
                              TableRow(
                                children: [
                                  tableRowWidget("Methane"),
                                  IconButton(
                                    onPressed: () {},
                                    icon: const Icon(Icons.square_outlined),
                                  ),
                                  tableRowWidget("Hydrogen"),
                                  tableRowWidget("Hydrogen"),
                                  tableRowWidget("Hydrogen"),
                                  tableRowWidget("Hydrogen"),
                                ],
                              ),
                              TableRow(
                                children: [
                                  tableRowWidget("Methane"),
                                  IconButton(
                                    onPressed: () {},
                                    icon: const Icon(Icons.square_outlined),
                                  ),
                                  tableRowWidget("Hydrogen"),
                                  tableRowWidget("Hydrogen"),
                                  tableRowWidget("Hydrogen"),
                                  tableRowWidget("Hydrogen"),
                                ],
                              ),
                            ],
                          ),
                        ])
                      ],
                    ),
                  ),
                ),
                // Work in progress
                Expanded(
                  child: SizedBox(
                    height: 300,
                    width: 100,
                    child: TableCalendar(
                      calendarStyle: const CalendarStyle(
                        cellMargin: EdgeInsets.all(0),
                        cellPadding: EdgeInsets.all(1),
                        tablePadding: EdgeInsets.all(1),
                      ),
                      shouldFillViewport: true,
                      firstDay: DateTime(2022),
                      lastDay: DateTime(2050),
                      focusedDay: DateTime.now(),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      )),
    );
  }

  List<Widget> _getActionHeaderWidgets() {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    return [
      IconButton(
        onPressed: () {},
        icon: const Icon(Icons.search),
      ),
      SizedBox(width: width * 0.02),
      IconButton(
        onPressed: () {},
        icon: const Icon(Icons.notifications),
      ),
      SizedBox(width: width * 0.02),
      IconButton(
        onPressed: () {},
        icon: const Icon(Icons.person),
      ),
    ];
  }

  Widget tableRowWidget(String value, {TextStyle style = Styles.lightText18}) {
    return Padding(padding: const EdgeInsets.all(10), child: Text(value, style: style));
  }
}

import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:predictive_app/modules/home/chart/home_chart.dart';
import 'package:predictive_app/theme/app_color.dart';
import 'package:predictive_app/theme/app_style.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<List<dynamic>> data = [];

  @override
  void initState() {
    super.initState();
    processCsv();
  }

  // Loading data from the CSV file
  processCsv() async {
    var result = await rootBundle.loadString("assets/test.csv");
    data = const CsvToListConverter().convert(result);
    return data;
  }

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
          crossAxisAlignment: CrossAxisAlignment.stretch,
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
                                  tableRowWidget("Normal"),
                                  tableRowWidget("100"),
                                  tableRowWidget("2023-01-23 23:12:00"),
                                  tableRowWidget("Green"),
                                ],
                              ),
                              TableRow(
                                children: [
                                  tableRowWidget("Methane"),
                                  IconButton(
                                    onPressed: () {},
                                    icon: const Icon(Icons.square_outlined),
                                  ),
                                  tableRowWidget("Normal"),
                                  tableRowWidget("100"),
                                  tableRowWidget("2023-01-24 23:12:00"),
                                  tableRowWidget("Green"),
                                ],
                              ),
                              TableRow(
                                children: [
                                  tableRowWidget("Methane"),
                                  IconButton(
                                    onPressed: () {},
                                    icon: const Icon(Icons.square_outlined),
                                  ),
                                  tableRowWidget("Normal"),
                                  tableRowWidget("100"),
                                  tableRowWidget("2023-01-25 23:12:00"),
                                  tableRowWidget("Green"),
                                ],
                              ),
                            ],
                          ),
                        ])
                      ],
                    ),
                  ),
                ),
                SizedBox(width: width * 0.02),
                // Work in progress
                Container(
                  height: 300,
                  width: width * 0.3,
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColor.blackColor.withOpacity(0.2), width: 0.5),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: CalendarDatePicker2(
                    config: CalendarDatePicker2Config(),
                    initialValue: [],
                  ),
                ),
              ],
            ),
            SizedBox(height: height * 0.04),
            const Text('Graph heading here', style: Styles.text20),
            SizedBox(height: height * 0.01),
            SizedBox(
              height: height * 0.35,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 20),
                decoration: BoxDecoration(
                  border: Border.all(color: AppColor.blackColor.withOpacity(0.2), width: 1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: HomePageChart(),
              ),
            )
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

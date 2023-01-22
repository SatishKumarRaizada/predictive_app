import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:predictive_app/modules/prescriptive/chart/duval_chart.dart';
import 'package:predictive_app/theme/app_color.dart';
import 'package:predictive_app/theme/app_style.dart';
import 'package:table_calendar/table_calendar.dart';

class PrescriptiveHome extends StatefulWidget {
  const PrescriptiveHome({Key? key}) : super(key: key);
  @override
  State<PrescriptiveHome> createState() => _PrescriptiveHomeState();
}

class _PrescriptiveHomeState extends State<PrescriptiveHome> {
  String htmlFilePath = 'assets/chart.html';

  @override
  void initState() {
    super.initState();
    processCsv();
  }

  processCsv() async {
    var result = await rootBundle.loadString("assets/test.csv");
    final csvTable = const CsvToListConverter().convert(result);
    return csvTable;
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final height = size.height;
    final width = size.width;
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Container(
                      width: width * 0.9,
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColor.blackColor.withOpacity(0.2), width: 0.5),
                        borderRadius: BorderRadius.circular(10),
                      ),
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
                                    tableRowWidget("2022-06-10 23:12:00"),
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
                                    tableRowWidget("2022-06-10 23:12:00"),
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
                                    tableRowWidget("2022-06-10 23:12:00"),
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
              SizedBox(height: height * 0.02),
              const Text('Graph heading here', style: Styles.text20),
              SizedBox(width: 400, height: 400, child: const DuvalPrescriptivegraph())
            ],
          ),
        ),
      ),
    );
  }

  Widget tableRowWidget(String value, {TextStyle style = Styles.lightText18}) {
    return Padding(padding: const EdgeInsets.all(10), child: Text(value, style: style));
  }
}

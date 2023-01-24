import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:predictive_app/modules/home/home.dart';
import 'package:predictive_app/modules/predictive/chart/predict_table_content.dart';
import 'package:predictive_app/modules/predictive/chart/simple_chart.dart';
import 'package:predictive_app/theme/app_color.dart';
import 'package:predictive_app/theme/app_style.dart';

class PredictiveHome extends StatefulWidget {
  const PredictiveHome({Key? key}) : super(key: key);
  @override
  State<PredictiveHome> createState() => _PredictiveHomeState();
}

class _PredictiveHomeState extends State<PredictiveHome> {
  final filter = <ButtonFilter>[
    ButtonFilter(isSelected: true, name: 'Day'),
    ButtonFilter(isSelected: false, name: 'Hour'),
    ButtonFilter(isSelected: false, name: 'Month'),
  ];
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
                        SizedBox(
                          height: height * 0.04,
                          child: Row(
                            children: [
                              const Text('Predictive analytics of Gases trends'),
                              SizedBox(width: width * 0.04),
                              ListView.builder(
                                shrinkWrap: true,
                                scrollDirection: Axis.horizontal,
                                itemCount: filter.length,
                                itemBuilder: (_, index) {
                                  return Container(
                                    margin: EdgeInsets.only(right: width * 0.01),
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        elevation: 0,
                                        backgroundColor: filter[index].isSelected!
                                            ? AppColor.appColor
                                            : AppColor.greyColor,
                                      ),
                                      onPressed: () {
                                        for (var i = 0; i < filter.length; i++) {
                                          filter[i].isSelected = false;
                                        }
                                        filter[index].isSelected = true;
                                        setState(() {});
                                      },
                                      child: Text(
                                        filter[index].name ?? '',
                                        style: TextStyle(
                                          color: filter[index].isSelected!
                                              ? AppColor.whiteColor
                                              : AppColor.blackColor,
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: height * 0.02),
                        SizedBox(width: width * 0.9, child: const PredictiveDataTableWidget())
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
              height: height * 0.3,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 20),
                decoration: BoxDecoration(
                  border: Border.all(color: AppColor.blackColor.withOpacity(0.2), width: 1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const MyAppLineChart(isShowingMainData: true),
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

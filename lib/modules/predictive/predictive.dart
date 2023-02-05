import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:csv/csv.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:predictive_app/modules/home/data/gase_name.dart';
import 'package:predictive_app/theme/app_color.dart';
import 'package:predictive_app/theme/app_style.dart';
import 'package:predictive_app/modules/home/chart/table_content.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  final gases = ['Methane', 'Ethane', 'Acetylene'];
  final gasColors = [AppColor.appColor, AppColor.orangeColor, AppColor.redColor];
  List<List<dynamic>> data = [];
  final isSelected = false;
  var selectedDate = DateTime.now();
  // Chart values
  final double width = 4;
  List<BarChartGroupData>? rawBarGroups;
  List<BarChartGroupData>? showingBarGroups;
  final graphListData = <BarChartGroupData>[];
  int touchedGroupIndex = -1;
  var titleString = <String>[];
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  bool ethaneSelected = true;
  bool methaneSelected = true;
  bool acetyleneSelected = true;
  int gasLength = 0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    getLocaleData(selectedDate);
  }

  // Loading data from the CSV file
  getLocaleData(DateTime date, {int index = -1, bool isSelected = true}) async {
    graphListData.clear();
    titleString.clear();
    var result = await rootBundle.loadString("assets/test2.csv");
    final data = const CsvToListConverter().convert(result);
    final SharedPreferences sharedPref = await SharedPreferences.getInstance();
    // saving data to local DB
    await sharedPref.setString('homeData', data.toString());
    final endDate = date.add(const Duration(days: 29));
    for (var i = 0; i < data.length; i++) {
      if (i > 0) {
        final now = DateFormat('dd/MM/yy hh:mm').parse(data[i][0]);
        if (now.isAfter(date) && now.isBefore(endDate)) {
          titleString.add(data[i][0].substring(0, 5));
          if (index == -1 && isSelected) {
            graphListData.add(
              makeGroupData(i, data[i][1].toDouble(), data[i][2].toDouble(), data[i][3].toDouble()),
            );
          } else if (index == 0 && !isSelected) {
            graphListData.add(makeGroupData(i, 0.0, data[i][2].toDouble(), data[i][3].toDouble()));
          } else if (index == 1 && !isSelected) {
            graphListData.add(makeGroupData(i, data[i][1].toDouble(), 0.0, data[i][3].toDouble()));
          } else if (index == 2 && !isSelected) {
            graphListData.add(makeGroupData(i, data[i][1].toDouble(), data[i][2].toDouble(), 0.0));
          }
        }
      }
    }
    rawBarGroups = graphListData;
    showingBarGroups = rawBarGroups;
    gasLength = titleString.length;
    setState(() {});
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
                        SizedBox(
                          width: width * 0.9,
                          child: DataTableWidget(
                            gases: allGasesTableList,
                            onChage: (int ind) {
                              allGasesTableList[ind].isSelected =
                                  !allGasesTableList[ind].isSelected;
                              getLocaleData(
                                selectedDate,
                                index: !allGasesTableList[ind].isSelected ? ind : -1,
                                isSelected: allGasesTableList[ind].isSelected,
                              );
                              setState(() {});
                            },
                          ),
                        )
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
                    onValueChanged: (date) async {
                      selectedDate = date[0] ?? DateTime.now();
                      getLocaleData(selectedDate);
                    },
                    config: CalendarDatePicker2Config(
                      calendarType: CalendarDatePicker2Type.single,
                      calendarViewMode: DatePickerMode.day,
                    ),
                    initialValue: [selectedDate],
                  ),
                ),
              ],
            ),
            SizedBox(height: height * 0.01),
            const Text('Gases state graph'),
            SizedBox(height: height * 0.02),
            SizedBox(
              height: height * 0.32,
              child: BarChart(
                BarChartData(
                  maxY: 10,
                  rangeAnnotations: RangeAnnotations(),
                  backgroundColor: AppColor.appColor.withOpacity(0.1),
                  barTouchData: BarTouchData(
                    touchTooltipData: BarTouchTooltipData(
                      tooltipBgColor: Colors.grey,
                      getTooltipItem: (a, b, c, d) => null,
                    ),
                    touchCallback: (FlTouchEvent event, response) {},
                  ),
                  borderData: FlBorderData(show: false),
                  barGroups: showingBarGroups,
                  gridData: FlGridData(show: true),
                  baselineY: 10,
                ),
              ),
            ),
            SizedBox(height: height * 0.02),
            SizedBox(
              height: height * 0.05,
              child: Row(
                children: [
                  SizedBox(width: width * 0.02),
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: gases.length,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (_, index) {
                      return Container(
                        margin: EdgeInsets.only(right: width * 0.05),
                        child: Row(
                          children: [
                            Container(
                              height: 10,
                              width: 10,
                              decoration: BoxDecoration(
                                color: gasColors[index],
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            SizedBox(width: width * 0.005),
                            Text(gases[index]),
                          ],
                        ),
                      );
                    },
                  ),
                ],
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

  Widget leftTitles(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Color(0xff7589a2),
      fontWeight: FontWeight.bold,
      fontSize: 14,
    );
    String text;
    if (value == 0) {
      text = '1';
    } else if (value == 5) {
      text = '5';
    } else if (value == 12) {
      text = '10';
    } else {
      return Container();
    }
    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 0,
      child: Text(text, style: style),
    );
  }

  Widget bottomTitles(double value, TitleMeta meta) {
    final Widget text = Text(
      titleString[value.toInt()],
      style: const TextStyle(
        color: Color(0xff7589a2),
        fontWeight: FontWeight.bold,
        fontSize: 14,
      ),
    );
    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 1, //margin top
      child: text,
    );
  }

  BarChartGroupData makeGroupData(int x, double y1, double y2, double y3) {
    return BarChartGroupData(
      barsSpace: 2,
      x: x,
      barRods: [
        BarChartRodData(
          toY: y1,
          color: AppColor.appColor,
          width: width,
        ),
        BarChartRodData(
          toY: y2,
          color: AppColor.orangeColor,
          width: width,
        ),
        BarChartRodData(
          toY: y3,
          color: AppColor.redColor,
          width: width,
        ),
      ],
    );
  }

  Widget makeTransactionsIcon() {
    const width = 2.5;
    const space = 3.5;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(
          width: width,
          height: 10,
          color: Colors.white.withOpacity(0.4),
        ),
        const SizedBox(
          width: space,
        ),
        Container(
          width: width,
          height: 28,
          color: Colors.white.withOpacity(0.8),
        ),
        const SizedBox(
          width: space,
        ),
        Container(
          width: width,
          height: 42,
          color: Colors.white.withOpacity(1),
        ),
        const SizedBox(
          width: space,
        ),
        Container(
          width: width,
          height: 28,
          color: Colors.white.withOpacity(0.8),
        ),
        const SizedBox(
          width: space,
        ),
        Container(
          width: width,
          height: 10,
          color: Colors.white.withOpacity(0.4),
        ),
      ],
    );
  }
}

class ButtonFilter {
  final String? name;
  bool? isSelected;
  ButtonFilter({this.isSelected, this.name});
}

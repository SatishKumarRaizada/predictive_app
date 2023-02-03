import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:csv/csv.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:predictive_app/modules/home/chart/home_chart.dart';
import 'package:predictive_app/theme/app_color.dart';
import 'package:predictive_app/theme/app_style.dart';
import 'package:predictive_app/modules/home/chart/table_content.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final filter = <ButtonFilter>[
    ButtonFilter(isSelected: true, name: 'Day'),
    ButtonFilter(isSelected: false, name: 'Hour'),
    ButtonFilter(isSelected: false, name: 'Month'),
  ];
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

  @override
  void initState() {
    super.initState();
    processCsv(selectedDate);
  }

  // Loading data from the CSV file
  processCsv(DateTime date) async {
    graphListData.clear();
    titleString.clear();
    var result = await rootBundle.loadString("assets/test.csv");
    final data = const CsvToListConverter().convert(result);
    final startDate = date;
    final endDate = date.add(const Duration(days: 30));
    for (var i = 0; i < data.length; i++) {
      final now = DateFormat('dd/MM/yy hh:mm').parse(data[i][0]);
      if (now.isAfter(startDate) && now.isBefore(endDate)) {
        titleString.add(data[i][0].substring(0, 5));
        graphListData.add(
          makeGroupData(
            i,
            data[i][1].toDouble(),
            data[i][2].toDouble(),
            data[i][3].toDouble(),
            data[i][4].toDouble(),
          ),
        );
      }
    }
    rawBarGroups = graphListData;
    showingBarGroups = rawBarGroups;
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
                        SizedBox(width: width * 0.9, child: const DataTableWidget())
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
                    onValueChanged: (date) {
                      selectedDate = date[0] ?? DateTime.now();
                      processCsv(selectedDate);
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
            SizedBox(height: height * 0.02),
            const Text('Graph heading here', style: Styles.text20),
            SizedBox(
              height: height * 0.3,
              child: BarChart(
                BarChartData(
                  maxY: 10,
                  barTouchData: BarTouchData(
                    touchTooltipData: BarTouchTooltipData(
                      tooltipBgColor: Colors.grey,
                      getTooltipItem: (a, b, c, d) => null,
                    ),
                    touchCallback: (FlTouchEvent event, response) {
                      if (response == null || response.spot == null) {
                        setState(() {
                          touchedGroupIndex = -1;
                          showingBarGroups = List.of(rawBarGroups!);
                        });
                        return;
                      }

                      touchedGroupIndex = response.spot!.touchedBarGroupIndex;

                      setState(() {
                        if (!event.isInterestedForInteractions) {
                          touchedGroupIndex = -1;
                          showingBarGroups = List.of(rawBarGroups!);
                          return;
                        }
                        showingBarGroups = List.of(rawBarGroups!);
                        if (touchedGroupIndex != -1) {
                          var sum = 0.0;
                          for (final rod in showingBarGroups![touchedGroupIndex].barRods) {
                            sum += rod.toY;
                          }
                          final avg = sum / showingBarGroups![touchedGroupIndex].barRods.length;

                          showingBarGroups![touchedGroupIndex] =
                              showingBarGroups![touchedGroupIndex].copyWith(
                            barRods: showingBarGroups![touchedGroupIndex].barRods.map((rod) {
                              return rod.copyWith(
                                toY: avg,
                                color: Colors.green,
                              );
                            }).toList(),
                          );
                        }
                      });
                    },
                  ),
                  titlesData: FlTitlesData(
                    show: true,
                    rightTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    topTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: bottomTitles,
                        reservedSize: 42,
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 28,
                        interval: 1,
                        getTitlesWidget: leftTitles,
                      ),
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                  barGroups: showingBarGroups,
                  gridData: FlGridData(show: false),
                ),
              ),
            )
          ],
        ),
      )),
    );
  }

  TableRow _getTableWidgets() {
    return TableRow();
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
      space: 16, //margin top
      child: text,
    );
  }

  BarChartGroupData makeGroupData(int x, double y1, double y2, double y3, double y4) {
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
        BarChartRodData(
          toY: y4,
          color: AppColor.yellowColor,
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

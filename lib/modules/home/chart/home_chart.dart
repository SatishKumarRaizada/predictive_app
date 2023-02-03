import 'package:csv/csv.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:predictive_app/theme/app_color.dart';

class HomePageChart extends StatefulWidget {
  final DateTime selectedDate;
  const HomePageChart({super.key, required this.selectedDate});
  @override
  State<StatefulWidget> createState() => BarChartSampleState();
}

class BarChartSampleState extends State<HomePageChart> {
  final double width = 4;
  List<BarChartGroupData>? rawBarGroups;
  List<BarChartGroupData>? showingBarGroups;
  final graphListData = <BarChartGroupData>[];
  int touchedGroupIndex = -1;
  var titleString = <String>[];

  @override
  void initState() {
    super.initState();
    processCsv();
  }

  // Loading data from the CSV file
  processCsv() async {
    var result = await rootBundle.loadString("assets/test.csv");
    final data = const CsvToListConverter().convert(result);
    for (var i = 0; i < data.length; i++) {
      final date = DateFormat('dd/mm/yy hh:mm').parse(data[i][0]);
      if (date.isAfter(widget.selectedDate)) {
        titleString.add(data[i][0].substring(0, 5));
        graphListData.add(
          makeGroupData(i, data[i][1].toDouble(), data[i][2].toDouble(), data[i][3].toDouble(),
              data[i][4].toDouble()),
        );
      }
    }
    rawBarGroups = graphListData;
    showingBarGroups = rawBarGroups;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return BarChart(
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
    );
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

import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:csv/csv.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:predictive_app/modules/home/data/gase_name.dart';
import 'package:predictive_app/theme/app_color.dart';
import 'package:predictive_app/theme/app_style.dart';
import 'package:predictive_app/modules/home/chart/table_content.dart';
import 'package:predictive_app/widgets/dropdown_widget.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:predictive_app/modules/home/data/gase_util.dart';

class PredictiveHome extends StatefulWidget {
  const PredictiveHome({Key? key}) : super(key: key);
  @override
  State<PredictiveHome> createState() => _PredictiveHomeState();
}

class _PredictiveHomeState extends State<PredictiveHome> {
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
  bool ethaneSelected = true;
  bool methaneSelected = true;
  bool acetyleneSelected = true;
  int gasLength = 0;
  TextEditingController startDateInput = TextEditingController();
  TextEditingController endDateInput = TextEditingController();
  List<ChartData> chartData = <ChartData>[];
  final dropDownList = <String>[];
  String? selectedGas = '';
  String? selectedGasName;
  String dateFormatType = 'MM/dd/yyyy';

  @override
  void initState() {
    super.initState();
    startDateInput.text = '';
    endDateInput.text = '';
    getLocaleData();
    getDropdownValues();
  }

  DateTime parseDate(String input) {
    if (input.isEmpty) return DateTime.now();
    final cc = input.contains('/');
    final splitChar = cc ? '/' : '-';
    List<String> parts = input.split(" ")[0].split(splitChar);
    if (parts[2].length < 4) {
      parts[2] = '20${parts[2]}';
    }
    DateFormat dateFormat = DateFormat(dateFormatType);
    final d =
        dateFormat.format(DateTime(int.parse(parts[2]), int.parse(parts[0]), int.parse(parts[1])));
    DateTime dd = dateFormat.parse(d);
    return dd;
  }

  double convertToDouble(dynamic value) {
    if (value is double) {
      return value;
    } else if (value is int) {
      return value.toDouble();
    } else if (value is String) {
      String stringValue = value.replaceAll(',', '.');
      if (stringValue.contains(RegExp(r'^-?\d+(\.\d+)?$'))) {
        return double.parse(stringValue);
      } else {
        return double.parse('0.0');
      }
    } else {
      throw Exception('Unable to convert value to double: $value');
    }
  }

  void updateTheChartData() async {
    final localData = await getLocaleData();
    final name = localData[0];
    final selectedGasIndex = name.indexOf(selectedGasName) > -1 ? name.indexOf(selectedGasName) : 1;
    var charatData = <ChartData>[];
    for (var i = 0; i < localData.length; i++) {
      if (i > 0) {
        final now = parseDate(localData[i][0]);
        final startDate = parseDate(startDateInput.text);
        final endDate = parseDate(endDateInput.text);
        if (now.isAfter(startDate) && now.isBefore(endDate)) {
          double input = convertToDouble(localData[i][selectedGasIndex]);
          charatData.add(ChartData(now, input));
        }
      }
    }
    chartData = charatData;
    setState(() {});
  }

  dynamic getLocaleData() async {
    List<dynamic> data;
    final checkLocalData = await getData();
    if (checkLocalData != null) {
      data = checkLocalData;
    } else {
      var result = await rootBundle.loadString("assets/health_data.csv");
      final excelData = const CsvToListConverter().convert(result);
      data = excelData;
      saveData(data);
    }
    return data;
  }

  void saveData(List<dynamic> data) async {
    var box = await Hive.openBox('predictiveChart');
    await box.put('predictiveChartData', data);
  }

  getData() async {
    var box = await Hive.openBox('predictiveChart');
    final data = await box.get('predictiveChartData');
    return data;
  }

  void getDropdownValues() async {
    final lists = await getLocaleData();
    for (var i = 1; i < lists[0].length; i++) {
      dropDownList.add(lists[0][i]);
    }
    selectedGas = lists[0][1];
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
            SizedBox(height: height * 0.02),
            const Text('Select gas'),
            SizedBox(height: height * 0.01),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AppDropdown(
                  dropList: dropDownList,
                  valueSelected: selectedGas,
                  onSelect: (String value) {
                    selectedGas = value;
                    selectedGasName = value;
                    updateTheChartData();
                    setState(() {});
                  },
                ),
              ],
            ),
            SizedBox(height: height * 0.02),
            const Text('Gases state graph'),
            Container(
              padding: const EdgeInsets.all(15),
              height: 60,
              child: Center(
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: startDateInput,
                        decoration: const InputDecoration(
                          icon: Icon(Icons.calendar_today),
                          labelText: "Start Date",
                        ),
                        readOnly: true,
                        onTap: () async {
                          DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(1950),
                            lastDate: DateTime(2100),
                          );
                          if (pickedDate != null) {
                            String formattedDate = DateFormat(dateFormatType).format(pickedDate);
                            startDateInput.text = formattedDate;
                            updateTheChartData();
                            setState(() {});
                          }
                        },
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: TextField(
                        controller: endDateInput,
                        decoration: const InputDecoration(
                            icon: Icon(Icons.calendar_today), labelText: "End Date"),
                        readOnly: true,
                        onTap: () async {
                          // final endDate = startDateInput.text;
                          // final d = endDate.isEmpty ? DateTime.now() : DateFormat()
                          // final dd = DateFormat(dateFormatType).format(date)
                          DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(1950),
                            lastDate: DateTime(2100),
                          );
                          if (pickedDate != null) {
                            String formattedDate = DateFormat(dateFormatType).format(pickedDate);
                            setState(() {
                              endDateInput.text = formattedDate;
                            });
                            updateTheChartData();
                          } else {}
                        },
                      ),
                      // Add your second widget here
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: height * 0.02),
            SizedBox(
              height: height * 0.32,
              child: SfCartesianChart(
                primaryXAxis: DateTimeAxis(),
                primaryYAxis: NumericAxis(isInversed: false),
                series: <ChartSeries<ChartData, DateTime>>[
                  LineSeries<ChartData, DateTime>(
                    dataSource: chartData,
                    trendlines: <Trendline>[
                      Trendline(
                        type: TrendlineType.linear,
                        forwardForecast: 7,
                        color: AppColor.appColor,
                      ),
                    ],
                    markerSettings: const MarkerSettings(isVisible: true),
                    xValueMapper: (ChartData data, _) => data.x,
                    yValueMapper: (ChartData data, _) => data.y,
                  ),
                ],
              ),
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

class ChartData {
  ChartData(this.x, this.y);
  final DateTime x;
  final double y;
}

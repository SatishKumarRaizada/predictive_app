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
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:predictive_app/modules/home/data/gase_util.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
  String? selectedGasName;
  String dateFormatType = 'MM/dd/yyyy';

  @override
  void initState() {
    super.initState();
    startDateInput.text = "";
    endDateInput.text = "";
    getLocaleData();
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
        print('>>now>>$now>>>startDate>>>$startDate>>>endDate>>$endDate');
        print(now.isAfter(startDate) && now.isBefore(endDate));
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
    var box = await Hive.openBox('homeChart');
    await box.put('homeChartData', data);
  }

  getData() async {
    var box = await Hive.openBox('homeChart');
    final data = await box.get('homeChartData');
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
                        SizedBox(
                          width: width * 0.9,
                          child: DataTableWidget(
                            gases: allGasesTableList,
                            onChage: (int ind) {
                              for (var i = 0; i < allGasesTableList.length; i++) {
                                if (ind != i) {
                                  allGasesTableList[i].isSelected = false;
                                }
                              }
                              allGasesTableList[ind].isSelected =
                                  !allGasesTableList[ind].isSelected;
                              selectedGasName = allGasesTableList[ind].name;
                              updateTheChartData();
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
                      getLocaleData();
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
                          final today = DateTime.now();

                          DateTime? pickedDate = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(1950),
                              lastDate: DateTime(2100));
                          if (pickedDate != null) {
                            String formattedDate = DateFormat(dateFormatType).format(pickedDate);
                            setState(() {
                              startDateInput.text = formattedDate;
                            });
                            updateTheChartData();
                          } else {}
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
                          DateTime? pickedDate = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(1950),
                              lastDate: DateTime(2100));
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
                    color: AppColor.appColor,
                    enableTooltip: true,
                    dataSource: chartData,
                    onPointTap: (point) {
                      print(point); //It can be used to display tapped value
                    },
                    animationDelay: 0.2,
                    isVisibleInLegend: true,
                    markerSettings: MarkerSettings(
                      isVisible: true,
                      color: AppColor.appColor,
                      borderColor: AppColor.appColor,
                    ),
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

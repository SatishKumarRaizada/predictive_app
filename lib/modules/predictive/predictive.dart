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
  final dropDowlIst = <String>[];
  String? selectedGas = '';

  @override
  void initState() {
    super.initState();
    startDateInput.text = '';
    endDateInput.text = '';
    allGasesTableList[0].isSelected = true;
    getLocaleData(selectedDate);
  }

  DateTime parseDate(String input) {
    List<String> formats = [
      'dd/MM/yyyy',
      'dd/MM/yy',
      'yyyy/MM/dd',
      'MM/dd/yyyy',
      'dd-MM-yyyy',
      'dd-MM-yy',
    ];

    DateTime date = DateTime.now();
    for (var format in formats) {
      try {
        date = DateFormat(format).parse(input);
        break;
      } catch (e) {
        // continue looping if parse fails
      }
    }
    return date;
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
    List<dynamic> data;
    for (var i = 0; i < allGasesTableList.length; i++) {
      dropDowlIst.add(allGasesTableList[i].name);
    }

    selectedGas = allGasesTableList[0].name;
    final checkLocalData = await getData();
    if (checkLocalData != null) {
      data = checkLocalData;
    } else {
      var result = await rootBundle.loadString("assets/data.csv");
      final excelData = const CsvToListConverter().convert(result);
      data = excelData;
    }
    var charatData = <ChartData>[];
    for (var i = 0; i < data.length; i++) {
      if (i > 0) {
        final now = parseDate(data[i][0]);
        final startDate = parseDate(startDateInput.text);
        final endDate = parseDate(endDateInput.text);
        if (now.isAfter(startDate) && now.isBefore(endDate)) {
          double input = convertToDouble(data[i][1]);
          charatData.add(ChartData(now, input));
        }
      }
    }
    chartData = charatData;
    setState(() {});
  }

  getLocaleData(DateTime date, {int index = -1, bool isSelected = true}) async {
    List<dynamic> data;
    dropDowlIst.clear();
    final checkLocalData = await getData();
    if (checkLocalData != null) {
      data = checkLocalData;
    } else {
      var result = await rootBundle.loadString("assets/health_data.csv");
      final excelData = const CsvToListConverter().convert(result);
      data = excelData;
      saveData(data);
    }
    var datafound = false;
    for (var i = 0; i < data.length; i++) {
      if (i > 0) {
        final now = parseDate(data[i][0]);
        if (now.compareTo(date) == 0) {
          for (var j = 0; j < allGasesTableList.length; j++) {
            allGasesTableList[j].date = DateFormat('dd-MM-yyyy').format(selectedDate);
            final indes = allGasesTableList[j].index;
            double gasValue = convertToDouble(data[i][indes + 1]);
            allGasesTableList[j].ppm = gasValue;
            allGasesTableList[j].status = getGasStatus(allGasesTableList[j].name, gasValue);
            datafound = true;
          }
        }
      }
    }
    selectedGas = selectedGas!.isEmpty ? allGasesTableList[0].name : selectedGas;
    if (datafound == false) {
      for (var j = 0; j < allGasesTableList.length; j++) {
        dropDowlIst.add(allGasesTableList[j].name);
        allGasesTableList[j].date = DateFormat('dd-MM-yyyy').format(selectedDate);
        allGasesTableList[j].ppm = convertToDouble(0.0);
      }
    }

    rawBarGroups = graphListData;
    showingBarGroups = rawBarGroups;
    gasLength = titleString.length;
    setState(() {});
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
                              allGasesTableList[ind].date =
                                  DateFormat('dd-MM-yyyy').format(selectedDate);
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
            SizedBox(height: height * 0.02),
            const Text('Select gas'),
            SizedBox(height: height * 0.01),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AppDropdown(
                  dropList: dropDowlIst,
                  valueSelected: selectedGas,
                  onSelect: (String value) {
                    final ind = dropDowlIst.indexOf(value);
                    selectedGas = value;
                    for (var i = 0; i < allGasesTableList.length; i++) {
                      if (ind != i) {
                        allGasesTableList[i].isSelected = false;
                      }
                    }
                    allGasesTableList[ind].isSelected = !allGasesTableList[ind].isSelected;
                    allGasesTableList[ind].date = DateFormat('dd-MM-yyyy').format(selectedDate);
                    getLocaleData(
                      selectedDate,
                      index: !allGasesTableList[ind].isSelected ? ind : -1,
                      isSelected: allGasesTableList[ind].isSelected,
                    );
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
                            icon: Icon(Icons.calendar_today), labelText: "Start Date"),
                        readOnly: true,
                        onTap: () async {
                          final dd = startDateInput.text.isEmpty
                              ? DateFormat('dd-MM-yyyy').format(DateTime.now())
                              : startDateInput.text;
                          final startDate = DateFormat('dd-MM-yyyy').parse(dd);
                          DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: startDate,
                            firstDate: DateTime.now(),
                            lastDate: DateTime(2100),
                          );
                          if (pickedDate != null) {
                            String formattedDate = DateFormat('dd-MM-yyyy').format(pickedDate);
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
                          final dd = startDateInput.text.isEmpty
                              ? DateFormat('dd-MM-yyyy').format(DateTime.now())
                              : startDateInput.text;
                          final startDate = DateFormat('dd-MM-yyyy').parse(dd);
                          final endDate = startDate.add(const Duration(days: 7));
                          DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: startDate,
                            firstDate: startDate.subtract(const Duration(hours: 1)),
                            lastDate: endDate,
                          );
                          if (pickedDate != null) {
                            String formattedDate = DateFormat('dd-MM-yyyy').format(pickedDate);
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

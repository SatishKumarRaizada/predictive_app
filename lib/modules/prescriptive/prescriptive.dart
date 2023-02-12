import 'package:csv/csv.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:predictive_app/theme/app_color.dart';
import 'package:predictive_app/theme/app_style.dart';
import 'package:predictive_app/modules/prescriptive/chart/duval copy.dart';
import 'package:predictive_app/modules/home/data/gase_name.dart';
import 'package:predictive_app/modules/home/home.dart';

class PrescriptiveHome extends StatefulWidget {
  const PrescriptiveHome({Key? key}) : super(key: key);
  @override
  State<PrescriptiveHome> createState() => _PrescriptiveHomeState();
}

class _PrescriptiveHomeState extends State<PrescriptiveHome> {
  final gases = ['Methane', 'Ethane', 'Acetylene', 'TDCG'];
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
  List<GasDetailModel> gasLists = [];
  List<String> gasNames = [];

  @override
  void initState() {
    super.initState();
    startDateInput.text = "";
    endDateInput.text = "";
    updateTheChartData();
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
    gasLists.clear();
    final localData = await getLocaleData();
    final name = localData[0];
    final selectedGasIndex = name.indexOf(selectedGasName) > -1 ? name.indexOf(selectedGasName) : 1;
    var charatData = <ChartData>[];
    //
    final mIndex = localData[0].indexOf('Methane');
    final eIndex = localData[0].indexOf('Ethane');
    final aIndex = localData[0].indexOf('Acethylene');
    final tIndex = localData[0].indexOf('TDCG');

    //
    for (var i = 0; i < localData.length; i++) {
      if (i > 0) {
        final now = parseDate(localData[i][0]);
        final startDate = parseDate(startDateInput.text);
        final endDate = parseDate(endDateInput.text);
        // gasLists.add(
        //     //GasDetailModel(date: date, name: name, index: index, risk: risk, value: value),
        //     );
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
    var box = await Hive.openBox('prescriptiveChart');
    await box.put('prescriptiveChartData', data);
  }

  getData() async {
    var box = await Hive.openBox('prescriptiveChart');
    final data = await box.get('prescriptiveChartData');
    return data;
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
              Container(
                height: 50,
                width: width * 0.4,
                decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  border: Border.all(color: AppColor.appColor, width: 0.4),
                ),
                child: ListView.builder(
                  itemCount: gases.length,
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (_, index) {
                    return Text(gases[index]);
                  },
                ),
              ),
              // Container(
              //   child: ListView.builder(itemBuilder: (context, index) {
              //     return
              //   },),
              // ),

              // PrescriptiveTable(
              //   isPredictive: true,
              //   gases: presGases,
              //   onChage: (int ind) {
              //     for (var i = 0; i < allGasesTableList.length; i++) {
              //       if (ind != i) {
              //         allGasesTableList[i].isSelected = false;
              //       }
              //     }
              //     setState(() {});
              //   },
              // ),
              SizedBox(height: height * 0.02),
              const Text('Graph heading here', style: Styles.text20),
              //const SizedBox(width: 400, height: 400, child: DrawTriangle()),
              SizedBox(height: height * 0.02),
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

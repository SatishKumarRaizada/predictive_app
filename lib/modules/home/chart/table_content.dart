import 'package:flutter/material.dart';
import 'package:predictive_app/theme/app_color.dart';
import '../data/gase_name.dart';

// ignore: must_be_immutable
class DataTableWidget extends StatelessWidget {
  final Function onChage;
  final bool isPredictive;
  final List<GasDetailModel> gases;

  DataTableWidget({
    super.key,
    required this.onChage,
    required this.gases,
    this.isPredictive = false,
  });
  List<DataColumn> homeColumn = const [
    DataColumn(label: Text('Gases')),
    DataColumn(label: Text('Show graph')),
    DataColumn(label: Text('PPM')),
    DataColumn(label: Text('Date')),
    DataColumn(label: Text('Status')),
  ];
  List<DataColumn> predictiveColumn = const [
    DataColumn(label: Text('Gases')),
    DataColumn(label: Text('PPM')),
    DataColumn(label: Text('Date')),
    DataColumn(label: Text('Status')),
  ];
  @override
  Widget build(BuildContext context) {
    return DataTable(
      border: TableBorder.all(color: Colors.black.withOpacity(0.4), width: 0.4),
      headingRowColor: MaterialStateProperty.all(AppColor.appColor),
      columns: isPredictive ? predictiveColumn : homeColumn,
      rows: isPredictive ? getPredictiveRows() : getHomeRows(),
    );
  }

  List<DataRow> getHomeRows() {
    return gases.map(
      ((element) {
        return DataRow(
          cells: <DataCell>[
            DataCell(Text(element.name)),
            DataCell(
              IconButton(
                onPressed: () {
                  final ind = gases.indexOf(element);
                  onChage(ind);
                },
                icon: Icon(
                  element.isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
                ),
              ),
            ),
            DataCell(Text(element.ppm.toString())),
            DataCell(Text(element.date)),
            DataCell(Text(element.status)),
          ],
        );
      }),
    ).toList();
  }

  List<DataRow> getPredictiveRows() {
    return gases.map(
      ((element) {
        return DataRow(
          cells: <DataCell>[
            DataCell(Text(element.name)),
            DataCell(Text(element.ppm.toString())),
            DataCell(Text(element.date)),
            DataCell(Text(element.status)),
          ],
        );
      }),
    ).toList();
  }
}

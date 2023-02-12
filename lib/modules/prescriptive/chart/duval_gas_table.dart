import 'package:flutter/material.dart';
import 'package:predictive_app/modules/home/data/gase_name.dart';
import 'package:predictive_app/theme/app_color.dart';

// ignore: must_be_immutable
class PrescriptiveTable extends StatelessWidget {
  final Function onChage;
  final bool isPredictive;
  final List<GasDetailModel> gases;

  PrescriptiveTable({
    super.key,
    required this.onChage,
    required this.gases,
    this.isPredictive = false,
  });

  List<DataColumn> tableColumn = const [
    DataColumn(label: Text('Gases')),
    DataColumn(label: Text('PPM')),
    DataColumn(label: Text('Status')),
  ];
  @override
  Widget build(BuildContext context) {
    return DataTable(
      border: TableBorder.all(color: Colors.black.withOpacity(0.4), width: 0.4),
      headingRowColor: MaterialStateProperty.all(AppColor.appColor),
      columns: tableColumn,
      rows: isPredictive ? getPredictiveRows() : getHomeRows(),
    );
  }

  List<DataRow> getHomeRows() {
    return gases.map(
      ((element) {
        return DataRow(
          cells: <DataCell>[
            DataCell(Text(element.name)),
            DataCell(Text(element.ppm.toString())),
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
            DataCell(Text(element.status)),
          ],
        );
      }),
    ).toList();
  }
}

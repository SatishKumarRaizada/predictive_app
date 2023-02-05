import 'package:flutter/material.dart';
import 'package:predictive_app/theme/app_color.dart';
import '../data/gase_name.dart';

class DataTableWidget extends StatelessWidget {
  final Function onChage;
  final List<GasDetailModel> gases;
  const DataTableWidget({super.key, required this.onChage, required this.gases});

  @override
  Widget build(BuildContext context) {
    return DataTable(
      border: TableBorder.all(color: Colors.black.withOpacity(0.4), width: 0.4),
      headingRowColor: MaterialStateProperty.all(AppColor.appColor),
      columns: const [
        DataColumn(label: Text('Gases')),
        DataColumn(label: Text('Risk')),
        DataColumn(label: Text('PPM')),
        DataColumn(label: Text('Date')),
        DataColumn(label: Text('Status')),
      ],
      rows: getRows(),
    );
  }

  List<DataRow> getRows() {
    return gases.map(
      ((element) {
        return DataRow(
          cells: <DataCell>[
            DataCell(Text(element.name)),
            DataCell(Text(element.risk ? 'High' : 'Normal')),
            DataCell(Text(element.ppm)),
            DataCell(Text(element.date)),
            DataCell(Text(element.status)),
          ],
        );
      }),
    ).toList();
  }
}

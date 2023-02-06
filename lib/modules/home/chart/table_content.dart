import 'package:flutter/material.dart';
import 'package:predictive_app/theme/app_color.dart';
import '../data/gase_name.dart';

class DataTableWidget extends StatelessWidget {
  final Function onChage;
  final List<GasDetailModel> gases;
  const DataTableWidget(
      {super.key, required this.onChage, required this.gases});

  @override
  Widget build(BuildContext context) {
    return DataTable(
      border: TableBorder.all(color: Colors.black.withOpacity(0.4), width: 0.4),
      headingRowColor: MaterialStateProperty.all(AppColor.appColor),
      columns: const [
        DataColumn(label: Text('Gases')),
        DataColumn(label: Text('Show graph')),
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
            DataCell(
              IconButton(
                onPressed: () {
                  final ind = gases.indexOf(element);
                  onChage(ind);
                },
                icon: Icon(element.isSelected
                    ? Icons.check_box
                    : Icons.check_box_outline_blank),
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
}

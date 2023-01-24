import 'package:flutter/material.dart';
import 'package:predictive_app/theme/app_color.dart';

class DataTableWidget extends StatefulWidget {
  const DataTableWidget({super.key});
  @override
  State<DataTableWidget> createState() => _DataTableWidgetState();
}

class _DataTableWidgetState extends State<DataTableWidget> {
  final data = <GasDetailModel>[
    GasDetailModel(
      date: '20/01/2023',
      name: 'Hydrogen',
      ppm: '100',
      risk: false,
      status: 'Green',
      value: '15.3',
      isSelected: false,
    ),
    GasDetailModel(
      date: '20/01/2023',
      name: 'Acetylene',
      ppm: '10',
      risk: false,
      status: 'Green',
      value: '0.8',
      isSelected: false,
    ),
    GasDetailModel(
      date: '20/01/2023',
      name: 'Water',
      ppm: '10',
      risk: false,
      status: 'Green',
      value: '2',
      isSelected: false,
    ),
    GasDetailModel(
      date: '20/01/2023',
      name: 'Carbon Monoxide',
      ppm: '60',
      risk: false,
      status: 'Green',
      value: '15.3',
      isSelected: false,
    ),
    GasDetailModel(
      date: '20/01/2023',
      name: 'Hydrogen',
      ppm: '500',
      risk: false,
      status: 'Green',
      value: '320.6',
      isSelected: false,
    ),
    GasDetailModel(
      date: '20/01/2023',
      name: 'Ethylene',
      ppm: '10',
      risk: false,
      status: 'Green',
      value: '2',
      isSelected: false,
    ),
    GasDetailModel(
      date: '20/01/2023',
      name: 'Ethane',
      ppm: '50',
      risk: false,
      status: 'Green',
      value: '3.9',
      isSelected: false,
    ),
    GasDetailModel(
      date: '20/01/2023',
      name: 'Methane',
      ppm: '100',
      risk: false,
      status: 'Green',
      value: '9.4',
      isSelected: false,
    )
  ];

  @override
  Widget build(BuildContext context) {
    return DataTable(
      border: TableBorder.all(color: Colors.black.withOpacity(0.4), width: 0.4),
      headingRowColor: MaterialStateProperty.all(AppColor.appColor),
      columns: const [
        DataColumn(label: Text('Gases')),
        DataColumn(label: Text('Checks')),
        DataColumn(label: Text('Risk')),
        DataColumn(label: Text('PPM')),
        DataColumn(label: Text('Date')),
        DataColumn(label: Text('Status')),
      ],
      rows: getRows(),
    );
  }

  List<DataRow> getRows() {
    return data.map(
      ((element) {
        return DataRow(
          cells: <DataCell>[
            DataCell(Text(element.name)),
            DataCell(IconButton(
                onPressed: () {
                  element.isSelected = !element.isSelected;
                  setState(() {});
                },
                icon: Icon(element.isSelected ? Icons.check_box : Icons.check_box_outline_blank))),
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

class GasDetailModel {
  final String name;
  final String value;
  final bool risk;
  bool isSelected;
  final String ppm;
  final String date;
  final String status;
  GasDetailModel(
      {required this.date,
      required this.name,
      required this.ppm,
      required this.risk,
      required this.status,
      required this.value,
      this.isSelected = false});
}

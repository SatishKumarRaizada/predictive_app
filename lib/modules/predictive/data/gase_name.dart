final allGasesTableList = <GasDetailModel>[
  GasDetailModel(
    date: '20/01/2023',
    name: 'Methane',
    ppm: '100',
    risk: false,
    status: 'Green',
    value: '9.4',
    isSelected: true,
  ),
  GasDetailModel(
    date: '20/01/2023',
    name: 'Ethane',
    ppm: '50',
    risk: false,
    status: 'Green',
    value: '3.9',
    isSelected: true,
  ),
  GasDetailModel(
    date: '20/01/2023',
    name: 'Acetylene',
    ppm: '10',
    risk: false,
    status: 'Green',
    value: '0.8',
    isSelected: true,
  ),
];

class GasDetailModel {
  final String name;
  final String value;
  final bool risk;
  bool isSelected;
  final String ppm;
  final String date;
  final String status;
  GasDetailModel({
    required this.date,
    required this.name,
    required this.ppm,
    required this.risk,
    required this.status,
    required this.value,
    this.isSelected = false,
  });
}

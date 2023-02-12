final allGasesTableList = <GasDetailModel>[
  GasDetailModel(
    date: '20/01/2023',
    name: 'Methane',
    index: 0,
    ppm: 0.0,
    risk: false,
    status: 'Normal',
    value: '9.4',
    isSelected: true,
  ),
  GasDetailModel(
    date: '20/01/2023',
    name: 'Ethylene',
    index: 1,
    ppm: 0.0,
    risk: false,
    status: 'Normal',
    value: '3.9',
    isSelected: false,
  ),
  GasDetailModel(
    date: '20/01/2023',
    name: 'Acetylene',
    index: 2,
    ppm: 0.0,
    risk: false,
    status: 'Normal',
    value: '0.8',
    isSelected: false,
  ),
  GasDetailModel(
    date: '20/01/2023',
    name: 'Ethane',
    index: 3,
    ppm: 0.0,
    risk: false,
    status: 'Normal',
    value: '0.8',
    isSelected: false,
  ),
  GasDetailModel(
    date: '20/01/2023',
    name: 'Hydrogen',
    index: 4,
    ppm: 0.0,
    risk: false,
    status: 'Normal',
    value: '0.8',
    isSelected: false,
  ),
  GasDetailModel(
    date: '20/01/2023',
    name: 'Carbon Monoxide',
    index: 5,
    ppm: 0.0,
    risk: false,
    status: 'Normal',
    value: '0.8',
    isSelected: false,
  ),
  GasDetailModel(
    date: '20/01/2023',
    name: 'Carbon Dioxide',
    index: 6,
    ppm: 0.0,
    risk: false,
    status: 'Normal',
    value: '0.8',
    isSelected: false,
  ),
  GasDetailModel(
    date: '20/01/2023',
    name: 'Oxygen',
    index: 7,
    ppm: 0.0,
    risk: false,
    status: 'Normal',
    value: '0.8',
    isSelected: false,
  ),
  GasDetailModel(
    date: '20/01/2023',
    name: 'TDCG',
    index: 8,
    ppm: 0.0,
    risk: false,
    status: 'Normal',
    value: '0.8',
    isSelected: false,
  ),
  GasDetailModel(
    date: '20/01/2023',
    name: 'Water',
    index: 9,
    ppm: 0.0,
    risk: false,
    status: 'Normal',
    value: '0.8',
    isSelected: false,
  ),
  GasDetailModel(
    date: '20/01/2023',
    name: 'NormalizationTemp',
    index: 10,
    ppm: 0.0,
    risk: false,
    status: 'Normal',
    value: '0.8',
    isSelected: false,
  ),
  GasDetailModel(
    date: '20/01/2023',
    name: 'OilPressure',
    index: 11,
    ppm: 0.0,
    risk: false,
    status: 'Normal',
    value: '0.8',
    isSelected: false,
  ),
  GasDetailModel(
    date: '20/01/2023',
    name: 'OilTemp',
    index: 12,
    ppm: 0.0,
    risk: false,
    status: 'Normal',
    value: '0.8',
    isSelected: false,
  ),
  GasDetailModel(
    date: '20/01/2023',
    name: 'Nitrogen',
    index: 13,
    ppm: 0.0,
    risk: false,
    status: 'Normal',
    value: '0.8',
    isSelected: false,
  ),
];

final presGases = <GasDetailModel>[
  GasDetailModel(
    date: '20/01/2023',
    name: 'Methane',
    index: 0,
    ppm: 0.0,
    risk: false,
    status: 'Normal',
    value: '9.4',
    isSelected: true,
  ),
  GasDetailModel(
    date: '20/01/2023',
    name: 'Acetylene',
    index: 2,
    ppm: 0.0,
    risk: false,
    status: 'Normal',
    value: '0.8',
    isSelected: false,
  ),
  GasDetailModel(
    date: '20/01/2023',
    name: 'Ethane',
    index: 3,
    ppm: 0.0,
    risk: false,
    status: 'Normal',
    value: '0.8',
    isSelected: false,
  ),
  GasDetailModel(
    date: '20/01/2023',
    name: 'TDCG',
    index: 8,
    ppm: 0.0,
    risk: false,
    status: 'Normal',
    value: '0.8',
    isSelected: false,
  ),
];

class GasDetailModel {
  final String name;
  final String value;
  final bool risk;
  bool isSelected;
  double ppm;
  String date;
  String status;
  int index;
  GasDetailModel({
    required this.date,
    required this.name,
    required this.index,
    this.ppm = 0.0,
    required this.risk,
    required this.value,
    this.isSelected = false,
    this.status = "Normal",
  });
}

class PrescriptiveModel {
  String mValue;
  String eValue;
  String aValue;
  String tValue;

  PrescriptiveModel({
    required this.mValue,
    required this.eValue,
    required this.aValue,
    required this.tValue,
  });
}

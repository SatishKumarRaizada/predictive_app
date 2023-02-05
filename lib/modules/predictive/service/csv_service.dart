import 'package:csv/csv.dart';
import 'dart:convert';
import 'dart:io';

// Future<List<Map<String, dynamic>>> readCsv(String filePath) async {
//   File file = File(filePath);
//   String csvString = await file.readAsString();
//   List<List<dynamic>> rowsAsListOfValues = const CsvToListConverter().convert(csvString);
//   return rowsAsListOfValues.map((e) => Map.fromIterables(rowsAsListOfValues[0], e)).toList();
// }

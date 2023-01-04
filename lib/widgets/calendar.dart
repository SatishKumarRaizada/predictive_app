import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class MyDatepicker extends StatefulWidget {
  const MyDatepicker({Key? key}) : super(key: key);
  @override
  State<MyDatepicker> createState() => _MyDatepickerState();
}

class _MyDatepickerState extends State<MyDatepicker> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final height = size.height;
    final width = size.width;
    return SizedBox();
  }
}

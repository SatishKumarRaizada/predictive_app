import 'package:flutter/material.dart';

class PrescriptiveHome extends StatefulWidget {
  const PrescriptiveHome({Key? key}) : super(key: key);
  @override
  State<PrescriptiveHome> createState() => _PrescriptiveHomeState();
}

class _PrescriptiveHomeState extends State<PrescriptiveHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: const [Text('Prescriptive Page')],
          ),
        ),
      ),
    );
  }
}

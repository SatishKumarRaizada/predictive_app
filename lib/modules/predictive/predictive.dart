import 'package:flutter/material.dart';

class PredictiveHome extends StatefulWidget {
  const PredictiveHome({Key? key}) : super(key: key);
  @override
  State<PredictiveHome> createState() => _PredictiveHomeState();
}

class _PredictiveHomeState extends State<PredictiveHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [Text('Predictive Page')],
          ),
        ),
      ),
    );
  }
}

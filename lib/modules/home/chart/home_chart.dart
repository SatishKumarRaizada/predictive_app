import 'package:flutter/material.dart';
import 'package:graphic/graphic.dart';
import 'package:predictive_app/modules/home/chart/data%20copy.dart';
import 'package:predictive_app/modules/home/chart/polygon_chart.dart';

class HomePageChart extends StatelessWidget {
  HomePageChart({Key? key}) : super(key: key);

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      body: Center(
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height * 0.3,
          child: Chart(
            padding: (_) => const EdgeInsets.fromLTRB(40, 5, 10, 40),
            data: newPolygonData,
            variables: {
              'index': Variable(
                accessor: (Map map) => map['date'].toString(),
              ),
              'type': Variable(
                accessor: (Map map) => map['type'] as String,
              ),
              'value': Variable(
                accessor: (Map map) => map['value'] as num,
              ),
            },
            elements: [
              IntervalElement(
                position: Varset('index') * Varset('value') / Varset('type'),
                color: ColorAttr(variable: 'type', values: Defaults.colors10),
                size: SizeAttr(value: 2),
                modifiers: [DodgeModifier(ratio: 0.1)],
              )
            ],
            axes: [
              Defaults.horizontalAxis..tickLine = TickLine(),
              Defaults.verticalAxis..tickLine = TickLine(),
            ],
            selections: {
              'tap': PointSelection(
                variable: 'index',
              )
            },
            tooltip: TooltipGuide(multiTuples: true),
            crosshair: CrosshairGuide(),
            annotations: getHintedGases(),
          ),
        ),
      ),
    );
  }
}

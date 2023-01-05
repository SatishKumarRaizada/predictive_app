import 'package:flutter/material.dart';
import 'package:graphic/graphic.dart';
import 'package:predictive_app/modules/home/chart/data.dart';

class HomePageChart extends StatelessWidget {
  const HomePageChart({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Chart(
      data: invalidData,
      variables: {
        'Date': Variable(
          accessor: (Map map) => map['Date'] as String,
          scale: OrdinalScale(tickCount: 5),
        ),
        'Close': Variable(
          accessor: (Map map) => (map['Close'] ?? double.nan) as num,
        ),
      },
      elements: [
        AreaElement(
          shape: ShapeAttr(value: BasicAreaShape(smooth: true)),
          color: ColorAttr(value: Defaults.colors10.first.withAlpha(80)),
        ),
        LineElement(
          shape: ShapeAttr(value: BasicLineShape(smooth: true)),
          size: SizeAttr(value: 0.5),
        ),
      ],
      axes: [
        Defaults.horizontalAxis,
        Defaults.verticalAxis,
      ],
      selections: {
        'touchMove': PointSelection(
          on: {GestureType.scaleUpdate, GestureType.tapDown, GestureType.longPressMoveUpdate},
          dim: Dim.x,
        )
      },
      tooltip: TooltipGuide(
        followPointer: [false, true],
        align: Alignment.topLeft,
        offset: const Offset(-20, -20),
      ),
      crosshair: CrosshairGuide(followPointer: [false, true]),
    );
  }
}

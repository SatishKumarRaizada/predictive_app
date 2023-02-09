import 'dart:math';
import 'package:flutter/material.dart';
import 'dart:math' as math;
//import 'dart:html';

class DrawTriangle extends StatelessWidget {
  //double  methane
  //double  ethane
  //double  accetelyone
  DrawTriangle();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 400,
      width: 500,
      child: CustomPaint(
        painter: CanvasDrawer(),
      ),
    );
  }
}

class CanvasDrawer extends CustomPainter {
  var v0 = Offset(114, 366);
  var v1 = Offset(306, 30);
  var v2 = Offset(498, 366);

  // pre-create a canvas-image of the arrowhead
  var arrowheadLength = 10;
  var arrowheadWidth = 8;

  final List<Map<String, dynamic>> segments = [
    {
      "points": [
        {"dx": 114, "dy": 366},
        {"dx": 281, "dy": 76},
        {"dx": 324, "dy": 150},
        {"dx": 201, "dy": 366}
      ],
      "fill": "rgb(172,236,222)",
      "label": {
        "text": "D1",
        "cx": 165,
        "cy": 395,
        "withLine": false,
        "endX": null,
        "endY": null
      }
    },
    {
      "points": [
        {"dx": 385, "dy": 366},
        {"dx": 201, "dy": 366},
        {"dx": 324, "dy": 150},
        {"dx": 356, "dy": 204},
        {"dx": 321, "dy": 256}
      ],
      "fill": 'rgb(51,51,153)',
      "label": {
        "text": 'D2',
        "cx": 300,
        "cy": 395,
        "withLine": false,
        "endX": null,
        "endY": null
      },
    },
    {
      "points": [
        {"dx": 297, "dy": 46},
        {"dx": 392, "dy": 214},
        {"dx": 372, "dy": 248},
        {"dx": 441, "dy": 366},
        {"dx": 385, "dy": 366},
        {"dx": 321, "dy": 256},
        {"dx": 356, "dy": 204},
        {"dx": 281, "dy": 76}
      ],
      "fill": 'rgb(153,0,153)',
      "label": {
        "text": 'DT',
        "cx": 245,
        "cy": 60,
        "withLine": true,
        "endX": 280,
        "endY": 55
      },
    },
    {
      "points": [
        {"dx": 306, "dy": 30},
        {"dx": 312, "dy": 40},
        {"dx": 300, "dy": 40}
      ],
      "fill": 'rgb(255,0,0)',
      "label": {
        "text": 'PD',
        "cx": 356,
        "cy": 40,
        "withLine": true,
        "endX": 321,
        "endY": 40
      },
    },
    {
      "points": [
        {"dx": 312, "dy": 40},
        {"dx": 348, "dy": 103},
        {"dx": 337, "dy": 115},
        {"dx": 297, "dy": 46},
        {"dx": 300, "dy": 40}
      ],
      "fill": 'rgb(255,153,153)',
      "label": {
        "text": 'T1',
        "cx": 375,
        "cy": 70,
        "withLine": true,
        "endX": 340,
        "endY": 75
      },
    },
    {
      "points": [
        {"dx": 348, "dy": 103},
        {"dx": 402, "dy": 199},
        {"dx": 392, "dy": 214},
        {"dx": 337, "dy": 115}
      ],
      "fill": 'rgb(255,204,0)',
      "label": {
        "text": 'T2',
        "cx": 400,
        "cy": 125,
        "withLine": true,
        "endX": 366,
        "endY": 120
      },
    },
    {
      "points": [
        {"dx": 402, "dy": 199},
        {"dx": 498, "dy": 366},
        {"dx": 441, "dy": 366},
        {"dx": 372, "dy": 248}
      ],
      "fill": 'rgb(0,0,0)',
      "label": {
        "text": 'T3',
        "cx": 480,
        "cy": 270,
        "withLine": true,
        "endX": 450,
        "endY": 270
      },
    },
  ];

  var labelFontsize = 12;
  var labelFontface = 'Verdana';
  var labelPadding = 3;

  Color stringToColor(String colorString) {
    // Extract the values between the parentheses
    final values =
        colorString.replaceAll("rgb(", "").replaceAll(")", "").split(",");

    // Convert the values to integers
    final red = int.parse(values[0].trim());
    final green = int.parse(values[1].trim());
    final blue = int.parse(values[2].trim());

    // Return the resulting Color object
    return Color.fromRGBO(red, green, blue, 1);
  }

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..style = PaintingStyle.fill
      ..color = Colors.black
      ..strokeWidth = 2.0
      ..strokeCap = StrokeCap.round;

    // Draw colored segments inside triangle
    for (var i = 0; i < segments.length; i++) {
      var path = Path();
      final segment = segments[i];
      final points = segment['points'] as List;
      final xSegment = points[0]['dx'].toDouble();
      final ySegment = points[0]['dy'].toDouble();

      path.moveTo(xSegment, ySegment);
      for (var j = 1; j < points.length; j++) {
        final dxPoint = points[j]['dx'].toDouble();
        final dyPoint = points[j]['dy'].toDouble();

        path.lineTo(dxPoint, dyPoint);
      }
      path.close();
      paint.color = stringToColor(segment['fill']);
      canvas.drawPath(path, paint);

      if (segment['label']['withLine']) {
        drawLineBoxedLabel(canvas, segments[i], labelFontsize.toDouble(),
            labelFontface, labelPadding.toDouble());
      } else {
        drawBoxedLabel(canvas, segments[i], labelFontsize.toDouble(),
            labelFontface, labelPadding.toDouble());
      }
    }

    // Draw the triangle

    // Draw tick lines
    ticklines(canvas, v0, v1, 9, 0, 20);
    ticklines(canvas, v1, v2, 9, 3.14 * 3 / 4, 20);
    ticklines(canvas, v2, v0, 9, 3.14 * 5 / 4, 20);

    // Draw molecule labels
    moleculeLabel(canvas, v0, v1, 120, 3.14, '% CH4', labelFontsize.toDouble(),
        labelFontface);
    // // Draw molecule labels

    moleculeLabelC2(canvas, v1, v2, 100, 0, '% C2H4', labelFontsize.toDouble(),
        labelFontface);

    moleculeLabel(canvas, v2, v0, 75, 3.14 / 2, '% C2H2',
        labelFontsize.toDouble(), labelFontface);

    drawTriangle(canvas);
    /* final data1 = 2333;
    final data2 = 2333;
    final data3 = 2333;
    calcOprByValue(
        canvas, data1.toDouble(), data2.toDouble(), data3.toDouble()); */
  }

/*
  void premakeArrowhead() {
      CanvasElement arrowhead = CanvasElement();
    CanvasRenderingContext2D actx = arrowhead.context2D;
    arrowhead.width = arrowheadLength;
    arrowhead.height = arrowheadWidth;
    actx.beginPath();
    actx.moveTo(0, 0);
    actx.lineTo(arrowheadLength, arrowheadWidth / 2);
    actx.lineTo(0, arrowheadWidth);
    actx.closePath();
    actx.fillStyle = 'black';
    actx.fill();
  }
*/

  void moleculeLabelC2(
      Canvas canvas,
      Offset start,
      Offset end,
      double offsetLength,
      double angle,
      String text,
      double labelFontsize,
      String labelFontface) {
    final paint = Paint()
      ..color = const Color(0xFF000000)
      ..style = PaintingStyle.fill;

    final center = Offset(start.dx + (end.dx - start.dx) * 0.5,
        start.dy + (end.dy - start.dy) * 0.5);
    final textPos = Offset(center.dx + offsetLength * math.cos(angle) - 35,
        center.dy + offsetLength * math.sin(angle));

    TextSpan span = TextSpan(text: text, style: TextStyle(color: paint.color));

    TextPainter tp = TextPainter(
        text: span,
        textAlign: TextAlign.center,
        textDirection: TextDirection.ltr);

    tp.layout();
    tp.paint(canvas, textPos);

    final x0 = start.dx + (end.dx - start.dx) * 0.35;
    final y0 = start.dy + (end.dy - start.dy) * 0.35;
    final x1 = x0 + 50 * math.cos(angle);
    final y1 = y0 + 50 * math.sin(angle);
    final x2 = start.dx + (end.dx - start.dx) * 0.65;
    final y2 = start.dy + (end.dy - start.dy) * 0.65;
    final x3 = x2 + 50 * math.cos(angle);
    final y3 = y2 + 50 * math.sin(angle);

    final paintLine = Paint()
      ..color = const Color(0xFF000000)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    canvas.drawLine(Offset(x1, y1), Offset(x3, y3), paintLine);

    final arrowSize = 10.0;
    final newangle = atan2(y3 - y1, x3 - x1);

    canvas.drawLine(
      Offset(x3, y3),
      Offset(
        x3 - arrowSize * cos(newangle - pi / 4),
        y3 - arrowSize * sin(newangle - pi / 4),
      ),
      paintLine,
    );

    canvas.drawLine(
      Offset(x3, y3),
      Offset(
        x3 - arrowSize * cos(newangle + pi / 4),
        y3 - arrowSize * sin(newangle + pi / 4),
      ),
      paintLine,
    );
  }

  void moleculeLabel(
      Canvas canvas,
      Offset start,
      Offset end,
      double offsetLength,
      double angle,
      String text,
      double labelFontsize,
      String labelFontface) {
    final paint = Paint()
      ..color = const Color(0xFF000000)
      ..style = PaintingStyle.fill;

    final center = Offset(start.dx + (end.dx - start.dx) * 0.5,
        start.dy + (end.dy - start.dy) * 0.5);
    final textPos = Offset(center.dx + offsetLength * math.cos(angle),
        center.dy + offsetLength * math.sin(angle));

    TextSpan span = TextSpan(text: text, style: TextStyle(color: paint.color));

    TextPainter tp = TextPainter(
        text: span,
        textAlign: TextAlign.center,
        textDirection: TextDirection.ltr);

    tp.layout();
    tp.paint(canvas, textPos);

    final x0 = start.dx + (end.dx - start.dx) * 0.35;
    final y0 = start.dy + (end.dy - start.dy) * 0.35;
    final x1 = x0 + 50 * math.cos(angle);
    final y1 = y0 + 50 * math.sin(angle);
    final x2 = start.dx + (end.dx - start.dx) * 0.65;
    final y2 = start.dy + (end.dy - start.dy) * 0.65;
    final x3 = x2 + 50 * math.cos(angle);
    final y3 = y2 + 50 * math.sin(angle);

    final paintLine = Paint()
      ..color = const Color(0xFF000000)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    canvas.drawLine(Offset(x1, y1), Offset(x3, y3), paintLine);

    final arrowSize = 10.0;
    final newangle = atan2(y3 - y1, x3 - x1);

    canvas.drawLine(
      Offset(x3, y3),
      Offset(
        x3 - arrowSize * cos(newangle - pi / 4),
        y3 - arrowSize * sin(newangle - pi / 4),
      ),
      paintLine,
    );

    canvas.drawLine(
      Offset(x3, y3),
      Offset(
        x3 - arrowSize * cos(newangle + pi / 4),
        y3 - arrowSize * sin(newangle + pi / 4),
      ),
      paintLine,
    );
  }

  void drawLineBoxedLabel(
      canvas, segment, double fontSize, String fontFace, double padding) {
    final cx = segment['label']['cx'].toDouble();
    final cy = segment['label']['cy'].toDouble();
    final textSeg = segment['label']['text'];
    final endX = segment['label']['endX'].toDouble();
    final endY = segment['label']['endY'].toDouble();
    double centerX = cx;
    double centerY = cy;
    String text = textSeg;
    double lineToX = endX;
    double lineToY = endY;
    TextPainter tp = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(
          fontSize: fontSize,
          fontFamily: fontFace,
          color: Colors.black,
        ),
      ),
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    )..layout();
    double textWidth = tp.width;
    double textHeight = tp.height;
    double leftX = centerX - textWidth / 2 - padding;
    double topY = centerY - textHeight / 2 - padding;
    // the line
    canvas.drawLine(
      Offset(leftX, topY + textHeight / 2),
      Offset(lineToX, topY + textHeight / 2),
      Paint()
        ..color = Colors.black
        ..strokeWidth = 1.0
        ..style = PaintingStyle.stroke,
    );
    // the boxed text
    canvas.drawRect(
      Rect.fromLTRB(leftX, topY, leftX + textWidth + padding * 2,
          topY + textHeight + padding * 2),
      Paint()..color = Colors.white,
    );
    canvas.drawRect(
      Rect.fromLTRB(leftX, topY, leftX + textWidth + padding * 2,
          topY + textHeight + padding * 2),
      Paint()
        ..color = Colors.black
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.0,
    );
    tp.paint(canvas, Offset(centerX - 6, centerY - textHeight / 2));
  }

  void drawBoxedLabel(
      canvas, segment, double fontsize, String fontface, double padding) {
    final cx = segment['label']['cx'].toDouble();
    final cy = segment['label']['cy'].toDouble();
    final textSeg = segment['label']['text'];
    double centerX = cx;
    double centerY = cy;
    String text = textSeg;
    var textSpan = new TextSpan(
      style: new TextStyle(
        fontSize: fontsize,
        fontFamily: fontface,
        color: Colors.black,
      ),
      text: text,
    );
    var textPainter = new TextPainter(
      text: textSpan,
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    var textwidth = textPainter.width;
    var textheight = fontsize * 1.286;
    var leftX = centerX - textwidth / 2 - padding;
    var topY = centerY - textheight / 2 - padding;
    var rect = Rect.fromLTRB(
      leftX,
      topY,
      leftX + textwidth + padding * 2,
      topY + textheight + padding * 2,
    );
    canvas.drawRect(
      rect,
      new Paint()
        ..color = Colors.white
        ..style = PaintingStyle.fill,
    );
    canvas.drawRect(
      rect,
      new Paint()
        ..color = Colors.black
        ..strokeWidth = 1
        ..style = PaintingStyle.stroke,
    );
    textPainter.paint(canvas, new Offset(centerX - 10, centerY - 10));
  }

  void drawTriangle(canvas) {
    var paint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    canvas.drawPath(
      Path()
        ..moveTo(v0.dx, v0.dy)
        ..lineTo(v1.dx, v1.dy)
        ..lineTo(v2.dx, v2.dy)
        ..close(),
      paint,
    );
  }

  void ticklines(Canvas canvas, Offset start, Offset end, int count,
      double angle, double length) {
    double dx = end.dx - start.dx;
    double dy = end.dy - start.dy;

    Paint paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 1;

    for (var i = 1; i < count; i++) {
      int x0 = (start.dx + dx * i / count).round();
      int y0 = (start.dy + dy * i / count).round();
      int x1 = (x0 + length * math.cos(angle)).round();
      int y1 = (y0 + length * math.sin(angle)).round();

      canvas.drawLine(Offset(x0.toDouble(), y0.toDouble()),
          Offset(x1.toDouble(), y1.toDouble()), paint);

      if (i == 2 || i == 4 || i == 6 || i == 8) {
        double labelOffset = length * 3 / 4;
        x1 = (x0 - labelOffset * math.cos(angle)).round();
        y1 = (y0 - labelOffset * math.sin(angle)).round();
        TextPainter(
          text: TextSpan(
            text: (i * 10).toString(),
            style: TextStyle(
              color: Colors.black,
              fontSize: 12.0,
              fontFamily: 'Verdana',
            ),
          ),
          textDirection: TextDirection.ltr,
        )
          ..layout(minWidth: 0, maxWidth: double.infinity)
          ..paint(canvas, Offset(x1.toDouble() - 10, y1.toDouble()));
      }
    }
  }

  void ticklineslll(canvas, Offset start, Offset end, int count, double angle,
      double length) {
    double dx = end.dx - start.dx;
    double dy = end.dy - start.dy;
    canvas.context.lineWidth = 1;
    for (var i = 1; i < count; i++) {
      int x0 = (start.dx + dx * i / count).round();
      int y0 = (start.dy + dy * i / count).round();
      int x1 = (x0 + length * math.cos(angle)).round();
      int y1 = (y0 + length * math.sin(angle)).round();
      canvas.context.beginPath();
      canvas.context.moveTo(x0, y0);
      canvas.context.lineTo(x1, y1);
      canvas.context.stroke();
      if (i == 2 || i == 4 || i == 6 || i == 8) {
        double labelOffset = length * 3 / 4;
        x1 = (x0 - labelOffset * math.cos(angle)).round();
        y1 = (y0 - labelOffset * math.sin(angle)).round();
        canvas.context.fillStyle = 'black';
        canvas.context.fillText((i * 10).toString(), x1, y1);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint$
    throw UnimplementedError();
  }
}

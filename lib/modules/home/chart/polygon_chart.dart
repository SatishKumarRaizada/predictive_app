// Return hint text
import 'package:flutter/material.dart';
import 'package:graphic/graphic.dart';

List<Annotation> getHintedGases() {
  return <Annotation>[
    MarkAnnotation(
      relativePath: Path()..addRect(Rect.fromCircle(center: const Offset(0, 0), radius: 5)),
      style: Paint()..color = const Color(0xff5b8ff9),
      anchor: (size) => const Offset(25, 290),
    ),
    TagAnnotation(
      label: Label(
        'Hydrogen',
        LabelStyle(style: Defaults.textStyle, align: Alignment.centerRight),
      ),
      anchor: (size) => const Offset(34, 290),
    ),
    MarkAnnotation(
      relativePath: Path()..addRect(Rect.fromCircle(center: const Offset(0, 0), radius: 5)),
      style: Paint()..color = const Color(0xff5ad8a6),
      anchor: (size) => Offset(25 + size.width / 5, 290),
    ),
    TagAnnotation(
      label: Label(
        'Methane',
        LabelStyle(style: Defaults.textStyle, align: Alignment.centerRight),
      ),
      anchor: (size) => Offset(34 + size.width / 5, 290),
    ),
    MarkAnnotation(
      relativePath: Path()..addRect(Rect.fromCircle(center: const Offset(0, 0), radius: 5)),
      style: Paint()..color = const Color(0xff5d7092),
      anchor: (size) => Offset(25 + size.width / 5 * 2, 290),
    ),
    TagAnnotation(
      label: Label(
        'Acetylene',
        LabelStyle(style: Defaults.textStyle, align: Alignment.centerRight),
      ),
      anchor: (size) => Offset(34 + size.width / 5 * 2, 290),
    ),
    MarkAnnotation(
      relativePath: Path()..addRect(Rect.fromCircle(center: const Offset(0, 0), radius: 5)),
      style: Paint()..color = const Color(0xfff6bd16),
      anchor: (size) => Offset(25 + size.width / 5 * 3, 290),
    ),
    TagAnnotation(
      label: Label(
        'Ethylene',
        LabelStyle(style: Defaults.textStyle, align: Alignment.centerRight),
      ),
      anchor: (size) => Offset(34 + size.width / 5 * 3, 290),
    ),
    MarkAnnotation(
      relativePath: Path()..addRect(Rect.fromCircle(center: const Offset(0, 0), radius: 5)),
      style: Paint()..color = const Color(0xffff9845),
      anchor: (size) => Offset(25 + size.width / 5 * 4, 290),
    ),
    TagAnnotation(
      label: Label(
        'Ethane',
        LabelStyle(style: Defaults.textStyle, align: Alignment.centerRight),
      ),
      anchor: (size) => Offset(34 + size.width / 5 * 4, 290),
    ),
    MarkAnnotation(
      relativePath: Path()..addRect(Rect.fromCircle(center: const Offset(0, 0), radius: 5)),
      style: Paint()..color = const Color(0xff6f5ef9),
      anchor: (size) => Offset(25 + size.width / 5 * 4, 290),
    ),
  ];
}

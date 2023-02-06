import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:predictive_app/modules/app_container/app_container.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  var path = Directory.current.path;
  Hive.init(path);
  await Hive.openBox('testBox');
  runApp(const ProviderScope(child: PredictiveAppContainer()));
}

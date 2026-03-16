import 'package:flutter/material.dart';

import 'package:example_flutter_02/app.dart';
import 'package:example_flutter_02/core/di/injection.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initDependencies();
  runApp(const App());
}

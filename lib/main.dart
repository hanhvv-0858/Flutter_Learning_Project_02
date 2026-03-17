import 'package:flutter/material.dart';

import 'package:example_flutter_02/app.dart';
import 'package:example_flutter_02/core/di/injection.dart';
import 'package:example_flutter_02/features/settings/presentation/bloc/settings_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initDependencies();
  // Load persisted locale before the first frame.
  await getIt<SettingsCubit>().loadLocale();
  runApp(const App());
}

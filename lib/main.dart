import 'package:flutter/material.dart';

import 'package:flutter_learning_project_2/app.dart';
import 'package:flutter_learning_project_2/core/di/injection.dart';
import 'package:flutter_learning_project_2/features/settings/presentation/bloc/settings_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initDependencies();
  // Load persisted locale before the first frame.
  await getIt<SettingsCubit>().loadLocale();
  runApp(const App());
}

import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

import 'package:example_flutter_02/injection.config.dart';

/// Global GetIt service locator instance.
final getIt = GetIt.instance;

/// Initializes all dependencies registered via `@injectable`, `@lazySingleton`,
/// and the `@module` class in [RegisterModule].
///
/// Must be called in `main()` before `runApp()`.
@InjectableInit()
Future<void> configureDependencies() async => getIt.init();

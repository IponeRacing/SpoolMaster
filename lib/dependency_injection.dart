import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:nfc_filament/dependency_injection.config.dart';
import 'package:shared_preferences/shared_preferences.dart';

final getIt = GetIt.instance;

@InjectableInit()
Future<void> configureDependencies() async {
  // Register SharedPreferences
  final sharedPreferences = await SharedPreferences.getInstance();
  getIt
    ..registerSingleton<SharedPreferences>(sharedPreferences)
    // Initialize injectable dependencies
    ..init();
}

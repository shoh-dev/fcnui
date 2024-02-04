import 'package:get_it/get_it.dart';
import '../functions/init/init_json.dart';
import '../src.dart';

final getIt = GetIt.instance;

void initializeDependency() {
  if (getIt.isRegistered<ApiClient>()) return;
  getIt.registerSingleton<ApiClient>(ApiClient());
}

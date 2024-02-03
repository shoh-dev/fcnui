import 'package:get_it/get_it.dart';

import '../api/api.dart';

final getIt = GetIt.instance;

void initializeDependency() {
  if (getIt.isRegistered<ApiClient>()) return;
  getIt.registerSingleton<ApiClient>(ApiClient());
}

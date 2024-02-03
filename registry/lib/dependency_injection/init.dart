import 'package:get_it/get_it.dart';
import 'package:registry/store/store.dart';

final getIt = GetIt.instance;

void initDependency() {
  getIt.registerSingleton<Store<AppState>>(appStore);
}

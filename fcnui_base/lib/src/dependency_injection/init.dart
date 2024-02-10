import 'package:flutter/cupertino.dart';
import 'package:get_it/get_it.dart';
import 'package:fcnui_base/src/store/store.dart';

final fcnGetIt = GetIt.instance;

void initDependency() {
  if (!fcnGetIt.isRegistered<Store<AppState>>()) {
    fcnGetIt.registerSingleton<Store<AppState>>(appStore);
  }
  debugPrint('Dependency Injection initialized for fcnui');
}

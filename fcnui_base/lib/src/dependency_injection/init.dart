import 'package:flutter/cupertino.dart';
import 'package:get_it/get_it.dart';
import 'package:fcnui_base/src/store/store.dart';

final fcnGetIt = GetIt.instance;

final fcnStore = _getStore();

Store<AppState> _getStore() {
  return fcnGetIt.get<Store<AppState>>();
}

void initDependency() {
  if (!fcnGetIt.isRegistered<Store<AppState>>()) {
    fcnGetIt.registerSingleton<Store<AppState>>(appStore);
  }
  debugPrint('Dependency Injection initialized for fcnui');
}

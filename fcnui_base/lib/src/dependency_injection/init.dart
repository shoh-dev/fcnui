import 'package:flutter/cupertino.dart';
import 'package:get_it/get_it.dart';
import 'package:fcnui_base/src/store/store.dart';

final fcnGetIt = GetIt.instance;

final fcnStore = _getStore();

Store<FcnuiAppState> _getStore() {
  return fcnGetIt.get<Store<FcnuiAppState>>();
}

void initDependency() {
  if (!fcnGetIt.isRegistered<Store<FcnuiAppState>>()) {
    fcnGetIt.registerSingleton<Store<FcnuiAppState>>(appStore);
  }
  debugPrint('Dependency Injection initialized for fcnui');
}

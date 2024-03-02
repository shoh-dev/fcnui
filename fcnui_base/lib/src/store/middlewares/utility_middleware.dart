import 'package:fcnui_base/src/store/store.dart';

class UtilityStateMiddleware extends MiddlewareClass<FcnuiAppState> {
  @override
  call(Store<FcnuiAppState> store, action, NextDispatcher next) {
    if (action is ChangeScreenUtilEnabledState) {
      return _changeScreenUtilEnabledState(store, action, next);
    }
    return next(action);
  }

  void _changeScreenUtilEnabledState(Store<FcnuiAppState> store,
      ChangeScreenUtilEnabledState action, NextDispatcher next) {
    if (action.isScreenUtilEnabled ==
        store.state.utilityState.isScreenUtilEnabled) return;
    next(UpdateUtilityState(isScreenUtilEnabled: action.isScreenUtilEnabled));
  }
}

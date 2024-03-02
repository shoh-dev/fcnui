import 'package:fcnui_base/src/store/store.dart';

class ThemeStateMiddleware extends MiddlewareClass<FcnuiAppState> {
  @override
  call(Store<FcnuiAppState> store, action, NextDispatcher next) {
    if (action is ChangeThemeModeAction) {
      return _changeThemeModeAction(store, action, next);
    }
    if (action is ChangeFlexSchemeAction) {
      return _changeFlexSchemeAction(store, action, next);
    }
    if (action is ChangeUsePlatformThemeAction) {
      return _changeUsePlatformThemeAction(store, action, next);
    }
    return next(action);
  }

  void _changeThemeModeAction(Store<FcnuiAppState> store,
      ChangeThemeModeAction action, NextDispatcher next) {
    if (action.themeMode == store.state.themeState.themeMode) return;
    next(UpdateThemeState(themeMode: action.themeMode));
  }

  void _changeFlexSchemeAction(Store<FcnuiAppState> store,
      ChangeFlexSchemeAction action, NextDispatcher next) {
    if (action.flexScheme == store.state.themeState.flexScheme) return;
    next(UpdateThemeState(flexScheme: action.flexScheme));
  }

  void _changeUsePlatformThemeAction(Store<FcnuiAppState> store,
      ChangeUsePlatformThemeAction action, NextDispatcher next) {
    if (action.usePlatformTheme == store.state.themeState.usePlatformTheme) {
      return;
    }
    next(UpdateThemeState(usePlatformTheme: action.usePlatformTheme));
  }
}

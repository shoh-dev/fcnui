import 'package:fcnui_base/src/store/store.dart';

AppState appReducer(AppState state, dynamic action) {
  var newState = state.copyWith(
    themeState: _themeReducer(state.themeState, action),
    utilityState: _utilityReducer(state.utilityState, action),
  );
  return newState;
}

final _themeReducer = combineReducers<ThemeState>(
    [TypedReducer<ThemeState, UpdateThemeState>(_updateGeneralState)]);

ThemeState _updateGeneralState(ThemeState state, UpdateThemeState action) {
  return state.copyWith(
    themeMode: action.themeMode ?? state.themeMode,
    flexScheme: action.flexScheme ?? state.flexScheme,
    usePlatformTheme: action.usePlatformTheme ?? state.usePlatformTheme,
  );
}

final _utilityReducer = combineReducers<UtilityState>([
  TypedReducer<UtilityState, UpdateUtilityState>(_changeScreenUtilEnabledState)
]);

UtilityState _changeScreenUtilEnabledState(
    UtilityState state, UpdateUtilityState action) {
  return state.copyWith(
    isScreenUtilEnabled:
        action.isScreenUtilEnabled ?? state.isScreenUtilEnabled,
  );
}

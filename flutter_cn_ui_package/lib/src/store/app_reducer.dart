import 'package:flutter_cn_ui_package/src/store/store.dart';

AppState appReducer(AppState state, dynamic action) {
  var newState = state.copyWith(
    themeState: _themeReducer(state.themeState, action),
  );
  return newState;
}

final _themeReducer = combineReducers<ThemeState>(
    [TypedReducer<ThemeState, UpdateThemeState>(_updateGeneralState)]);
ThemeState _updateGeneralState(ThemeState state, UpdateThemeState action) {
  return state.copyWith(
    themeMode: action.themeMode ?? state.themeMode,
    flexScheme: action.flexScheme ?? state.flexScheme,
  );
}

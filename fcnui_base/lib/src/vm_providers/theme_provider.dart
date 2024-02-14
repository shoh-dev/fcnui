import 'package:flutter/material.dart';
import 'package:fcnui_base/fcnui_base.dart';

class ThemeProvider extends StatelessWidget {
  final ViewModelBuilder<ThemeVm> builder;

  const ThemeProvider({super.key, required this.builder});
  @override
  Widget build(BuildContext context) {
    return DefaultStoreConnector<ThemeVm>(
      converter: (store) => ThemeVm.fromStore(store, context),
      builder: (context, vm) {
        return builder(context, vm);
      },
    );
  }
}

class ThemeVm extends Equatable {
  final ThemeMode themeMode;
  final FlexScheme flexScheme;

  final ThemeData theme;

  final ValueChanged<ThemeMode> onToggleThemeMode;

  final ValueChanged<FlexScheme> onChangeThemeScheme;

  const ThemeVm(
      {required this.themeMode,
      required this.flexScheme,
      required this.theme,
      required this.onToggleThemeMode,
      required this.onChangeThemeScheme});

  factory ThemeVm.fromStore(Store<AppState> store, BuildContext context) {
    ThemeMode themeMode = kDefaultThemeModeValue;
    FlexScheme flexScheme = kDefaultFlexSchemeValue;

    final dispatch = store.dispatch;

    final themeModeStr = store.state.themeState.themeMode;
    final flexSchemeStr = store.state.themeState.flexScheme;
    final bool usePlatformTheme = store.state.themeState.usePlatformTheme;

    if (themeModeStr == 'dark') {
      themeMode = ThemeMode.dark;
    } else if (themeModeStr == 'light') {
      themeMode = ThemeMode.light;
    } else if (themeModeStr == 'system') {
      themeMode = ThemeMode.system;
    }

    flexScheme = FlexScheme.values.firstWhere((e) => e.name == flexSchemeStr,
        orElse: () => kDefaultFlexSchemeValue);

    final theme = usePlatformTheme
        ? Theme.of(context)
        : (themeMode == ThemeMode.dark
            ? FlexThemeData.dark(scheme: flexScheme, useMaterial3: true)
            : FlexThemeData.light(scheme: flexScheme, useMaterial3: true));

    return ThemeVm(
      themeMode: themeMode,
      flexScheme: flexScheme,
      theme: theme,
      onChangeThemeScheme: (value) =>
          dispatch(ChangeFlexSchemeAction(flexScheme: value.name)),
      onToggleThemeMode: (value) =>
          dispatch(ChangeThemeModeAction(themeMode: value.name)),
    );
  }

  @override
  List<Object?> get props => [themeMode, flexScheme, theme];
}

import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:registry/store/store.dart';
import 'vm_providers.dart';

class ThemeProvider extends StatelessWidget {
  final ViewModelBuilder<ThemeVm> builder;

  const ThemeProvider({super.key, required this.builder});
  @override
  Widget build(BuildContext context) {
    return DefaultStoreConnector<ThemeVm>(
      converter: (store) => ThemeVm.fromStore(store),
      builder: (context, vm) {
        return builder(context, vm);
      },
    );
  }
}

class ThemeVm {
  final ThemeMode themeMode;
  final FlexScheme flexScheme;

  ThemeVm({required this.themeMode, required this.flexScheme});

  factory ThemeVm.fromStore(Store<AppState> store) {
    ThemeMode themeMode = kDefaultThemeModeValue;
    FlexScheme flexScheme = kDefaultFlexSchemeValue;

    final themeModeStr = store.state.themeState.themeMode;
    final flexSchemeStr = store.state.themeState.flexScheme;

    if (themeModeStr == 'dark') {
      themeMode = ThemeMode.dark;
    } else if (themeModeStr == 'light') {
      themeMode = ThemeMode.light;
    }

    flexScheme = FlexScheme.values.firstWhere((e) => e.name == flexSchemeStr,
        orElse: () => kDefaultFlexSchemeValue);

    return ThemeVm(themeMode: themeMode, flexScheme: flexScheme);
  }
}

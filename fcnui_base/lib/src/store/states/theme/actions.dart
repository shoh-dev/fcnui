import 'package:fcnui_base/src/store/f_action.dart';

class UpdateThemeState extends FAction {
  final String? themeMode;
  final String? flexScheme;

  final bool? usePlatformTheme;

  UpdateThemeState({this.themeMode, this.flexScheme, this.usePlatformTheme});

  @override
  List<Object?> get props => [themeMode, flexScheme, usePlatformTheme];
}

class ChangeThemeModeAction extends FAction {
  final String themeMode;

  ChangeThemeModeAction({required this.themeMode});

  @override
  List<Object?> get props => [themeMode];
}

class ChangeFlexSchemeAction extends FAction {
  final String flexScheme;

  ChangeFlexSchemeAction({required this.flexScheme});

  @override
  List<Object?> get props => [flexScheme];
}

class ChangeUsePlatformThemeAction extends FAction {
  final bool usePlatformTheme;

  ChangeUsePlatformThemeAction({required this.usePlatformTheme});

  @override
  List<Object?> get props => [usePlatformTheme];
}

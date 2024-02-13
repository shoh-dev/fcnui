import 'package:equatable/equatable.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';

const String kDefaultThemeMode = 'dark';
const String kDefaultFlexScheme = 'deepBlue';
const ThemeMode kDefaultThemeModeValue = ThemeMode.dark;
const FlexScheme kDefaultFlexSchemeValue = FlexScheme.deepBlue;

@immutable
class ThemeState extends Equatable {
  final String themeMode;
  final String flexScheme;

  final bool usePlatformTheme;

  const ThemeState(
      {required this.themeMode,
      required this.flexScheme,
      required this.usePlatformTheme});

  factory ThemeState.initial() {
    return const ThemeState(
      themeMode: kDefaultThemeMode,
      flexScheme: kDefaultFlexScheme,
      usePlatformTheme: false,
    );
  }

  ThemeState copyWith(
      {String? themeMode, String? flexScheme, bool? usePlatformTheme}) {
    return ThemeState(
      usePlatformTheme: usePlatformTheme ?? this.usePlatformTheme,
      themeMode: themeMode ?? this.themeMode,
      flexScheme: flexScheme ?? this.flexScheme,
    );
  }

  @override
  List<Object?> get props => [themeMode, flexScheme, usePlatformTheme];
}

class UpdateThemeState {
  final String? themeMode;
  final String? flexScheme;

  final bool? usePlatformTheme;

  UpdateThemeState({this.themeMode, this.flexScheme, this.usePlatformTheme});
}

class ChangeThemeModeAction {
  final String themeMode;

  ChangeThemeModeAction({required this.themeMode});
}

class ChangeFlexSchemeAction {
  final String flexScheme;

  ChangeFlexSchemeAction({required this.flexScheme});
}

class ChangeUsePlatformThemeAction {
  final bool usePlatformTheme;

  ChangeUsePlatformThemeAction({required this.usePlatformTheme});
}

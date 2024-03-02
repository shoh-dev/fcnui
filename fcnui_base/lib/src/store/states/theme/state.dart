import 'package:equatable/equatable.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';

const String kDefaultThemeMode = 'light';
const String kDefaultFlexScheme = 'material';
const ThemeMode kDefaultThemeModeValue = ThemeMode.light;
const FlexScheme kDefaultFlexSchemeValue = FlexScheme.material;

@immutable
class ThemeState extends Equatable {
  final String themeMode;
  final String flexScheme;

  ///This is used if you want to use the theme you are already using from Material/CupertinoApp
  ///
  /// In case you want to use the theme from Material/CupertinoApp, set this to true
  ///
  /// by calling [ChangeUsePlatformThemeAction(usePlatformTheme: true).payload()]
  ///
  /// Call pass this action to the [DefaultStoreProvider]
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

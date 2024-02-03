import 'package:equatable/equatable.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';

const String kDefaultFlexScheme = 'mandyRed';
const String kDefaultThemeMode = 'system';
const ThemeMode kDefaultThemeModeValue = ThemeMode.system;
const FlexScheme kDefaultFlexSchemeValue = FlexScheme.mandyRed;

@immutable
class ThemeState extends Equatable {
  final String themeMode;
  final String flexScheme;

  const ThemeState({required this.themeMode, required this.flexScheme});

  factory ThemeState.initial() {
    return const ThemeState(
      themeMode: kDefaultThemeMode,
      flexScheme: kDefaultFlexScheme,
    );
  }

  ThemeState copyWith({String? themeMode, String? flexScheme}) {
    return ThemeState(
      themeMode: themeMode ?? this.themeMode,
      flexScheme: flexScheme ?? this.flexScheme,
    );
  }

  @override
  List<Object?> get props => [themeMode, flexScheme];
}

class UpdateThemeState {
  final String? themeMode;
  final String? flexScheme;

  UpdateThemeState({this.themeMode, this.flexScheme});
}

class ChangeThemeModeAction {
  final String themeMode;

  ChangeThemeModeAction({required this.themeMode});
}

class ChangeFlexSchemeAction {
  final String flexScheme;

  ChangeFlexSchemeAction({required this.flexScheme});
}

import 'package:flutter/foundation.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_cn_ui_package/src/store/states/states.dart';

@immutable
class AppState extends Equatable {
  final ThemeState themeState;

  const AppState({required this.themeState});

  factory AppState.initial() {
    return AppState(themeState: ThemeState.initial());
  }

  AppState copyWith({ThemeState? themeState}) {
    return AppState(
      themeState: themeState ?? this.themeState,
    );
  }

  @override
  List<Object?> get props => [themeState];
}

class UpdateAppState {
  final ThemeState? themeState;

  UpdateAppState({this.themeState});
}

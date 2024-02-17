import 'package:flutter/foundation.dart';
import 'package:equatable/equatable.dart';
import 'package:fcnui_base/src/store/states/states.dart';

@immutable
class AppState extends Equatable {
  final ThemeState themeState;
  final UtilityState utilityState;

  const AppState({required this.themeState, required this.utilityState});

  factory AppState.initial() {
    return AppState(
      themeState: ThemeState.initial(),
      utilityState: UtilityState.initial(),
    );
  }

  AppState copyWith({ThemeState? themeState, UtilityState? utilityState}) {
    return AppState(
      themeState: themeState ?? this.themeState,
      utilityState: utilityState ?? this.utilityState,
    );
  }

  @override
  List<Object?> get props => [themeState, utilityState];
}

class UpdateAppState {
  final ThemeState? themeState;
  final UtilityState? utilityState;

  UpdateAppState({this.themeState, this.utilityState});
}

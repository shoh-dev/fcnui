import 'package:flutter/foundation.dart';
import 'package:equatable/equatable.dart';
import 'package:fcnui_base/src/store/states/states.dart';

@immutable
class FcnuiAppState extends Equatable {
  final ThemeState themeState;
  final UtilityState utilityState;

  const FcnuiAppState({required this.themeState, required this.utilityState});

  factory FcnuiAppState.initial() {
    return FcnuiAppState(
      themeState: ThemeState.initial(),
      utilityState: UtilityState.initial(),
    );
  }

  FcnuiAppState copyWith({ThemeState? themeState, UtilityState? utilityState}) {
    return FcnuiAppState(
      themeState: themeState ?? this.themeState,
      utilityState: utilityState ?? this.utilityState,
    );
  }

  @override
  List<Object?> get props => [themeState, utilityState];
}

class UpdateFcnuiAppState {
  final ThemeState? themeState;
  final UtilityState? utilityState;

  UpdateFcnuiAppState({this.themeState, this.utilityState});
}

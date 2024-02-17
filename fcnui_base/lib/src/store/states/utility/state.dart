import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
class UtilityState extends Equatable {
  /// In case you want to use screenUtil, set this to true
  ///
  /// by calling [ChangeScreenUtilEnabledState(isScreenUtilEnabled: true).payload()]
  ///
  /// Call pass this action to the [DefaultStoreProvider]
  final bool isScreenUtilEnabled;

  const UtilityState({
    required this.isScreenUtilEnabled,
  });

  factory UtilityState.initial() {
    return const UtilityState(
      isScreenUtilEnabled: false,
    );
  }

  UtilityState copyWith({
    bool? isScreenUtilEnabled,
  }) {
    return UtilityState(
      isScreenUtilEnabled: isScreenUtilEnabled ?? this.isScreenUtilEnabled,
    );
  }

  @override
  List<Object?> get props => [isScreenUtilEnabled];
}

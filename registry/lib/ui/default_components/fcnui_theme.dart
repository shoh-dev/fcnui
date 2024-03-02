import 'package:fcnui_base/fcnui_base.dart';
import 'package:flutter/material.dart';

abstract class FcnuiDefaultSizes {
  static const double borderRadius = 16.0;
  static const double paddingVertical = 16.0;
  static const double paddingHorizontal = 16.0;
  static const double borderWidth = 1.0;
  static const double selectedBorderWidth = 2.0;
  static const double iconSize = 16.0;

  static const itemSpacing = 4.0;
}

class FcnuiDefaultColor {
  final BuildContext context;

  FcnuiDefaultColor(this.context);

  ThemeData get theme {
    final ThemeVm themeVm = ThemeVm.fromStore(fcnStore, context);
    return themeVm.theme;
  }

  Color get borderColor => theme.dividerColor.withOpacity(.4);

  Color get errorColor => Colors.red;

  Color get greyColor => theme.colorScheme.onSurface.withOpacity(.5);
}

abstract class DecorationImpl {
  final BuildContext context;

  ColorImpl? color;
  BorderImpl? border;
  SizeImpl? size;
  StateImpl? state;
  ActionImpl? action;
  ChildImpl? child;
  ValueImpl? value;

  DecorationImpl(
    this.context, {
    this.color,
    this.border,
    this.size,
    this.state,
    this.action,
    this.child,
    this.value,
  });

  ThemeVm get themeVm {
    final ThemeVm themeVm = ThemeVm.fromStore(fcnStore, context);
    return themeVm;
  }

  ThemeData get theme => themeVm.theme;
}

/// Color type of states
///
/// ex: background, primary, secondary, etc
abstract class ColorImpl {
  final BuildContext context;

  ColorImpl(this.context);

  ThemeData get theme {
    final ThemeVm themeVm = ThemeVm.fromStore(fcnStore, context);
    return themeVm.theme;
  }

  Color get primary => theme.colorScheme.primary;

  Color get secondary => theme.colorScheme.secondary;

  Color get tertiary => theme.colorScheme.tertiary;

  Color get surface => theme.colorScheme.surface;

  Color get error => Colors.red;

  Color get onPrimary => theme.colorScheme.onPrimary;

  Color get onSecondary => theme.colorScheme.onSecondary;

  Color get onTertiary => theme.colorScheme.onTertiary;

  Color get onBackground => theme.colorScheme.onBackground;

  Color get onSurface => theme.colorScheme.onSurface;
}

/// Border type of states
///
/// ex: border, borderRadius, etc
abstract class BorderImpl {
  final BuildContext context;

  BorderSide? borderSide;

  BorderRadius? borderRadius;

  BorderImpl(this.context, {this.borderSide, this.borderRadius});

  ThemeData get theme {
    final ThemeVm themeVm = ThemeVm.fromStore(fcnStore, context);
    return themeVm.theme;
  }
}

/// Size type of states
///
/// ex: padding, margin, etc
abstract class SizeImpl {
  final BuildContext context;

  SizeImpl(this.context);

  ThemeData get theme {
    final ThemeVm themeVm = ThemeVm.fromStore(fcnStore, context);
    return themeVm.theme;
  }
}

/// Boolean type of states
///
/// ex: isDisabled, isLoading, etc
abstract class StateImpl {
  final BuildContext context;

  final bool isDisabled;
  final bool isLoading;

  StateImpl(this.context, {this.isLoading = false, this.isDisabled = false});

  ThemeData get theme {
    final ThemeVm themeVm = ThemeVm.fromStore(fcnStore, context);
    return themeVm.theme;
  }
}

/// Action type of states
///
/// ex: onPressed, onLongPressed, etc
abstract class ActionImpl<T> {
  final BuildContext context;

  final VoidCallback? onPressed;

  final ValueChanged<T>? onValueChanged;

  ActionImpl(this.context, {this.onPressed, this.onValueChanged});

  ThemeData get theme {
    final ThemeVm themeVm = ThemeVm.fromStore(fcnStore, context);
    return themeVm.theme;
  }
}

/// Child related theme
///
/// ex: child, icon, etc
abstract class ChildImpl {
  final BuildContext context;

  Widget? child;

  ChildImpl(this.context, {this.child});

  ThemeData get theme {
    final ThemeVm themeVm = ThemeVm.fromStore(fcnStore, context);
    return themeVm.theme;
  }
}

/// Value related
///
/// initialValue, validator, etc
abstract class ValueImpl {
  final BuildContext context;

  ValueImpl(this.context);
}

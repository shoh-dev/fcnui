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
    final ThemeVm themeVm =
        ThemeVm.fromStore(fcnGetIt.get<Store<AppState>>(), context);
    return themeVm.theme;
  }

  Color get borderColor => theme.dividerColor.withOpacity(.4);

  Color get errorColor => Colors.red;

  Color get greyColor => theme.colorScheme.onSurface.withOpacity(.5);
}

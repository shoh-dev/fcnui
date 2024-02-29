import 'package:fcnui_base/fcnui_base.dart';
import 'package:flutter/material.dart';

//todo: add responsive

bool get _enabled => fcnStore.state.utilityState.isScreenUtilEnabled;

extension ResponsiveDouble on num {
  double get w => (_enabled ? this : this).toDouble();

  double get h => (_enabled ? this : this).toDouble();

  double get r => (_enabled ? this : this).toDouble();

  double get sp => (_enabled ? this : this).toDouble();
}

extension ResponsiveSize on Size {
  Size get w => _enabled ? Size(width.w, height.h) : this;
}

extension ResponsiveEdgeInsets on EdgeInsets {
  EdgeInsets get w => _enabled ? this : this;
}

extension ResponsiveEdgeInsetsGeometry on EdgeInsetsGeometry {
  EdgeInsetsGeometry get w => _enabled ? this : this;
}

extension ResponsiveTextStyle on TextStyle {
  TextStyle get sp => _enabled ? copyWith(fontSize: fontSize?.sp) : this;
}

extension ResponsiveSizedBox on SizedBox {
  SizedBox get w => _enabled
      ? SizedBox(
          width: width?.w,
          height: height?.h,
          key: key,
          child: child,
        )
      : this;
}

extension ResponsiveBorderSize on BorderSide {
  BorderSide get w => _enabled
      ? BorderSide(
          color: color,
          width: width.w,
          style: style,
          strokeAlign: strokeAlign,
        )
      : this;
}

extension ResponsiveBorder on Border {
  Border get w => _enabled
      ? Border(
          top: top.w,
          right: right.w,
          bottom: bottom.w,
          left: left.w,
        )
      : this;
}

extension ResponsiveBorderRadius on BorderRadius {
  BorderRadius get r => _enabled ? this : this;
}

extension ResponsiveOffset on Offset {
  Offset get w => _enabled ? Offset(dx.w, dy.h) : this;
}

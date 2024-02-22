import 'package:fcnui_base/fcnui_base.dart';
import 'package:flutter/material.dart';

extension RowHelper on Row {
  ///Do not add responsive helper to double value [space]
  ///
  /// Added automatically
  Row spaced(double space) => children.isEmpty
      ? Row(
          mainAxisAlignment: mainAxisAlignment,
          crossAxisAlignment: crossAxisAlignment,
          mainAxisSize: mainAxisSize,
          children: children)
      : Row(
          mainAxisAlignment: mainAxisAlignment,
          crossAxisAlignment: crossAxisAlignment,
          mainAxisSize: mainAxisSize,
          children: children
              .expand((widget) => [
                    widget,
                    SizedBox(width: space.w),
                  ])
              .toList()
            ..removeLast(),
        );
}

extension ColumnHelper on Column {
  /// Do not add responsive helper to double value [space]
  ///
  /// Added automatically
  Column spaced(double space) => children.isEmpty
      ? Column(
          mainAxisAlignment: mainAxisAlignment,
          crossAxisAlignment: crossAxisAlignment,
          mainAxisSize: mainAxisSize,
          children: children)
      : Column(
          mainAxisAlignment: mainAxisAlignment,
          crossAxisAlignment: crossAxisAlignment,
          mainAxisSize: mainAxisSize,
          children: children
              .expand((widget) => [
                    widget,
                    SizedBox(height: space.h),
                  ])
              .toList()
            ..removeLast());
}

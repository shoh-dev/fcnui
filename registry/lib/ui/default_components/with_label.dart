//v0.0.1

import 'package:fcnui_base/fcnui_base.dart';
import 'package:flutter/material.dart';

import 'label.dart';

export 'label.dart';

class WithLabel extends StatelessWidget {
  final LabelDecorationBuilder labelBuilder;
  final Widget child;
  const WithLabel({super.key, required this.labelBuilder, required this.child});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Label(decorationBuilder: labelBuilder),
        child,
      ],
    ).spaced(4);
  }
}

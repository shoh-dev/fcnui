// ignore: must_be_immutable
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class SpacedRow extends StatelessWidget {
  //Do not add screenUtil, Just pass double value
  double? space;
  List<Widget> children;
  MainAxisAlignment? mainAxisAlignment;
  CrossAxisAlignment? crossAxisAlignment;
  MainAxisSize mainAxisSize;

  SpacedRow(
      {super.key,
      this.space = 0.0,
      required this.children,
      this.mainAxisAlignment = MainAxisAlignment.start,
      this.mainAxisSize = MainAxisSize.max,
      this.crossAxisAlignment = CrossAxisAlignment.start});

  @override
  Widget build(BuildContext context) {
    List<Widget> widgets = [];
    for (var element in children) {
      widgets.add(element);
      if (children.last == element) {
      } else {
        widgets.add(SizedBox(
          width: space!,
        ));
      }
    }
    return Row(
      mainAxisAlignment: mainAxisAlignment!,
      crossAxisAlignment: crossAxisAlignment!,
      mainAxisSize: mainAxisSize,
      children: widgets,
    );
  }
}

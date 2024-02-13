import 'package:flutter/material.dart';

// ignore: must_be_immutable
class SpacedColumn extends StatelessWidget {
  //Do not add screenUtil, Just pass double value
  double? space;
  List<Widget> children;
  MainAxisAlignment? mainAxisAlignment;
  CrossAxisAlignment? crossAxisAlignment;
  MainAxisSize? mainAxisSize;
  final Color? dividerColor;
  final bool mergeDividerWithSpace;

  SpacedColumn(
      {super.key,
      this.space = 0.0,
      required this.children,
      this.mergeDividerWithSpace = false,
      this.dividerColor,
      this.mainAxisSize = MainAxisSize.max,
      this.mainAxisAlignment = MainAxisAlignment.start,
      this.crossAxisAlignment = CrossAxisAlignment.center});

  @override
  Widget build(BuildContext context) {
    List<Widget> widgets = [];
    for (var element in children) {
      widgets.add(element);
      if (children.last == element) {
      } else {
        if (dividerColor != null) {
          if (mergeDividerWithSpace) {
            widgets.add(SizedBox(height: space! / 2));
            widgets.add(Divider(color: dividerColor));
            widgets.add(SizedBox(height: space! / 2));
          } else {
            widgets.add(Divider(color: dividerColor));
          }
        } else {
          widgets.add(SizedBox(height: space!));
        }
      }
    }
    return Column(
      mainAxisAlignment: mainAxisAlignment!,
      crossAxisAlignment: crossAxisAlignment!,
      mainAxisSize: mainAxisSize!,
      children: widgets,
    );
  }
}

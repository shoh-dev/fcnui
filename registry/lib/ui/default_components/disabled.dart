//v0.0.1

import 'package:fcnui_base/fcnui_base.dart';
import 'package:flutter/material.dart';

import 'fcnui_theme.dart';

class DisabledDecoration extends DecorationImpl {
  DisabledDecoration(
    super.themeVm, {
    required DisabledChild child,
    DisabledColor? color,
    DisabledState? state,
  }) {
    super.child = child;
    super.color = color ?? DisabledColor(themeVm);
    super.state = state ?? DisabledState(themeVm);
  }

  @override
  DisabledChild get child => super.child as DisabledChild;

  @override
  DisabledColor get color => super.color as DisabledColor;

  @override
  DisabledState get state => super.state as DisabledState;
}

class DisabledState extends StateImpl {
  final bool showForbiddenCursor;

  DisabledState(super.themeVm,
      {super.isDisabled = false, this.showForbiddenCursor = true});
}

class DisabledChild extends ChildImpl {
  DisabledChild(super.themeVm, {required Widget child}) {
    this.child = child;
  }
}

class DisabledColor extends ColorImpl {
  DisabledColor(super.themeVm, {double? opacity}) {
    void setOpacity() {
      this.opacity = opacity ?? 0.5;
    }

    setOpacity();
  }

  double? opacity;
}

typedef DisabledDecorationBuilder = DisabledDecoration Function(
    ThemeVm themeVm);

class DefaultDisabled extends StatelessWidget {
  final DisabledDecorationBuilder decorationBuilder;
  const DefaultDisabled({super.key, required this.decorationBuilder});

  @override
  Widget build(BuildContext context) {
    return ThemeProvider(builder: (context, themeVm) {
      final DisabledDecoration decoration = decorationBuilder(themeVm);

      Widget view = AbsorbPointer(
        absorbing: decoration.state.isDisabled,
        child: decoration.child.child,
      );

      if (decoration.state.showForbiddenCursor && decoration.state.isDisabled) {
        view = MouseRegion(cursor: SystemMouseCursors.forbidden, child: view);
      }

      return Opacity(
          opacity: decoration.state.isDisabled ? decoration.color.opacity! : 1,
          child: view);
    });
  }
}

//v0.0.1

import 'package:flutter/material.dart';
import 'package:registry/ui/default_components/fcnui_theme.dart';

class DisabledDecoration extends DecorationImpl {
  DisabledDecoration(
    super.context, {
    required DisabledChild child,
    DisabledColor? color,
    DisabledState? state,
  }) {
    super.child = child;
    super.color = color ?? DisabledColor(context);
    super.state = state ?? DisabledState(context);
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

  DisabledState(super.context,
      {super.isDisabled = false, this.showForbiddenCursor = true});
}

class DisabledChild extends ChildImpl {
  DisabledChild(super.context, {required Widget child}) {
    this.child = child;
  }
}

class DisabledColor extends ColorImpl {
  DisabledColor(super.context, {double? opacity}) {
    void setOpacity() {
      this.opacity = opacity ?? 0.5;
    }

    setOpacity();
  }

  double? opacity;
}

typedef DisabledDecorationBuilder = DisabledDecoration Function(
    BuildContext context);

class DefaultDisabled extends StatelessWidget {
  final DisabledDecorationBuilder decorationBuilder;
  const DefaultDisabled({super.key, required this.decorationBuilder});

  @override
  Widget build(BuildContext context) {
    final DisabledDecoration decoration = decorationBuilder(context);

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
  }
}

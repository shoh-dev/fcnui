//v0.0.1

import 'package:flutter/material.dart';

class DisabledVm {
  final bool disabled;
  final double opacity;
  final Widget child;
  final bool showForbiddenCursor;

  const DisabledVm({
    required this.disabled,
    this.opacity = .5,
    required this.child,
    this.showForbiddenCursor = true,
  });
}

class DefaultDisabled extends StatelessWidget {
  final DisabledVm vm;
  const DefaultDisabled({super.key, required this.vm});

  @override
  Widget build(BuildContext context) {
    Widget view = AbsorbPointer(
      absorbing: vm.disabled,
      child: vm.child,
    );

    if (vm.showForbiddenCursor && vm.disabled) {
      view = MouseRegion(cursor: SystemMouseCursors.forbidden, child: view);
    }

    return Opacity(opacity: vm.disabled ? vm.opacity : 1, child: view);
  }
}

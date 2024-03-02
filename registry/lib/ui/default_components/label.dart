//v0.0.1

import 'package:fcnui_base/fcnui_base.dart';
import 'package:flutter/material.dart';

import 'fcnui_theme.dart';
import 'disabled.dart';

class LabelDecoration extends DecorationImpl {
  LabelDecoration(
    super.themeVm, {
    required LabelChild child,
    LabelState? state,
  }) {
    this.child = child;
    this.state = state ?? LabelState(themeVm);
  }

  @override
  LabelChild get child => super.child as LabelChild;

  @override
  LabelState get state => super.state as LabelState;
}

class LabelChild extends ChildImpl {
  LabelChild(super.themeVm, {required this.text});
  final String text;
}

class LabelState extends StateImpl {
  LabelState(super.themeVm, {super.isDisabled, this.isRequired = false});

  final bool isRequired;
}

typedef LabelDecorationBuilder = LabelDecoration Function(ThemeVm themeVm);

class Label extends StatelessWidget {
  final LabelDecorationBuilder decorationBuilder;

  const Label({super.key, required this.decorationBuilder});

  @override
  Widget build(BuildContext context) {
    return ThemeProvider(builder: (context, themeVm) {
      final decoration = decorationBuilder(themeVm);
      return DefaultDisabled(
          decorationBuilder: (themeVm) => DisabledDecoration(themeVm,
              state: DisabledState(themeVm,
                  isDisabled: decoration.state.isDisabled),
              child: DisabledChild(themeVm,
                  child: RichText(
                      text: TextSpan(children: [
                    TextSpan(
                        text: decoration.child.text,
                        style: decoration.themeVm.theme.textTheme.titleSmall!
                            .copyWith(
                          fontWeight: FontWeight.normal,
                          color: decoration.color!.onSurface.withOpacity(0.4),
                        )),
                    if (decoration.state.isRequired)
                      TextSpan(
                          text: "\t*",
                          style: decoration.themeVm.theme.textTheme.titleMedium!
                              .copyWith(color: Colors.red))
                  ])))));
    });
  }
}

//v0.0.1

import 'package:fcnui_base/fcnui_base.dart';
import 'package:flutter/material.dart';
import 'package:registry/ui/default_components/fcnui_theme.dart';
import 'disabled.dart';

class LabelDecoration extends DecorationImpl {
  LabelDecoration(
    super.context, {
    required LabelChild child,
    LabelState? state,
  }) {
    this.child = child;
    this.state = state ?? LabelState(context);
  }

  @override
  LabelChild get child => super.child as LabelChild;

  @override
  LabelState get state => super.state as LabelState;
}

class LabelChild extends ChildImpl {
  LabelChild(super.context, {required this.text});

  final String text;
}

class LabelState extends StateImpl {
  LabelState(super.context, {super.isDisabled, this.isRequired = false});

  final bool isRequired;
}

typedef LabelDecorationBuilder = LabelDecoration Function(BuildContext context);

class Label extends StatelessWidget {
  final LabelDecorationBuilder decorationBuilder;
  const Label({super.key, required this.decorationBuilder});

  @override
  Widget build(BuildContext context) {
    final decoration = decorationBuilder(context);
    return DefaultDisabled(
        decorationBuilder: (context) => DisabledDecoration(context,
            state:
                DisabledState(context, isDisabled: decoration.state.isDisabled),
            child: DisabledChild(context,
                child: RichText(
                    text: TextSpan(children: [
                  TextSpan(
                      text: decoration.child.text,
                      style: Theme.of(context).textTheme.titleSmall!.copyWith(
                            fontWeight: FontWeight.normal,
                            color: Theme.of(context)
                                .colorScheme
                                .onSurface
                                .withOpacity(0.4),
                          )),
                  if (decoration.state.isRequired)
                    TextSpan(
                        text: "\t*",
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium!
                            .copyWith(color: Colors.red))
                ])))));
  }
}

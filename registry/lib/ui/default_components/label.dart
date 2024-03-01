//v0.0.1

import 'package:fcnui_base/fcnui_base.dart';
import 'package:flutter/material.dart';
import 'disabled.dart';

class LabelModel extends Equatable {
  final String text;
  final bool isRequired;
  final bool enabled;
  const LabelModel({
    required this.text,
    this.enabled = true,
    this.isRequired = false,
  });

  @override
  List<Object?> get props => [
        text,
        isRequired,
        enabled,
      ];
}

class Label extends StatelessWidget {
  final LabelModel vm;
  const Label({super.key, required this.vm});

  @override
  Widget build(BuildContext context) {
    return DefaultDisabled(
        decorationBuilder: (context) => DisabledDecoration(context,
            state: DisabledState(context, isDisabled: !vm.enabled),
            child: DisabledChild(context,
                child: RichText(
                    text: TextSpan(children: [
                  TextSpan(
                      text: vm.text,
                      style: Theme.of(context).textTheme.titleSmall!.copyWith(
                            fontWeight: FontWeight.normal,
                            color: vm.enabled
                                ? null
                                : Theme.of(context)
                                    .colorScheme
                                    .onSurface
                                    .withOpacity(0.4),
                          )),
                  if (vm.isRequired)
                    TextSpan(
                        text: "\t*",
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium!
                            .copyWith(color: Colors.red))
                ])))));
  }
}

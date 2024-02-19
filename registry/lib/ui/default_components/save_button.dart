//v0.0.1

import 'package:flutter/material.dart';
import 'form.dart';
import 'button.dart';

class SaveButton extends StatelessWidget {
  final FormModel vm;
  final ValueChanged<Map<String, dynamic>> onSave;
  final String text;
  final bool autoValidate;
  const SaveButton(
      {super.key,
      required this.vm,
      required this.onSave,
      this.text = "Save",
      this.autoValidate = false});

  @override
  Widget build(BuildContext context) {
    if (autoValidate) {
      return ValueListenableBuilder<bool>(
          valueListenable: vm.isValidFormNotifier,
          builder: (context, value, child) {
            return DefaultButton(
              variant: PrimaryButtonVariant(
                text: text,
                minimumSize: const Size(0, 54),
                onPressed: value
                    ? () {
                        vm.formKey.currentState?.saveAndValidate();
                        onSave(vm.formKey.currentState?.value
                            as Map<String, dynamic>);
                      }
                    : null,
              ),
            );
          });
    } else {
      return DefaultButton(
        variant: PrimaryButtonVariant(
            text: text,
            minimumSize: const Size(0, 54),
            onPressed: () {
              vm.formKey.currentState?.saveAndValidate();
              onSave(vm.formKey.currentState?.value as Map<String, dynamic>);
            }),
      );
    }
  }
}

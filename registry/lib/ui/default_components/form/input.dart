//v0.0.1

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fcnui_base/fcnui_base.dart';
import 'form.dart';
import '../disabled.dart';

class InputModel extends IFormModel {
  final String? initialValue;
  final ValueChanged<String?>? onChanged;
  final int? maxLines;
  final List<FormFieldValidator<String>> validators;
  final List<TextInputFormatter> inputFormatters;
  final bool enabled;
  final bool readOnly;
  final String? hintText;
  final String? helperText;
  final ValueTransformer<String?>? valueTransformer;

  const InputModel({
    required super.name,
    this.initialValue,
    this.onChanged,
    this.valueTransformer,
    this.helperText,
    this.enabled = true,
    this.readOnly = false,
    this.maxLines,
    this.hintText,
    this.validators = const [],
    this.inputFormatters = const [],
  });

  @override
  List<Object?> get props => [
        name,
        initialValue,
        onChanged,
        valueTransformer,
        helperText,
        enabled,
        readOnly,
        maxLines,
        hintText,
        validators,
        inputFormatters,
      ];
}

class DefaultInput extends StatelessWidget {
  final InputModel vm;

  const DefaultInput({super.key, required this.vm});

  @override
  Widget build(BuildContext context) {
    return ThemeProvider(builder: (context, vm) {
      return _getChild(vm);
    });
  }

  Widget _getChild(ThemeVm themeVm) {
    final theme = themeVm.theme;
    return DefaultDisabled(
        vm: DisabledVm(
      disabled: !vm.enabled,
      child: FormBuilderTextField(
        style: theme.textTheme.bodyLarge!
            .copyWith(
              color: theme.colorScheme.onSurface,
              fontWeight: FontWeight.normal,
            )
            .sp,
        name: vm.name,
        initialValue: vm.initialValue,
        onChanged: vm.onChanged,
        maxLines: vm.maxLines,
        validator: FormBuilderValidators.compose(vm.validators),
        inputFormatters: vm.inputFormatters,
        enabled: vm.enabled,
        valueTransformer: vm.valueTransformer,
        readOnly: vm.readOnly,
        decoration: InputDecoration(
          hoverColor: Colors.transparent,
          //Border when tapped and focused
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8).r,
              borderSide: BorderSide(
                      color: theme.colorScheme.primary,
                      width: 2,
                      strokeAlign: BorderSide.strokeAlignOutside)
                  .w),
          //Idle state border
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8).r,
            borderSide: BorderSide(
                    color: theme.dividerColor,
                    strokeAlign: BorderSide.strokeAlignInside)
                .w,
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8).r,
            borderSide: const BorderSide(
                    color: Colors.red,
                    strokeAlign: BorderSide.strokeAlignInside)
                .w,
          ),
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8).r,
            borderSide: BorderSide(
                    color: theme.dividerColor.withOpacity(0.6),
                    strokeAlign: BorderSide.strokeAlignInside)
                .w,
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8).r,
            borderSide: const BorderSide(
                    color: Colors.red,
                    width: 2,
                    strokeAlign: BorderSide.strokeAlignOutside)
                .w,
          ),
          errorStyle:
              theme.textTheme.bodyMedium!.copyWith(color: Colors.red).sp,
          helperStyle: theme.textTheme.bodyMedium!
              .copyWith(color: theme.colorScheme.onSurface.withOpacity(0.6))
              .sp,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 12, vertical: 8).w,
          floatingLabelBehavior: FloatingLabelBehavior.never,
          helperText: vm.helperText,
          hintText: vm.hintText,
          filled: true,
          fillColor: theme.colorScheme.surface,
          hintStyle: theme.textTheme.bodyMedium!
              .copyWith(color: theme.colorScheme.onSurface.withOpacity(0.4))
              .sp,
        ),
      ),
    ));
  }
}

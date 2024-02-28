//v0.0.1

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fcnui_base/fcnui_base.dart';
import 'package:registry/ui/default_components/theme.dart';
import 'form.dart';
import 'disabled.dart';

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
  final TextEditingController? controller;
  final FocusNode? focusNode;

  const InputModel({
    required super.name,
    this.initialValue,
    this.focusNode,
    this.controller,
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
        controller,
        focusNode,
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
      child: Theme(
        data: theme.copyWith(
          inputDecorationTheme: InputDecorationTheme(
            hoverColor: Colors.transparent,
            //Border when tapped and focused
            focusedBorder: OutlineInputBorder(
                borderRadius:
                    BorderRadius.circular(FcnuiDefaultSizes.borderRadius).r,
                borderSide: BorderSide(
                        color: theme.colorScheme.primary,
                        width: FcnuiDefaultSizes.selectedBorderWidth,
                        strokeAlign: BorderSide.strokeAlignOutside)
                    .w),
            //Idle state border
            enabledBorder: OutlineInputBorder(
              borderRadius:
                  BorderRadius.circular(FcnuiDefaultSizes.borderRadius).r,
              borderSide: BorderSide(
                      color: theme.dividerColor,
                      width: FcnuiDefaultSizes.borderWidth,
                      strokeAlign: BorderSide.strokeAlignInside)
                  .w,
            ),
            errorBorder: OutlineInputBorder(
              borderRadius:
                  BorderRadius.circular(FcnuiDefaultSizes.borderRadius).r,
              borderSide: const BorderSide(
                      color: Colors.red,
                      width: FcnuiDefaultSizes.borderWidth,
                      strokeAlign: BorderSide.strokeAlignInside)
                  .w,
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius:
                  BorderRadius.circular(FcnuiDefaultSizes.borderRadius).r,
              borderSide: BorderSide(
                      width: FcnuiDefaultSizes.borderWidth,
                      color: theme.dividerColor.withOpacity(0.6),
                      strokeAlign: BorderSide.strokeAlignInside)
                  .w,
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius:
                  BorderRadius.circular(FcnuiDefaultSizes.borderRadius).r,
              borderSide: const BorderSide(
                      color: Colors.red,
                      width: FcnuiDefaultSizes.selectedBorderWidth,
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
            filled: true,
            fillColor: theme.colorScheme.surface,
            hintStyle: theme.textTheme.bodyMedium!
                .copyWith(color: theme.colorScheme.onSurface.withOpacity(0.4))
                .sp,
          ),
        ),
        child: FormBuilderTextField(
          focusNode: vm.focusNode,
          controller: vm.controller,
          style: theme.textTheme.bodyLarge!
              .copyWith(
                  color: theme.colorScheme.onSurface,
                  fontWeight: FontWeight.normal)
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
            helperText: vm.helperText,
            hintText: vm.hintText,
          ),
        ),
      ),
    ));
  }
}

//v0.0.1

import 'dart:developer';

import 'package:fcnui_base/fcnui_base.dart';
import 'package:flutter/material.dart';
import 'disabled.dart';
import 'dp_item.dart';
import 'form.dart';

class CheckboxModel extends IFormModel {
  final List<DpItem> items;
  final ValueChanged<List<String>?>? onChanged;
  final List<String>? initialValues;
  final List<String> disabled;
  final bool enabled;
  final String? Function(List<String>?)? validator;
  final OptionsOrientation? orientation;
  final AutovalidateMode autovalidateMode;
  final Axis? wrapDirection;
  final String? helperText;
  final String? title;
  final String? subtitle;

  const CheckboxModel({
    required super.name,
    required this.items,
    this.onChanged,
    this.wrapDirection,
    this.orientation,
    this.autovalidateMode = AutovalidateMode.disabled,
    this.initialValues,
    this.helperText,
    this.disabled = const [],
    this.enabled = true,
    this.validator,
    this.subtitle,
    this.title,
  });

  @override
  List<Object?> get props => [
        name,
        items,
        onChanged,
        orientation,
        initialValues,
        disabled,
        enabled,
        validator,
        autovalidateMode,
        wrapDirection,
        helperText,
        title,
        subtitle,
      ];
}

class DefaultCheckbox extends StatelessWidget {
  final CheckboxModel vm;
  const DefaultCheckbox({super.key, required this.vm});

  @override
  Widget build(BuildContext context) {
    return ThemeProvider(builder: (context, themeVm) {
      final theme = themeVm.theme;
      return _getChild(theme);
    });
  }

  Widget _getChild(ThemeData theme) {
    return DefaultDisabled(
        vm: DisabledVm(
      disabled: !vm.enabled,
      child: Theme(
        data: theme.copyWith(checkboxTheme: _getCheckboxTheme(theme)),
        child: FormBuilderField<List<String>>(
          name: vm.name,
          enabled: vm.enabled,
          validator: vm.validator,
          onChanged: vm.onChanged,
          initialValue: vm.initialValues,
          autovalidateMode: vm.autovalidateMode,
          builder: (field) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (vm.title != null)
                  Text(vm.title!,
                      style: theme.textTheme.titleMedium!.copyWith(
                        color: field.errorText == null ? null : Colors.red,
                      )),
                if (vm.subtitle != null)
                  Text(vm.subtitle!,
                      style: theme.textTheme.bodySmall!.copyWith(
                          color: theme.colorScheme.onSurface.withOpacity(0.6))),
                if (vm.title != null || vm.subtitle != null)
                  const SizedBox(height: 4),
                GroupCheckbox(field: field, vm: vm),
                if (vm.helperText != null)
                  Text(vm.helperText!, style: theme.textTheme.bodyMedium),
                if (field.errorText != null)
                  Text(
                    field.errorText!,
                    style:
                        theme.textTheme.bodySmall?.copyWith(color: Colors.red),
                  ),
              ],
            ).spaced(4);
          },
        ),
      ),
    ));
  }

  CheckboxThemeData _getCheckboxTheme(ThemeData theme) {
    return theme.checkboxTheme.copyWith(
        side: BorderSide(color: theme.colorScheme.onSurface, width: 1).w,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4).r),
        overlayColor: const MaterialStatePropertyAll(Colors.transparent),
        splashRadius: 0);
  }
}

class GroupCheckbox extends StatelessWidget {
  final FormFieldState<List<String>> field;
  final CheckboxModel vm;
  const GroupCheckbox({super.key, required this.field, required this.vm});

  @override
  Widget build(BuildContext context) {
    if (vm.orientation == OptionsOrientation.horizontal) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (final item in vm.items)
            CustomCheckbox(
              field: field,
              item: item,
              vm: vm,
            ),
        ],
      );
    } else if (vm.orientation == OptionsOrientation.vertical) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (final item in vm.items)
            CustomCheckbox(
              field: field,
              item: item,
              vm: vm,
            ),
        ],
      );
    }
    return Wrap(
      spacing: 10.0,
      runSpacing: 10.0,
      direction: vm.wrapDirection ?? Axis.horizontal,
      children: [
        for (final item in vm.items)
          CustomCheckbox(
            field: field,
            item: item,
            vm: vm,
          ),
      ],
    );
  }
}

class CustomCheckbox extends StatelessWidget {
  final FormFieldState<List<String>> field;
  final DpItem item;
  final CheckboxModel vm;

  const CustomCheckbox(
      {super.key, required this.field, required this.vm, required this.item});

  @override
  Widget build(BuildContext context) {
    final bool isDisabled = vm.disabled.contains(item.id);
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final bool isValid = field.errorText == null;
    return DefaultDisabled(
      vm: DisabledVm(
          disabled: isDisabled,
          child: GestureDetector(
            onTap: () {
              onCheckboxChanged(!(field.value?.contains(item.id) ?? false));
            },
            child: Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: item.subtitle != null
                  ? CrossAxisAlignment.start
                  : CrossAxisAlignment.center,
              children: [
                //Checkbox
                Checkbox(
                    value: field.value?.contains(item.id) ??
                        vm.initialValues?.contains(item.id) ??
                        false,
                    onChanged: onCheckboxChanged),

                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //Title
                    Text(
                      item.title,
                      style: TextStyle(
                        color:
                            isValid ? null : (isDisabled ? null : Colors.red),
                      ),
                    ),

                    //Subtitle, if any
                    if (item.subtitle != null)
                      Text(item.subtitle!,
                          style: textTheme.bodySmall?.copyWith(
                              color: colorScheme.onSurface.withOpacity(0.6))),
                  ],
                ).spaced(2),
              ],
            ).spaced(4),
          )),
    );
  }

  void onCheckboxChanged(bool? value) {
    try {
      if (value == true) {
        field.didChange([...(field.value ?? []), item.id]);
      } else {
        field.didChange(field.value?.where((e) => e != item.id).toList() ?? []);
      }
      vm.onChanged?.call(field.value);
    } catch (e, st) {
      log(e.toString());
      log(st.toString());
    }
  }
}

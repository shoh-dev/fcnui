//v0.0.1

import 'package:fcnui_base/fcnui_base.dart';
import 'package:flutter/material.dart';

import 'disabled.dart';
import 'form.dart';

class SwitchModel extends IFormModel {
  final SwitchForm form;
  final SwitchDecoration decoration;

  const SwitchModel({
    required super.name,
    this.form = const SwitchForm(),
    this.decoration = const SwitchDecoration(),
  });

  @override
  List<Object?> get props => [
        name,
        form,
        decoration,
      ];
}

class SwitchForm extends Equatable {
  final ValueChanged<bool?>? onChanged;
  final bool? initialValue;
  final String? Function(bool?)? validator;
  final AutovalidateMode? autovalidateMode;

  const SwitchForm({
    this.onChanged,
    this.initialValue,
    this.validator,
    this.autovalidateMode,
  });

  @override
  List<Object?> get props =>
      [onChanged, initialValue, validator, autovalidateMode];
}

class SwitchDecoration extends Equatable {
  final String? title;
  final String? subtitle;
  final bool enabled;
  final IconData? thumbActiveIcon;
  final IconData? thumbInactiveIcon;
  final Color thumbActiveColor;
  final Color thumbInactiveColor;
  final Color? trackActiveColor;
  final Color? trackInactiveColor;
  final double width;
  final double height;

  const SwitchDecoration({
    this.title,
    this.subtitle,
    this.enabled = true,
    this.thumbActiveIcon,
    this.thumbInactiveIcon,
    this.thumbActiveColor = Colors.white,
    this.thumbInactiveColor = Colors.white,
    this.trackActiveColor,
    this.trackInactiveColor,
    this.width = 45,
    this.height = 24,
  });

  @override
  List<Object?> get props => [
        title,
        subtitle,
        enabled,
        width,
        height,
        thumbActiveColor,
        thumbInactiveColor,
        trackActiveColor,
        trackInactiveColor,
        thumbActiveIcon,
        thumbInactiveIcon,
      ];
}

class DefaultSwitch extends StatelessWidget {
  final SwitchModel vm;

  const DefaultSwitch({super.key, required this.vm});

  @override
  Widget build(BuildContext context) {
    return DefaultDisabled(
        decorationBuilder: (context) => DisabledDecoration(context,
            state: DisabledState(context, isDisabled: !vm.decoration.enabled),
            child: DisabledChild(context,
                child: FormBuilderField<bool>(
                    name: vm.name,
                    validator: vm.form.validator,
                    enabled: vm.decoration.enabled,
                    initialValue: vm.form.initialValue,
                    onChanged: vm.form.onChanged,
                    autovalidateMode: vm.form.autovalidateMode,
                    builder: (field) {
                      return _Switch(field: field, vm: vm);
                    }))));
  }
}

class _Switch extends StatefulWidget {
  final FormFieldState<bool> field;
  final SwitchModel vm;

  const _Switch({required this.field, required this.vm});

  @override
  State<_Switch> createState() => _SwitchState();
}

class _SwitchState extends State<_Switch> {
  FormFieldState<bool> get field => widget.field;

  SwitchModel get vm => widget.vm;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      field.didChange(vm.form.initialValue ?? false);
    });
  }

  @override
  Widget build(BuildContext context) {
    final errorText = field.errorText;
    final isError = errorText != null;
    return ThemeProvider(builder: (context, themeVm) {
      final theme = themeVm.theme;
      return Theme(
        data: theme.copyWith(
          switchTheme: theme.switchTheme.copyWith(
            trackOutlineWidth: MaterialStateProperty.all(0),
            splashRadius: 17,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                    width: vm.decoration.width,
                    height: vm.decoration.height,
                    child: FittedBox(
                        fit: BoxFit.cover,
                        child: Switch(
                          value: field.value ?? false,
                          onChanged: field.didChange,
                          focusColor:
                              theme.colorScheme.primary.withOpacity(0.12),
                          thumbIcon:
                              MaterialStateProperty.resolveWith((states) {
                            //Handle states here. Ex: disabled, error, etc.
                            //check if active
                            if (field.value == true) {
                              return Icon(vm.decoration.thumbActiveIcon);
                            }
                            //check if inactive
                            return Icon(vm.decoration.thumbInactiveIcon);
                          }),
                          thumbColor:
                              MaterialStateProperty.resolveWith((states) {
                            //Handle states here. Ex: disabled, error, etc.
                            //check if active
                            if (field.value == true) {
                              return vm.decoration.thumbActiveColor;
                            }
                            //check if inactive
                            return vm.decoration.thumbInactiveColor;
                          }),
                          trackColor:
                              MaterialStateProperty.resolveWith((states) {
                            //Handle states here. Ex: disabled, error, etc.
                            // check if active
                            if (field.value == true) {
                              return vm.decoration.trackActiveColor;
                            }
                            //check if inactive
                            return vm.decoration.trackInactiveColor;
                          }),
                          trackOutlineColor:
                              MaterialStateProperty.resolveWith((states) {
                            return theme.colorScheme.onSurface
                                .withOpacity(0.05);
                          }),
                        ))).w,
                if (vm.decoration.title != null ||
                    vm.decoration.subtitle != null)
                  GestureDetector(
                    onTap: () => field.didChange(field.value == null
                        ? vm.form.initialValue
                        : !field.value!),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (vm.decoration.title != null)
                          Text(vm.decoration.title!,
                              style: theme.textTheme.titleSmall!.copyWith(
                                  fontWeight: FontWeight.normal,
                                  color: isError ? Colors.red : null)),
                        if (vm.decoration.subtitle != null)
                          Text(vm.decoration.subtitle!,
                              style: theme.textTheme.bodySmall!.copyWith(
                                  color: theme.colorScheme.onSurface
                                      .withOpacity(0.6))),
                      ],
                    ),
                  ),
              ],
            ).spaced(4),
            if (isError)
              Text(
                errorText,
                style: theme.textTheme.bodySmall!.copyWith(color: Colors.red),
              ),
          ],
        ).spaced(4),
      );
    });
  }
}

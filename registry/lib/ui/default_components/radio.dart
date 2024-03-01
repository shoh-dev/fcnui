//v0.0.1

import 'package:fcnui_base/fcnui_base.dart';
import 'package:flutter/material.dart';

import 'disabled.dart';
import 'form.dart';
import 'dp_item.dart';

class RadioModel extends IFormModel {
  const RadioModel(
      {required super.name,
      required this.form,
      this.decoration = const RadioDecoration()});

  final RadioForm form;
  final RadioDecoration decoration;

  @override
  List<Object?> get props => [name, form, decoration];
}

class RadioForm extends Equatable {
  final List<DpItem> items;
  final ValueChanged<String?>? onChanged;
  final FormFieldValidator<String>? validator;
  final String? initialValue;
  final List<String> disabled;
  final AutovalidateMode? autovalidateMode;

  const RadioForm(
      {required this.items,
      this.onChanged,
      this.validator,
      this.initialValue,
      this.autovalidateMode,
      this.disabled = const []});

  @override
  List<Object?> get props =>
      [items, onChanged, validator, initialValue, disabled, autovalidateMode];
}

class RadioDecoration extends Equatable {
  final String? title;
  final ControlAffinity controlAffinity;
  final OptionsOrientation direction;
  final Widget? separatorWidget;
  final Color? activeColor;
  final Color? inactiveColor;

  const RadioDecoration(
      {this.title,
      this.controlAffinity = ControlAffinity.leading,
      this.direction = OptionsOrientation.vertical,
      this.separatorWidget,
      this.activeColor,
      this.inactiveColor});

  @override
  List<Object?> get props =>
      [title, controlAffinity, direction, separatorWidget];
}

class DefaultRadio extends StatelessWidget {
  final RadioModel vm;

  const DefaultRadio({super.key, required this.vm});

  RadioThemeData _getRadioTheme(ThemeData theme) {
    return RadioThemeData(
      splashRadius: 8,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      fillColor: MaterialStateProperty.resolveWith((states) {
        //if selected
        if (states.contains(MaterialState.selected)) {
          return vm.decoration.activeColor;
        }
        if (states.contains(MaterialState.disabled)) {
          return null;
        }
        return vm.decoration.inactiveColor;
      }),
      mouseCursor: MaterialStateProperty.resolveWith((states) {
        //if disabled return not-allowed
        if (states.contains(MaterialState.disabled)) {
          return SystemMouseCursors.forbidden;
        }
        return null;
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultDisabled(
        decorationBuilder: (context) => DisabledDecoration(context,
            state:
                DisabledState(context, isDisabled: vm.form.onChanged == null),
            child: DisabledChild(context,
                child: ThemeProvider(builder: (context, themeVm) {
              final theme = themeVm.theme;
              return Theme(
                  data: theme.copyWith(
                    inputDecorationTheme: const InputDecorationTheme(
                        border: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                        focusedErrorBorder: InputBorder.none,
                        contentPadding: EdgeInsets.zero,
                        errorStyle: TextStyle(
                          color: Colors.red,
                        ),
                        errorMaxLines: 2),
                    radioTheme: _getRadioTheme(theme),
                  ),
                  child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (vm.decoration.title != null)
                          Text(vm.decoration.title!,
                              style: theme.textTheme.titleSmall),
                        FormBuilderRadioGroup<String>(
                            name: vm.name,
                            onChanged: vm.form.onChanged,
                            enabled: vm.form.onChanged != null,
                            validator: vm.form.validator,
                            initialValue: vm.form.initialValue,
                            disabled: vm.form.disabled,
                            controlAffinity: vm.decoration.controlAffinity,
                            autovalidateMode: vm.form.autovalidateMode,
                            separator: vm.decoration.separatorWidget,
                            orientation: vm.decoration.direction,
                            wrapDirection: vm.decoration.direction ==
                                    OptionsOrientation.vertical
                                ? Axis.vertical
                                : Axis.horizontal,
                            wrapRunSpacing: 12.w,
                            wrapSpacing: 12.w,
                            options: vm.form.items
                                .map((e) => FormBuilderFieldOption(
                                    value: e.id,
                                    child: DefaultDisabled(
                                        decorationBuilder: (context) =>
                                            DisabledDecoration(context,
                                                state: DisabledState(context,
                                                    isDisabled: vm.form.disabled
                                                        .contains(e.id)),
                                                child: DisabledChild(context,
                                                    child: Column(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(e.title,
                                                              style: theme
                                                                  .textTheme
                                                                  .bodyMedium!),
                                                          if (e.subtitle !=
                                                              null)
                                                            Text(e.subtitle!,
                                                                style: theme
                                                                    .textTheme
                                                                    .bodySmall!
                                                                    .copyWith(
                                                                        color: theme
                                                                            .colorScheme
                                                                            .onSurface
                                                                            .withOpacity(0.6)))
                                                        ]))))))
                                .toList())
                      ]).spaced(8));
            }))));
  }
}

//v0.0.1

import 'dart:developer';

import 'package:fcnui_base/fcnui_base.dart';
import 'package:flutter/material.dart';

import 'fcnui_theme.dart';
import 'disabled.dart';
import 'dp_item.dart';

class CheckboxDecoration extends DecorationImpl {
  CheckboxDecoration(
    super.themeVm, {
    required CheckboxValue value,
    CheckboxAction? action,
    CheckboxState? state,
    CheckboxChild? child,
    CheckboxColor? color,
    CheckboxBorder? border,
  }) {
    this.value = value;
    this.action = action ?? CheckboxAction(themeVm);
    this.state = state ?? CheckboxState(themeVm);
    this.child = child ?? CheckboxChild(themeVm);
    this.color = color ?? CheckboxColor(themeVm);
    this.border = border ?? CheckboxBorder(themeVm);
  }

  @override
  CheckboxValue get value => super.value as CheckboxValue;

  @override
  CheckboxAction get action => super.action as CheckboxAction;

  @override
  CheckboxState get state => super.state as CheckboxState;

  @override
  CheckboxChild get child => super.child as CheckboxChild;

  @override
  CheckboxColor get color => super.color as CheckboxColor;

  @override
  CheckboxBorder get border => super.border as CheckboxBorder;
}

class CheckboxValue extends ValueImpl {
  CheckboxValue(
    super.themeVm, {
    required this.items,
    required this.name,
    this.initialValues,
    this.disabledItems = const [],
    this.validator,
    this.autovalidateMode = AutovalidateMode.onUserInteraction,
  });

  final String name;
  final List<DpItem> items;
  final List<String>? initialValues;
  final List<String> disabledItems;
  final String? Function(List<String>?)? validator;
  final AutovalidateMode autovalidateMode;
}

class CheckboxAction extends ActionImpl {
  CheckboxAction(super.themeVm, {this.onChanged});

  final ValueChanged<List<String>?>? onChanged;
}

class CheckboxState extends StateImpl {
  CheckboxState(super.themeVm, {super.isDisabled = false});
}

class CheckboxChild extends ChildImpl {
  CheckboxChild(
    super.themeVm, {
    this.title,
    this.subtitle,
    this.helperText,
    this.orientation,
    this.wrapDirection,
    TextStyle? titleStyle,
    TextStyle? subtitleStyle,
    TextStyle? helperTextStyle,
    TextStyle? errorTextStyle,
    TextStyle? itemTitleStyle,
    TextStyle? itemSubtitleStyle,
  }) {
    void setTextStyles() {
      this.titleStyle = titleStyle ?? theme.textTheme.titleMedium;
      this.subtitleStyle = subtitleStyle ??
          theme.textTheme.bodySmall!
              .copyWith(color: theme.colorScheme.onSurface.withOpacity(0.6));
      this.helperTextStyle = helperTextStyle ?? theme.textTheme.bodyMedium;
      this.errorTextStyle = errorTextStyle ??
          theme.textTheme.bodyMedium!.copyWith(color: Colors.red);
      this.itemTitleStyle = itemTitleStyle ?? theme.textTheme.bodyMedium;
      this.itemSubtitleStyle = itemSubtitleStyle ??
          theme.textTheme.bodySmall!
              .copyWith(color: theme.colorScheme.onSurface.withOpacity(0.6));
    }

    setTextStyles();
  }

  final String? title;
  final String? subtitle;
  final String? helperText;

  final OptionsOrientation? orientation;
  final Axis? wrapDirection;

  TextStyle? titleStyle;
  TextStyle? subtitleStyle;
  TextStyle? helperTextStyle;
  TextStyle? errorTextStyle;

  TextStyle? itemTitleStyle;
  TextStyle? itemSubtitleStyle;
}

class CheckboxColor extends ColorImpl {
  CheckboxColor(super.themeVm,
      {this.activeColor,
      this.checkColor,
      Color? overlayColor,
      Color? errorColor}) {
    void setColor() {
      this.overlayColor = overlayColor ?? Colors.transparent;
      this.errorColor = errorColor ?? Colors.red;
    }

    setColor();
  }

  final Color? activeColor;
  final Color? checkColor;
  Color? overlayColor;
  Color? errorColor;
}

class CheckboxBorder extends BorderImpl {
  CheckboxBorder(super.themeVm, {super.borderSide, super.borderRadius}) {
    void setBorder() {
      super.borderSide = super.borderSide ??
          BorderSide(color: theme.colorScheme.onSurface, width: 1).w;
      super.borderRadius = super.borderRadius ?? BorderRadius.circular(4).r;
    }

    setBorder();
  }
}

typedef CheckboxDecorationBuilder = CheckboxDecoration Function(
    ThemeVm themeVm);

class DefaultCheckbox extends StatelessWidget {
  final CheckboxDecorationBuilder decorationBuilder;

  const DefaultCheckbox({super.key, required this.decorationBuilder});

  @override
  Widget build(BuildContext context) {
    return ThemeProvider(builder: (context, themeVm) {
      final decoration = decorationBuilder(themeVm);
      return _getChild(decoration);
    });
  }

  Widget _getChild(CheckboxDecoration decoration) {
    return DefaultDisabled(
        decorationBuilder: (themeVm) => DisabledDecoration(themeVm,
            state:
                DisabledState(themeVm, isDisabled: decoration.state.isDisabled),
            child: DisabledChild(themeVm,
                child: Theme(
                    data: decoration.theme
                        .copyWith(checkboxTheme: _getCheckboxTheme(decoration)),
                    child: FormBuilderField<List<String>>(
                        name: decoration.value.name,
                        enabled: !decoration.state.isDisabled,
                        validator: decoration.value.validator,
                        onChanged: decoration.action.onChanged,
                        initialValue: decoration.value.initialValues,
                        autovalidateMode: decoration.value.autovalidateMode,
                        builder: (field) {
                          return Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (decoration.child.title != null)
                                  Text(decoration.child.title!,
                                      style:
                                          decoration.child.titleStyle!.copyWith(
                                        color: field.errorText == null
                                            ? null
                                            : decoration.color.errorColor,
                                      )),
                                if (decoration.child.subtitle != null)
                                  Text(decoration.child.subtitle!,
                                      style: decoration.child.subtitleStyle!),
                                if (decoration.child.title != null ||
                                    decoration.child.subtitle != null)
                                  const SizedBox(height: 4),
                                GroupCheckbox(
                                    field: field, decoration: decoration),
                                if (decoration.child.helperText != null)
                                  Text(decoration.child.helperText!,
                                      style: decoration.child.helperTextStyle!),
                                if (field.errorText != null)
                                  Text(field.errorText!,
                                      style: decoration.child.errorTextStyle!)
                              ]).spaced(4);
                        })))));
  }

  CheckboxThemeData _getCheckboxTheme(CheckboxDecoration decoration) {
    return decoration.theme.checkboxTheme.copyWith(
        side: decoration.border.borderSide,
        shape: RoundedRectangleBorder(
            borderRadius: decoration.border.borderRadius!),
        overlayColor: MaterialStatePropertyAll(decoration.color.overlayColor),
        splashRadius: 0);
  }
}

class GroupCheckbox extends StatelessWidget {
  final FormFieldState<List<String>> field;
  final CheckboxDecoration decoration;

  const GroupCheckbox(
      {super.key, required this.field, required this.decoration});

  @override
  Widget build(BuildContext context) {
    if (decoration.child.orientation == OptionsOrientation.horizontal) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (final item in decoration.value.items)
            CustomCheckbox(
              field: field,
              item: item,
              decoration: decoration,
            ),
        ],
      );
    } else if (decoration.child.orientation == OptionsOrientation.vertical) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (final item in decoration.value.items)
            CustomCheckbox(
              field: field,
              item: item,
              decoration: decoration,
            ),
        ],
      );
    }
    return Wrap(
      spacing: 10.0,
      runSpacing: 10.0,
      direction: decoration.child.wrapDirection ?? Axis.horizontal,
      children: [
        for (final item in decoration.value.items)
          CustomCheckbox(
            field: field,
            item: item,
            decoration: decoration,
          ),
      ],
    );
  }
}

class CustomCheckbox extends StatelessWidget {
  final FormFieldState<List<String>> field;
  final DpItem item;
  final CheckboxDecoration decoration;

  const CustomCheckbox(
      {super.key,
      required this.field,
      required this.decoration,
      required this.item});

  @override
  Widget build(BuildContext context) {
    final bool isDisabled = decoration.value.disabledItems.contains(item.id);
    final bool isValid = field.errorText == null;
    return DefaultDisabled(
        decorationBuilder: (context) => DisabledDecoration(context,
            state: DisabledState(context, isDisabled: isDisabled),
            child: DisabledChild(context,
                child: GestureDetector(
                    onTap: () {
                      onCheckboxChanged(
                          !(field.value?.contains(item.id) ?? false));
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
                                  decoration.value.initialValues
                                      ?.contains(item.id) ??
                                  false,
                              onChanged: onCheckboxChanged),

                          Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                //Title
                                Text(
                                  item.title,
                                  style:
                                      decoration.child.itemTitleStyle!.copyWith(
                                    color: isValid
                                        ? null
                                        : (isDisabled
                                            ? null
                                            : decoration.color.errorColor),
                                  ),
                                ),

                                //Subtitle, if any
                                if (item.subtitle != null)
                                  Text(item.subtitle!,
                                      style: decoration.child.itemSubtitleStyle)
                              ]).spaced(2)
                        ]).spaced(4)))));
  }

  void onCheckboxChanged(bool? value) {
    try {
      if (value == true) {
        field.didChange([...(field.value ?? []), item.id]);
      } else {
        field.didChange(field.value?.where((e) => e != item.id).toList() ?? []);
      }
      decoration.action.onChanged?.call(field.value);
    } catch (e, st) {
      log(e.toString());
      log(st.toString());
    }
  }
}

//v0.0.1

import 'package:fcnui_base/fcnui_base.dart';
import 'package:flutter/material.dart';
import 'package:registry/ui/default_components/fcnui_theme.dart';

import 'disabled.dart';
import 'form.dart';
import 'dp_item.dart';

class RadioDecoration extends DecorationImpl {
  RadioDecoration(
    super.themeVm, {
    RadioChild? child,
    RadioColor? color,
    required RadioValue value,
    RadioAction? action,
  }) {
    super.value = value;
    super.child = child ?? RadioChild(themeVm);
    super.color = color ?? RadioColor(themeVm);
    super.action = action ?? RadioAction(themeVm);
  }

  @override
  RadioChild get child => super.child as RadioChild;

  @override
  RadioColor get color => super.color as RadioColor;

  @override
  RadioValue get value => super.value as RadioValue;

  @override
  RadioAction get action => super.action as RadioAction;
}

class RadioValue extends ValueImpl {
  RadioValue(
    super.themeVm, {
    required this.name,
    required this.items,
    this.validator,
    this.initialValue,
    this.disabledItems = const [],
    this.autovalidateMode = AutovalidateMode.onUserInteraction,
  });

  final String name;
  final List<DpItem> items;
  final FormFieldValidator<String>? validator;
  final String? initialValue;
  final List<String> disabledItems;
  final AutovalidateMode autovalidateMode;
}

class RadioChild extends ChildImpl {
  RadioChild(
    super.themeVm, {
    this.title,
    this.controlAffinity = ControlAffinity.leading,
    this.direction = OptionsOrientation.vertical,
    this.separatorWidget,
    TextStyle? titleStyle,
    TextStyle? itemTitleStyle,
    TextStyle? itemSubtitleStyle,
  }) {
    void setTextStyle() {
      this.titleStyle = titleStyle ?? theme.textTheme.titleSmall;
      this.itemTitleStyle = itemTitleStyle ?? theme.textTheme.bodyMedium;
      this.itemSubtitleStyle = itemSubtitleStyle ??
          theme.textTheme.bodySmall!
              .copyWith(color: theme.colorScheme.onSurface.withOpacity(0.6));
    }

    setTextStyle();
  }

  final String? title;
  TextStyle? titleStyle;
  final ControlAffinity controlAffinity;
  final OptionsOrientation direction;
  final Widget? separatorWidget;

  TextStyle? itemTitleStyle;
  TextStyle? itemSubtitleStyle;
}

class RadioColor extends ColorImpl {
  RadioColor(
    super.themeVm, {
    Color? activeColor,
    Color? inactiveColor,
    Color? disabledColor,
    Color? errorColor,
  }) {
    void setColor() {
      this.activeColor = activeColor ?? primary;
      this.inactiveColor = inactiveColor ?? onSurface.withOpacity(0.6);
      this.errorColor = errorColor ?? Colors.red;
    }

    setColor();
  }

  Color? activeColor;
  Color? inactiveColor;
  Color? disabledColor;
  Color? errorColor;
}

class RadioAction extends ActionImpl<String> {
  RadioAction(super.themeVm, {this.onChanged});

  final ValueChanged<String?>? onChanged;
}

typedef RadioDecorationBuilder = RadioDecoration Function(ThemeVm themeVm);

class DefaultRadio extends StatelessWidget {
  final RadioDecorationBuilder decorationBuilder;

  const DefaultRadio({super.key, required this.decorationBuilder});

  RadioThemeData _getRadioTheme(RadioDecoration decoration) {
    return RadioThemeData(
      splashRadius: 8,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      fillColor: MaterialStateProperty.resolveWith((states) {
        //if selected
        if (states.contains(MaterialState.selected)) {
          return decoration.color.activeColor;
        }
        if (states.contains(MaterialState.disabled)) {
          return decoration.color.disabledColor;
        }
        return decoration.color.inactiveColor;
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
    return ThemeProvider(builder: (context, themeVm) {
      final decoration = decorationBuilder(themeVm);
      return DefaultDisabled(
          decorationBuilder: (context) => DisabledDecoration(context,
              state: DisabledState(context,
                  isDisabled: decoration.action.onChanged == null),
              child: DisabledChild(context,
                  child: ThemeProvider(builder: (context, themeVm) {
                final theme = themeVm.theme;
                return Theme(
                    data: theme.copyWith(
                      inputDecorationTheme: InputDecorationTheme(
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                          focusedErrorBorder: InputBorder.none,
                          contentPadding: EdgeInsets.zero,
                          errorStyle:
                              TextStyle(color: decoration.color.errorColor),
                          errorMaxLines: 2),
                      radioTheme: _getRadioTheme(decoration),
                    ),
                    child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (decoration.child.title != null)
                            Text(decoration.child.title!,
                                style: decoration.child.titleStyle),
                          FormBuilderRadioGroup<String>(
                              name: decoration.value.name,
                              onChanged: decoration.action.onChanged,
                              enabled: decoration.action.onChanged != null,
                              validator: decoration.value.validator,
                              initialValue: decoration.value.initialValue,
                              disabled: decoration.value.disabledItems,
                              controlAffinity: decoration.child.controlAffinity,
                              autovalidateMode:
                                  decoration.value.autovalidateMode,
                              separator: decoration.child.separatorWidget,
                              orientation: decoration.child.direction,
                              wrapDirection: decoration.child.direction ==
                                      OptionsOrientation.vertical
                                  ? Axis.vertical
                                  : Axis.horizontal,
                              wrapRunSpacing: 12.w,
                              wrapSpacing: 12.w,
                              options: decoration.value.items
                                  .map((e) => FormBuilderFieldOption(
                                      value: e.id,
                                      child: DefaultDisabled(
                                          decorationBuilder: (context) =>
                                              DisabledDecoration(context,
                                                  state: DisabledState(context,
                                                      isDisabled: decoration
                                                          .value.disabledItems
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
                                                                style: decoration
                                                                    .child
                                                                    .itemTitleStyle),
                                                            if (e.subtitle !=
                                                                null)
                                                              Text(e.subtitle!,
                                                                  style: decoration
                                                                      .child
                                                                      .itemSubtitleStyle)
                                                          ]))))))
                                  .toList())
                        ]).spaced(8));
              }))));
    });
  }
}

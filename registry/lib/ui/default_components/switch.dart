//v0.0.1

import 'package:fcnui_base/fcnui_base.dart';
import 'package:flutter/material.dart';
import 'package:registry/ui/default_components/fcnui_theme.dart';

import 'disabled.dart';
import 'form.dart';

class SwitchDecoration extends DecorationImpl {
  SwitchDecoration(
    super.themeVm, {
    required SwitchValue value,
    SwitchAction? action,
    SwitchState? state,
    SwitchChild? child,
    SwitchColor? color,
    SwitchSize? size,
  }) {
    this.value = value;
    this.action = action ?? SwitchAction(themeVm);
    this.state = state ?? SwitchState(themeVm);
    this.child = child ?? SwitchChild(themeVm);
    this.color = color ?? SwitchColor(themeVm);
    this.size = size ?? SwitchSize(themeVm);
  }

  @override
  SwitchValue get value => super.value as SwitchValue;

  @override
  SwitchAction get action => super.action as SwitchAction;

  @override
  SwitchState get state => super.state as SwitchState;

  @override
  SwitchChild get child => super.child as SwitchChild;

  @override
  SwitchColor get color => super.color as SwitchColor;

  @override
  SwitchSize get size => super.size as SwitchSize;
}

class SwitchAction extends ActionImpl {
  SwitchAction(super.themeVm, {this.onChanged});

  final ValueChanged<bool?>? onChanged;
}

class SwitchState extends StateImpl {
  SwitchState(super.themeVm, {super.isDisabled = false});
}

class SwitchValue extends ValueImpl {
  SwitchValue(
    super.themeVm, {
    this.autovalidateMode = AutovalidateMode.onUserInteraction,
    this.validator,
    this.initialValue,
    required this.name,
  });

  final String name;
  final bool? initialValue;
  final String? Function(bool?)? validator;
  final AutovalidateMode? autovalidateMode;
}

class SwitchChild extends ChildImpl {
  SwitchChild(
    super.themeVm, {
    this.title,
    this.subtitle,
    this.thumbActiveIcon,
    this.thumbInactiveIcon,
    TextStyle? titleStyle,
    TextStyle? subtitleStyle,
    TextStyle? errorStyle,
  }) {
    void setTextStyle() {
      this.titleStyle = titleStyle ?? theme.textTheme.titleSmall;
      this.subtitleStyle = subtitleStyle ??
          theme.textTheme.bodySmall!
              .copyWith(color: theme.colorScheme.onSurface.withOpacity(0.6));
      this.errorStyle =
          errorStyle ?? theme.textTheme.bodySmall!.copyWith(color: Colors.red);
    }

    setTextStyle();
  }

  String? title;
  String? subtitle;

  IconData? thumbActiveIcon;
  IconData? thumbInactiveIcon;

  TextStyle? titleStyle;
  TextStyle? subtitleStyle;
  TextStyle? errorStyle;
}

class SwitchColor extends ColorImpl {
  SwitchColor(
    super.themeVm, {
    Color? thumbActiveColor,
    Color? thumbInactiveColor,
    Color? trackActiveColor,
    Color? trackInactiveColor,
    Color? focusColor,
    Color? trackOutlineColor,
    Color? errorColor,
  }) {
    void setColor() {
      this.thumbActiveColor = thumbActiveColor ?? Colors.white;
      this.thumbInactiveColor = thumbInactiveColor ?? Colors.white;
      this.trackActiveColor =
          trackActiveColor ?? theme.colorScheme.primary.withOpacity(0.5);
      this.trackInactiveColor =
          trackInactiveColor ?? theme.colorScheme.onSurface.withOpacity(0.5);
      this.focusColor =
          focusColor ?? theme.colorScheme.primary.withOpacity(0.12);
      this.trackOutlineColor =
          trackOutlineColor ?? theme.colorScheme.onSurface.withOpacity(0.05);
      this.errorColor = errorColor ?? Colors.red;
    }

    setColor();
  }

  Color? thumbActiveColor;
  Color? thumbInactiveColor;
  Color? trackActiveColor;
  Color? trackInactiveColor;
  Color? focusColor;
  Color? trackOutlineColor;
  Color? errorColor;
}

class SwitchSize extends SizeImpl {
  SwitchSize(super.themeVm,
      {double? width, double? height, double? splashRadius}) {
    void setSize() {
      this.width = (width ?? 45).w;
      this.height = (height ?? 24).h;
      this.splashRadius = (splashRadius ?? 17).r;
    }

    setSize();
  }

  double? width;
  double? height;
  double? splashRadius;
}

typedef SwitchDecorationBuilder = SwitchDecoration Function(ThemeVm themeVm);

class DefaultSwitch extends StatelessWidget {
  final SwitchDecorationBuilder decorationBuilder;

  const DefaultSwitch({super.key, required this.decorationBuilder});

  @override
  Widget build(BuildContext context) {
    return DefaultDisabled(decorationBuilder: (themeVm) {
      final decoration = decorationBuilder(themeVm);
      return DisabledDecoration(themeVm,
          state:
              DisabledState(themeVm, isDisabled: decoration.state.isDisabled),
          child: DisabledChild(themeVm,
              child: FormBuilderField<bool>(
                  name: decoration.value.name,
                  validator: decoration.value.validator,
                  enabled: !decoration.state.isDisabled,
                  initialValue: decoration.value.initialValue,
                  onChanged: decoration.action.onChanged,
                  autovalidateMode: decoration.value.autovalidateMode,
                  builder: (field) {
                    return _Switch(field: field, decoration: decoration);
                  })));
    });
  }
}

class _Switch extends StatefulWidget {
  final FormFieldState<bool> field;
  final SwitchDecoration decoration;

  const _Switch({required this.field, required this.decoration});

  @override
  State<_Switch> createState() => _SwitchState();
}

class _SwitchState extends State<_Switch> {
  FormFieldState<bool> get field => widget.field;

  SwitchDecoration get decoration => widget.decoration;

  ThemeData get theme => decoration.theme;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      field.didChange(decoration.value.initialValue ?? false);
    });
  }

  @override
  Widget build(BuildContext context) {
    final errorText = field.errorText;
    final isError = errorText != null;

    return Theme(
        data: theme.copyWith(
          switchTheme: theme.switchTheme.copyWith(
              trackOutlineWidth: MaterialStateProperty.all(0),
              splashRadius: decoration.size.splashRadius),
        ),
        child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                      width: decoration.size.width,
                      height: decoration.size.height,
                      child: FittedBox(
                          fit: BoxFit.cover,
                          child: Switch(
                            value: field.value ?? false,
                            onChanged: field.didChange,
                            focusColor: decoration.color.focusColor,
                            thumbIcon:
                                MaterialStateProperty.resolveWith((states) {
                              //Handle states here. Ex: disabled, error, etc.
                              //check if active
                              if (field.value == true) {
                                return Icon(decoration.child.thumbActiveIcon);
                              }
                              //check if inactive
                              return Icon(decoration.child.thumbInactiveIcon);
                            }),
                            thumbColor:
                                MaterialStateProperty.resolveWith((states) {
                              //Handle states here. Ex: disabled, error, etc.
                              //check if active
                              if (field.value == true) {
                                return decoration.color.thumbActiveColor;
                              }
                              //check if inactive
                              return decoration.color.thumbInactiveColor;
                            }),
                            trackColor:
                                MaterialStateProperty.resolveWith((states) {
                              //Handle states here. Ex: disabled, error, etc.
                              // check if active
                              if (field.value == true) {
                                return decoration.color.trackActiveColor;
                              }
                              //check if inactive
                              return decoration.color.trackInactiveColor;
                            }),
                            trackOutlineColor:
                                MaterialStateProperty.resolveWith((states) {
                              return decoration.color.trackOutlineColor;
                            }),
                          ))).w,
                  if (decoration.child.title != null ||
                      decoration.child.subtitle != null)
                    GestureDetector(
                      onTap: () => field.didChange(field.value == null
                          ? decoration.value.initialValue
                          : !field.value!),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (decoration.child.title != null)
                            Text(decoration.child.title!,
                                style: decoration.child.titleStyle!.copyWith(
                                    fontWeight: FontWeight.normal,
                                    color: isError
                                        ? decoration.color.errorColor
                                        : null)),
                          if (decoration.child.subtitle != null)
                            Text(decoration.child.subtitle!,
                                style: decoration.child.subtitleStyle)
                        ],
                      ),
                    ),
                ],
              ).spaced(4),
              if (isError) Text(errorText, style: decoration.child.errorStyle)
            ]).spaced(4));
  }
}

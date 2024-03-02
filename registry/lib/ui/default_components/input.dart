//v0.0.1

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fcnui_base/fcnui_base.dart';
import 'package:registry/ui/default_components/fcnui_theme.dart';
import 'form.dart';
import 'disabled.dart';

class InputDecor extends DecorationImpl {
  InputDecor(
    super.themeVm, {
    required InputChild child,
    InputState? state,
    InputAction? action,
    InputValue? value,
    InputColor? color,
    InputBorder? border,
    InputSize? size,
  }) {
    super.child = child;
    super.state = state ?? InputState(themeVm);
    super.action = action ?? InputAction(themeVm);
    super.value = value ?? InputValue(themeVm);
    super.color = color ?? InputColor(themeVm);
    super.border = border ?? InputBorder(themeVm);
    super.size = size ?? InputSize(themeVm);
  }

  @override
  InputChild get child => super.child as InputChild;

  @override
  InputState get state => super.state as InputState;

  @override
  InputAction get action => super.action as InputAction;

  @override
  InputValue get value => super.value as InputValue;

  @override
  InputColor get color => super.color as InputColor;

  @override
  InputBorder get border => super.border as InputBorder;

  @override
  InputSize get size => super.size as InputSize;
}

class InputChild extends ChildImpl {
  InputChild(
    super.themeVm, {
    this.helperText,
    this.hintText,
    this.maxLines,
    required this.name,
    this.inputFormatters = const [],
    TextStyle? errorStyle,
    TextStyle? helperStyle,
    TextStyle? hintStyle,
    TextStyle? valueStyle,
  }) {
    void setErrorStyle() {
      this.errorStyle = errorStyle ??
          theme.textTheme.bodyMedium!.copyWith(color: Colors.red).sp;
    }

    void setHelperStyle() {
      this.helperStyle = helperStyle ??
          theme.textTheme.bodyMedium!
              .copyWith(color: theme.colorScheme.onSurface.withOpacity(0.6))
              .sp;
    }

    void setHintStyle() {
      this.hintStyle = hintStyle ??
          theme.textTheme.bodyMedium!
              .copyWith(color: theme.colorScheme.onSurface.withOpacity(0.4))
              .sp;
    }

    void setValueStyle() {
      this.valueStyle = valueStyle ??
          theme.textTheme.bodyLarge!
              .copyWith(
                  color: theme.colorScheme.onSurface,
                  fontWeight: FontWeight.normal)
              .sp;
    }

    setErrorStyle();
    setHelperStyle();
    setHintStyle();
    setValueStyle();
  }

  final String name;
  final String? hintText;
  final String? helperText;
  final int? maxLines;
  final List<TextInputFormatter> inputFormatters;

  TextStyle? errorStyle;
  TextStyle? helperStyle;
  TextStyle? hintStyle;
  TextStyle? valueStyle;
}

class InputState extends StateImpl {
  InputState(
    super.themeVm, {
    super.isDisabled,
    this.readOnly = false,
    this.focusNode,
    this.isFilled = true,
  });

  final bool readOnly;
  final FocusNode? focusNode;
  final bool isFilled;
}

class InputAction extends ActionImpl {
  InputAction(super.themeVm, {this.onChanged});

  final ValueChanged<String?>? onChanged;
}

class InputValue extends ValueImpl {
  InputValue(super.themeVm,
      {this.initialValue, this.validators = const [], this.controller});

  final String? initialValue;
  final List<FormFieldValidator<String>> validators;
  final TextEditingController? controller;
}

class InputColor extends ColorImpl {
  InputColor(
    super.themeVm, {
    Color? hoverColor,
    Color? fillColor,
  }) {
    void setHoverColor() {
      this.hoverColor = hoverColor ?? Colors.transparent;
    }

    void setFillColor() {
      this.fillColor = fillColor ?? theme.colorScheme.surface;
    }

    setHoverColor();
    setFillColor();
  }

  Color? hoverColor;
  Color? fillColor;
}

class InputBorder extends BorderImpl {
  InputBorder(
    super.themeVm, {
    BorderSide? focusedBorderSide,
    BorderSide? enabledBorderSide,
    BorderSide? errorBorderSide,
    BorderSide? disabledBorderSide,
    BorderRadius? borderRadius,
  }) {
    void setBorderRadius() {
      super.borderRadius = borderRadius ??
          BorderRadius.circular(FcnuiDefaultSizes.borderRadius).r;
    }

    void setFocusBorderSide() {
      this.focusedBorderSide = focusedBorderSide ??
          BorderSide(
                  color: theme.colorScheme.primary,
                  width: FcnuiDefaultSizes.selectedBorderWidth,
                  strokeAlign: BorderSide.strokeAlignOutside)
              .w;
    }

    void setEnabledBorderSide() {
      this.enabledBorderSide = enabledBorderSide ??
          BorderSide(
                  color: theme.dividerColor,
                  width: FcnuiDefaultSizes.borderWidth,
                  strokeAlign: BorderSide.strokeAlignInside)
              .w;
    }

    void setErrorBorderSide() {
      this.errorBorderSide = errorBorderSide ??
          const BorderSide(
                  color: Colors.red,
                  width: FcnuiDefaultSizes.borderWidth,
                  strokeAlign: BorderSide.strokeAlignInside)
              .w;
    }

    void setDisabledBorderSide() {
      this.disabledBorderSide = disabledBorderSide ??
          BorderSide(
                  width: FcnuiDefaultSizes.borderWidth,
                  color: theme.dividerColor.withOpacity(0.6),
                  strokeAlign: BorderSide.strokeAlignInside)
              .w;
    }

    setBorderRadius();
    setFocusBorderSide();
    setEnabledBorderSide();
    setErrorBorderSide();
    setDisabledBorderSide();
  }

  BorderSide? focusedBorderSide;
  BorderSide? enabledBorderSide;
  BorderSide? errorBorderSide;
  BorderSide? disabledBorderSide;
}

class InputSize extends SizeImpl {
  InputSize(
    super.themeVm, {
    EdgeInsetsGeometry? padding,
  }) {
    void setPadding() {
      this.padding =
          padding ?? const EdgeInsets.symmetric(horizontal: 12, vertical: 8).w;
    }

    setPadding();
  }

  EdgeInsetsGeometry? padding;
}

typedef InputDecorBuilder = InputDecor Function(ThemeVm themeVm);

class DefaultInput extends StatelessWidget {
  final InputDecorBuilder decorationBuilder;

  const DefaultInput({super.key, required this.decorationBuilder});

  @override
  Widget build(BuildContext context) {
    return ThemeProvider(builder: (context, themeVm) {
      final decoration = decorationBuilder(themeVm);
      return _getChild(decoration);
    });
  }

  Widget _getChild(InputDecor decoration) {
    final theme = decoration.theme;
    return DefaultDisabled(
        decorationBuilder: (context) => DisabledDecoration(context,
            state:
                DisabledState(context, isDisabled: decoration.state.isDisabled),
            child: DisabledChild(context,
                child: Theme(
                    data: theme.copyWith(
                        inputDecorationTheme: InputDecorationTheme(
                            hoverColor: decoration.color.hoverColor,
                            //Border when tapped and focused
                            focusedBorder: OutlineInputBorder(
                                borderRadius: decoration.border.borderRadius!,
                                borderSide:
                                    decoration.border.focusedBorderSide!),
                            //Idle state border
                            enabledBorder: OutlineInputBorder(
                                borderRadius: decoration.border.borderRadius!,
                                borderSide:
                                    decoration.border.enabledBorderSide!),
                            errorBorder: OutlineInputBorder(
                                borderRadius: decoration.border.borderRadius!,
                                borderSide: decoration.border.errorBorderSide!),
                            disabledBorder: OutlineInputBorder(
                                borderRadius: decoration.border.borderRadius!,
                                borderSide:
                                    decoration.border.disabledBorderSide!),
                            focusedErrorBorder: OutlineInputBorder(
                                borderRadius: decoration.border.borderRadius!,
                                borderSide: decoration.border.errorBorderSide!),
                            errorStyle: decoration.child.errorStyle!,
                            helperStyle: decoration.child.helperStyle!,
                            contentPadding: decoration.size.padding,
                            floatingLabelBehavior: FloatingLabelBehavior.never,
                            filled: decoration.state.isFilled,
                            fillColor: decoration.color.fillColor,
                            hintStyle: decoration.child.hintStyle!)),
                    child: FormBuilderTextField(
                        focusNode: decoration.state.focusNode,
                        controller: decoration.value.controller,
                        style: decoration.child.valueStyle!,
                        name: decoration.child.name,
                        initialValue: decoration.value.initialValue,
                        onChanged: decoration.action.onChanged,
                        maxLines: decoration.child.maxLines,
                        validator: FormBuilderValidators.compose(
                            decoration.value.validators),
                        inputFormatters: decoration.child.inputFormatters,
                        enabled: !decoration.state.isDisabled,
                        readOnly: decoration.state.readOnly,
                        decoration: InputDecoration(
                            helperText: decoration.child.helperText,
                            hintText: decoration.child.hintText))))));
  }
}

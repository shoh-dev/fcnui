//v0.0.1

import 'package:flutter/material.dart';
import 'package:fcnui_base/fcnui_base.dart';
import 'package:registry/ui/default_components/fcnui_theme.dart';

class ButtonDecoration extends DecorationImpl {
  final ButtonType type;

  ButtonDecoration(
    super.context, {
    required this.type,
    ButtonColor? colorTheme,
    ButtonChild? child,
    ButtonAction? action,
    ButtonState? state,
    ButtonSize? size,
    ButtonBorder? border,
  }) : super(colorTheme: colorTheme) {
    super.colorTheme = colorTheme ??= ButtonColor(context, type: type);
    super.childTheme = child ?? ButtonChild(context);
    super.actionThemeState = action ?? ButtonAction(context);
    super.stateTheme = state ?? ButtonState(context);
    super.sizeTheme = size ?? ButtonSize(context, type);
    super.borderTheme = border ?? ButtonBorder(context, type);

    assert(
        sizeTheme.iconSize >= 0, "iconSize must be greater than or equal to 0");
    assert(
        childTheme.text != null ||
            childTheme.child != null ||
            childTheme.icon != null,
        "text, child, or icon must be provided");
  }

  @override
  ButtonColor get colorTheme => super.colorTheme as ButtonColor;

  @override
  ButtonChild get childTheme => super.childTheme as ButtonChild;

  @override
  ButtonAction get actionThemeState => super.actionThemeState as ButtonAction;

  @override
  ButtonState get stateTheme => super.stateTheme as ButtonState;

  @override
  ButtonSize get sizeTheme => super.sizeTheme as ButtonSize;

  @override
  ButtonBorder get borderTheme => super.borderTheme as ButtonBorder;
}

class ButtonColor extends ColorImpl {
  final ButtonType type;

  ButtonColor(
    super.theme, {
    required this.type,
    Color? background,
    Color? foreground,
    Color? disabledBackground,
    Color? disabledForeground,
    Color? hoverColor,
    Color? highlightColor,
    Color? focusColor,
  }) {
    void setBackground() {
      if (background == null) this.background = background;
      switch (type) {
        case ButtonType.primary:
          this.background = primary;
        case ButtonType.secondary:
          this.background = secondary;
        case ButtonType.tertiary:
          this.background = tertiary;
        case ButtonType.error:
          this.background = theme.colorScheme.error;
        default:
          return;
      }
    }

    void setForeground() {
      if (foreground != null) this.foreground = foreground;
      switch (type) {
        case ButtonType.primary:
        case ButtonType.error:
          this.foreground = onPrimary;
        case ButtonType.secondary:
          this.foreground = onSecondary;
        case ButtonType.tertiary:
          this.foreground = onTertiary;
        case ButtonType.outline:
        case ButtonType.ghost:
          this.foreground = onSurface;
        default:
          return;
      }
    }

    void setDisabledBackground() {
      this.disabledBackground =
          disabledBackground ?? background?.withOpacity(0.5);
    }

    void setDisabledForeground() {
      this.disabledForeground =
          disabledForeground ?? foreground?.withOpacity(0.5);
    }

    void setHoverColor() {
      this.hoverColor =
          hoverColor ?? theme.colorScheme.primary.withOpacity(0.1);
    }

    void setHighlightColor() {
      this.highlightColor =
          highlightColor ?? theme.colorScheme.primary.withOpacity(0.2);
    }

    void setFocusColor() {
      this.focusColor = focusColor ?? this.highlightColor;
    }

    setBackground();
    setForeground();
    setDisabledBackground();
    setDisabledForeground();
    setHoverColor();
    setHighlightColor();
    setFocusColor();
  }

  Color? background;

  Color? foreground;

  Color? disabledBackground;

  Color? disabledForeground;

  Color? hoverColor;

  Color? highlightColor;

  Color? focusColor;
}

class ButtonAction extends ActionImpl {
  /// If [onPressed] is null, the button will be disabled
  ButtonAction(super.context, {super.onPressed});

  bool get isDisabled => onPressed == null;
}

class ButtonChild extends ChildImpl {
  final String? text;

  final IconData? icon;

  /// If [child] is provided, [text] will be ignored
  ///
  /// [child] will be used as the button's child
  ///
  /// Icon of the button
  ///
  /// If [isLoading] is true, icon will be replaced with loading indicator
  ButtonChild(super.context, {super.child, this.text, this.icon});
}

class ButtonState extends StateImpl {
  /// If true, it will show a loading indicator
  ///
  /// If [icon] is provided, icon will be replaced with loading indicator
  ///
  /// [onPressed] will be disabled if [isLoading] is true
  ButtonState(super.context, {super.isLoading});
}

class ButtonSize extends SizeImpl {
  final ButtonType type;

  final double iconSize;

  final Size? minimumSize;

  late final TextStyle textStyle;

  late final EdgeInsetsGeometry padding;

  /// Size of the icon
  ///
  /// Default is 18px
  ///
  /// Minimum size of the button
  ///
  /// Default is 88px x 40px
  ///
  /// Text style of the button
  ///
  /// Default is bodyMedium
  ButtonSize(super.context, this.type,
      {this.iconSize = 18,
      this.minimumSize,
      TextStyle? textStyle,
      EdgeInsetsGeometry? padding}) {
    void setTextStyle() {
      this.textStyle = textStyle ?? theme.textTheme.bodyMedium!.sp;
    }

    void setPadding() {
      this.padding =
          padding ?? const EdgeInsets.symmetric(horizontal: 16, vertical: 8).w;
    }

    setTextStyle();
    setPadding();
  }
}

class ButtonBorder extends BorderImpl {
  final ButtonType type;

  ButtonBorder(super.context, this.type,
      {BorderSide? borderSide, BorderRadius? borderRadius}) {
    void setBorderSide() {
      this.borderSide = borderSide ??
          BorderSide(color: theme.dividerColor.withOpacity(0.6)).w;
    }

    void setBorderRadius() {
      this.borderRadius = borderRadius ?? BorderRadius.circular(6).r;
    }

    setBorderSide();
    setBorderRadius();
  }
}

typedef DecorationBuilder = ButtonDecoration Function(
    BuildContext context, ButtonType type);

enum ButtonType {
  primary,
  secondary,
  tertiary,
  error,
  outline,
  ghost,
  icon,
}

class DefaultButton extends StatelessWidget {
  final ButtonType type;
  final DecorationBuilder? decorationBuilder;

  const DefaultButton(
      {super.key, this.decorationBuilder, this.type = ButtonType.primary});

  @override
  Widget build(BuildContext context) {
    final ButtonDecoration decorationTheme =
        decorationBuilder?.call(context, type) ??
            ButtonDecoration(context, type: type);

    return getChild(decorationTheme);
  }

  Widget getChild(ButtonDecoration decoration) {
    final vm = decoration.themeVm;
    return Theme(
        data: vm.theme.copyWith(
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: _getButtonStyle(decoration),
          ),
          textButtonTheme: TextButtonThemeData(
            style: _getButtonStyle(decoration),
          ),
          iconButtonTheme: IconButtonThemeData(
            style: _getButtonStyle(decoration),
          ),
        ),
        child: _getButtonWidgetType(decoration));
  }

  ButtonStyle _getIconButtonStyle(ButtonDecoration decoration) {
    return IconButton.styleFrom(
      minimumSize: decoration.sizeTheme.minimumSize?.w,
      disabledMouseCursor: SystemMouseCursors.forbidden,
      backgroundColor: decoration.colorTheme.background,
      foregroundColor: decoration.colorTheme.foreground,
      hoverColor: decoration.colorTheme.hoverColor,
      disabledBackgroundColor: decoration.colorTheme.disabledBackground,
      disabledForegroundColor: decoration.colorTheme.disabledForeground,
      highlightColor: decoration.colorTheme.highlightColor,
      focusColor: decoration.colorTheme.focusColor,
      padding: decoration.sizeTheme.padding,
      splashFactory: NoSplash.splashFactory,
    );
  }

  ButtonStyle _getButtonStyle(ButtonDecoration decoration) {
    if (type == ButtonType.icon) {
      return _getIconButtonStyle(decoration);
    }
    return ElevatedButton.styleFrom(
      disabledBackgroundColor: decoration.colorTheme.disabledBackground,
      disabledForegroundColor: decoration.colorTheme.disabledForeground,
      backgroundColor: decoration.colorTheme.background,
      foregroundColor: decoration.colorTheme.foreground,
      shape: _getShape(decoration),
      side: _getBorder(decoration),
      padding: decoration.sizeTheme.padding,
      minimumSize: decoration.sizeTheme.minimumSize?.w,
      splashFactory: NoSplash.splashFactory,
      disabledMouseCursor: SystemMouseCursors.forbidden,
      textStyle: _getTextStyle(decoration),
    );
  }

  TextStyle _getTextStyle(ButtonDecoration decoration) {
    return decoration.sizeTheme.textStyle;
  }

  Widget _getButtonWidgetType(ButtonDecoration decoration) {
    bool isDisabled = decoration.actionThemeState.isDisabled;

    switch (type) {
      case ButtonType.primary:
      case ButtonType.secondary:
      case ButtonType.tertiary:
      case ButtonType.error:
        if (decoration.childTheme.icon == null) {
          return ElevatedButton(
            onPressed:
                isDisabled ? null : decoration.actionThemeState.onPressed,
            child: _getButtonChild(decoration),
          );
        } else {
          if (decoration.childTheme.text != null &&
              decoration.childTheme.text!.isNotEmpty) {
            return ElevatedButton.icon(
              onPressed:
                  isDisabled ? null : decoration.actionThemeState.onPressed,
              label: _getButtonChild(decoration),
              icon: decoration.stateTheme.isLoading
                  ? const _LoadingIndicator()
                  : Icon(decoration.childTheme.icon,
                      size: decoration.sizeTheme.iconSize.w),
            );
          }
          return ElevatedButton(
            onPressed:
                isDisabled ? null : decoration.actionThemeState.onPressed,
            child: decoration.stateTheme.isLoading
                ? const _LoadingIndicator()
                : Icon(decoration.childTheme.icon,
                    size: decoration.sizeTheme.iconSize.w),
          );
        }
      case ButtonType.outline:
      case ButtonType.ghost:
        if (decoration.childTheme.icon == null) {
          return TextButton(
            onPressed:
                isDisabled ? null : decoration.actionThemeState.onPressed,
            child: _getButtonChild(decoration),
          );
        } else {
          return TextButton.icon(
            onPressed:
                isDisabled ? null : decoration.actionThemeState.onPressed,
            label: _getButtonChild(decoration),
            icon: decoration.stateTheme.isLoading
                ? const _LoadingIndicator()
                : Icon(decoration.childTheme.icon,
                    size: decoration.sizeTheme.iconSize.w),
          );
        }
      case ButtonType.icon:
        return IconButton(
          onPressed: isDisabled ? null : decoration.actionThemeState.onPressed,
          icon: Icon(decoration.childTheme.icon,
              size: decoration.sizeTheme.iconSize),
        );
      default:
        return const SizedBox();
    }
  }

  Widget _getButtonChild(ButtonDecoration decoration) {
    final ch = decoration.childTheme.child ?? Text(_getText(decoration));
    if (decoration.childTheme.icon == null) {
      if (decoration.stateTheme.isLoading) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const _LoadingIndicator(),
            ch,
          ],
        ).spaced(8);
      }
    }
    return ch;
  }

  String _getText(ButtonDecoration decoration) {
    return decoration.childTheme.text ?? 'Button';
  }

  BorderSide? _getBorder(ButtonDecoration decoration) {
    if (type == ButtonType.ghost) return BorderSide.none;
    return decoration.borderTheme.borderSide;
  }

  OutlinedBorder? _getShape(ButtonDecoration decoration) {
    return RoundedRectangleBorder(
      borderRadius: decoration.borderTheme.borderRadius!,
    );
  }
}

class _LoadingIndicator extends StatelessWidget {
  const _LoadingIndicator();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 20.w,
      height: 20.h,
      child: CircularProgressIndicator(strokeWidth: 2.w),
    );
  }
}

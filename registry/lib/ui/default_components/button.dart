//v0.0.1

import 'package:flutter/material.dart';
import 'package:fcnui_base/fcnui_base.dart';

import 'fcnui_theme.dart';

class ButtonDecoration extends DecorationImpl {
  final ButtonType type;

  ButtonDecoration(
    super.themeVm, {
    required this.type,
    ButtonColor? color,
    ButtonChild? child,
    ButtonAction? action,
    ButtonState? state,
    ButtonSize? size,
    ButtonBorder? border,
  }) : super(color: color) {
    super.color = color ??= ButtonColor(themeVm, type: type);
    super.child = child ?? ButtonChild(themeVm);
    super.action = action ?? ButtonAction(themeVm);
    super.state = state ?? ButtonState(themeVm);
    super.size = size ?? ButtonSize(themeVm, type);
    super.border = border ?? ButtonBorder(themeVm, type);

    assert(
        this.size.iconSize >= 0, "iconSize must be greater than or equal to 0");
    assert(
        this.child.text != null ||
            this.child.child != null ||
            this.child.icon != null,
        "text, child, or icon must be provided");
  }

  @override
  ButtonColor get color => super.color as ButtonColor;

  @override
  ButtonChild get child => super.child as ButtonChild;

  @override
  ButtonAction get action => super.action as ButtonAction;

  @override
  ButtonState get state => super.state as ButtonState;

  @override
  ButtonSize get size => super.size as ButtonSize;

  @override
  ButtonBorder get border => super.border as ButtonBorder;
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
  ButtonAction(super.themeVm, {super.onPressed});

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
  ButtonChild(super.themeVm, {super.child, this.text, this.icon});
}

class ButtonState extends StateImpl {
  /// If true, it will show a loading indicator
  ///
  /// If [icon] is provided, icon will be replaced with loading indicator
  ///
  /// [onPressed] will be disabled if [isLoading] is true
  ButtonState(super.themeVm, {super.isLoading});
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
  ButtonSize(super.themeVm, this.type,
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

  ButtonBorder(super.themeVm, this.type,
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

typedef ButtonDecorationBuilder = ButtonDecoration Function(
    ThemeVm themeVm, ButtonType type);

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
  final ButtonDecorationBuilder? decorationBuilder;

  const DefaultButton(
      {super.key, this.decorationBuilder, this.type = ButtonType.primary});

  @override
  Widget build(BuildContext context) {
    return ThemeProvider(builder: (context, themeVm) {
      final ButtonDecoration decorationTheme =
          decorationBuilder?.call(themeVm, type) ??
              ButtonDecoration(themeVm, type: type);
      return getChild(decorationTheme);
    });
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
      minimumSize: decoration.size.minimumSize?.w,
      disabledMouseCursor: SystemMouseCursors.forbidden,
      backgroundColor: decoration.color.background,
      foregroundColor: decoration.color.foreground,
      hoverColor: decoration.color.hoverColor,
      disabledBackgroundColor: decoration.color.disabledBackground,
      disabledForegroundColor: decoration.color.disabledForeground,
      highlightColor: decoration.color.highlightColor,
      focusColor: decoration.color.focusColor,
      padding: decoration.size.padding,
      splashFactory: NoSplash.splashFactory,
    );
  }

  ButtonStyle _getButtonStyle(ButtonDecoration decoration) {
    if (type == ButtonType.icon) {
      return _getIconButtonStyle(decoration);
    }
    return ElevatedButton.styleFrom(
      disabledBackgroundColor: decoration.color.disabledBackground,
      disabledForegroundColor: decoration.color.disabledForeground,
      backgroundColor: decoration.color.background,
      foregroundColor: decoration.color.foreground,
      shape: _getShape(decoration),
      side: _getBorder(decoration),
      padding: decoration.size.padding,
      minimumSize: decoration.size.minimumSize?.w,
      splashFactory: NoSplash.splashFactory,
      disabledMouseCursor: SystemMouseCursors.forbidden,
      textStyle: _getTextStyle(decoration),
    );
  }

  TextStyle _getTextStyle(ButtonDecoration decoration) {
    return decoration.size.textStyle;
  }

  Widget _getButtonWidgetType(ButtonDecoration decoration) {
    bool isDisabled = decoration.action.isDisabled;

    switch (type) {
      case ButtonType.primary:
      case ButtonType.secondary:
      case ButtonType.tertiary:
      case ButtonType.error:
        if (decoration.child.icon == null) {
          return ElevatedButton(
            onPressed: isDisabled ? null : decoration.action.onPressed,
            child: _getButtonChild(decoration),
          );
        } else {
          if (decoration.child.text != null &&
              decoration.child.text!.isNotEmpty) {
            return ElevatedButton.icon(
              onPressed: isDisabled ? null : decoration.action.onPressed,
              label: _getButtonChild(decoration),
              icon: decoration.state.isLoading
                  ? const _LoadingIndicator()
                  : Icon(decoration.child.icon,
                      size: decoration.size.iconSize.w),
            );
          }
          return ElevatedButton(
            onPressed: isDisabled ? null : decoration.action.onPressed,
            child: decoration.state.isLoading
                ? const _LoadingIndicator()
                : Icon(decoration.child.icon, size: decoration.size.iconSize.w),
          );
        }
      case ButtonType.outline:
      case ButtonType.ghost:
        if (decoration.child.icon == null) {
          return TextButton(
            onPressed: isDisabled ? null : decoration.action.onPressed,
            child: _getButtonChild(decoration),
          );
        } else {
          return TextButton.icon(
            onPressed: isDisabled ? null : decoration.action.onPressed,
            label: _getButtonChild(decoration),
            icon: decoration.state.isLoading
                ? const _LoadingIndicator()
                : Icon(decoration.child.icon, size: decoration.size.iconSize.w),
          );
        }
      case ButtonType.icon:
        return IconButton(
          onPressed: isDisabled ? null : decoration.action.onPressed,
          icon: Icon(decoration.child.icon, size: decoration.size.iconSize),
        );
      default:
        return const SizedBox();
    }
  }

  Widget _getButtonChild(ButtonDecoration decoration) {
    final ch = decoration.child.child ?? Text(_getText(decoration));
    if (decoration.child.icon == null) {
      if (decoration.state.isLoading) {
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
    return decoration.child.text ?? 'Button';
  }

  BorderSide? _getBorder(ButtonDecoration decoration) {
    if (type == ButtonType.ghost) return BorderSide.none;
    return decoration.border.borderSide;
  }

  OutlinedBorder? _getShape(ButtonDecoration decoration) {
    return RoundedRectangleBorder(
      borderRadius: decoration.border.borderRadius!,
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

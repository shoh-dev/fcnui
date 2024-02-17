//v0.0.1

import 'package:flutter/material.dart';
import 'package:fcnui_base/fcnui_base.dart';

/// [ButtonVariant] is the base class for all button variants
///
/// Can use these variants:
/// - [PrimaryButtonVariant]
/// - [SecondaryButtonVariant]
/// - [TertiaryButtonVariant]
/// - [ErrorButtonVariant]
/// - [OutlineButtonVariant]
/// - [GhostButtonVariant]
abstract class ButtonVariant extends Equatable {
  /// If [onPressed] is null, the button will be disabled
  final VoidCallback? onPressed;

  final String? text;

  /// If [child] is provided, [text] will be ignored
  ///
  /// [child] will be used as the button's child
  final Widget? child;

  /// If true, it will show a loading indicator
  ///
  /// If [icon] is provided, icon will be replaced with loading indicator
  ///
  /// [onPressed] will be disabled if [isLoading] is true
  final bool isLoading;

  /// Icon of the button
  ///
  /// If [isLoading] is true, icon will be replaced with loading indicator
  final IconData? icon;

  /// Size of the icon
  ///
  /// Default is 18px
  final double iconSize;

  /// Minimum size of the button
  ///
  /// Default is 88px x 40px
  final Size minimumSize;

  ///Custom background color
  ///
  /// It will override the default background color if provided
  final Color? backgroundColor;

  ///Custom foreground color
  ///
  /// It will override the default foreground color if provided
  final Color? foregroundColor;

  const ButtonVariant(
      {this.onPressed,
      this.text,
      this.backgroundColor,
      this.foregroundColor,
      this.iconSize = 18,
      this.child,
      this.isLoading = false,
      this.minimumSize = const Size.square(48),
      this.icon})
      : assert(iconSize >= 0, "iconSize must be greater than or equal to 0"),
        assert(text != null || child != null || icon != null,
            "text, child, or icon must be provided");

  @override
  List<Object?> get props =>
      [onPressed, text, child, isLoading, icon, iconSize];
}

class PrimaryButtonVariant extends ButtonVariant {
  const PrimaryButtonVariant(
      {super.onPressed,
      super.text,
      super.child,
      super.isLoading,
      super.icon,
      super.iconSize,
      super.minimumSize,
      super.backgroundColor,
      super.foregroundColor});
}

class SecondaryButtonVariant extends ButtonVariant {
  const SecondaryButtonVariant(
      {super.onPressed,
      super.text,
      super.child,
      super.isLoading,
      super.icon,
      super.iconSize,
      super.minimumSize,
      super.backgroundColor,
      super.foregroundColor});
}

class TertiaryButtonVariant extends ButtonVariant {
  const TertiaryButtonVariant(
      {super.onPressed,
      super.text,
      super.child,
      super.isLoading,
      super.icon,
      super.iconSize,
      super.minimumSize,
      super.backgroundColor,
      super.foregroundColor});
}

class ErrorButtonVariant extends ButtonVariant {
  const ErrorButtonVariant(
      {super.onPressed,
      super.text,
      super.child,
      super.isLoading,
      super.icon,
      super.iconSize,
      super.minimumSize,
      super.backgroundColor,
      super.foregroundColor});
}

class OutlineButtonVariant extends ButtonVariant {
  const OutlineButtonVariant(
      {super.onPressed,
      super.text,
      super.child,
      super.isLoading,
      super.icon,
      super.iconSize,
      super.minimumSize,
      super.backgroundColor,
      super.foregroundColor});
}

class GhostButtonVariant extends ButtonVariant {
  const GhostButtonVariant(
      {super.onPressed,
      super.text,
      super.child,
      super.isLoading,
      super.icon,
      super.iconSize,
      super.minimumSize,
      super.backgroundColor,
      super.foregroundColor});
}

class DefaultButton extends StatelessWidget {
  final ButtonVariant variant;

  const DefaultButton({super.key, required this.variant});

  @override
  Widget build(BuildContext context) {
    return ThemeProvider(
      builder: (context, vm) {
        return getChild(vm);
      },
    );
  }

  Widget getChild(ThemeVm vm) {
    return _getButtonWidgetType(vm.theme);
  }

  ButtonStyle _getButtonStyle(ThemeData theme) {
    return ElevatedButton.styleFrom(
      disabledBackgroundColor: _getBackgroundColor(theme)?.withOpacity(0.5),
      disabledForegroundColor: _getForegroundColor(theme)?.withOpacity(0.5),
      backgroundColor: _getBackgroundColor(theme),
      foregroundColor: _getForegroundColor(theme),
      shape: _getShape(theme),
      side: _getBorder(theme),
      padding: _getPadding(theme),
      minimumSize: variant.minimumSize.w,
      splashFactory: NoSplash.splashFactory,
      disabledMouseCursor: SystemMouseCursors.forbidden,
      surfaceTintColor: theme.colorScheme.surface,
    );
  }

  EdgeInsetsGeometry _getPadding(ThemeData theme) {
    switch (variant.runtimeType) {
      default:
        return const EdgeInsets.symmetric(horizontal: 16, vertical: 8).w;
    }
  }

  Widget _getButtonWidgetType(ThemeData theme) {
    switch (variant.runtimeType) {
      case const (PrimaryButtonVariant):
      case const (SecondaryButtonVariant):
      case const (TertiaryButtonVariant):
      case const (ErrorButtonVariant):
        if (variant.icon == null) {
          return ElevatedButton(
            style: _getButtonStyle(theme),
            onPressed: _getOnPressed,
            child: _getButtonChild(theme),
          );
        } else {
          if (variant.text != null && variant.text!.isNotEmpty) {
            return ElevatedButton.icon(
              style: _getButtonStyle(theme),
              onPressed: _getOnPressed,
              label: _getButtonChild(theme),
              icon: variant.isLoading
                  ? const _LoadingIndicator()
                  : Icon(variant.icon, size: variant.iconSize.w),
            );
          }
          return ElevatedButton(
            style: _getButtonStyle(theme),
            onPressed: _getOnPressed,
            child: variant.isLoading
                ? const _LoadingIndicator()
                : Icon(variant.icon, size: variant.iconSize.w),
          );
        }
      case const (OutlineButtonVariant):
      case const (GhostButtonVariant):
        if (variant.icon == null) {
          return TextButton(
            style: _getButtonStyle(theme),
            onPressed: _getOnPressed,
            child: _getButtonChild(theme),
          );
        } else {
          return TextButton.icon(
            style: _getButtonStyle(theme),
            onPressed: _getOnPressed,
            label: _getButtonChild(theme),
            icon: variant.isLoading
                ? const _LoadingIndicator()
                : Icon(variant.icon, size: variant.iconSize.w),
          );
        }
      default:
        return const SizedBox();
    }
  }

  VoidCallback? get _getOnPressed {
    switch (variant.runtimeType) {
      default:
        if (variant.isLoading) return null;
        return variant.onPressed;
    }
  }

  Color? _getBackgroundColor(ThemeData theme) {
    if (variant.backgroundColor != null) return variant.backgroundColor;
    switch (variant.runtimeType) {
      case const (PrimaryButtonVariant):
        return theme.colorScheme.primary;
      case const (SecondaryButtonVariant):
        return theme.colorScheme.secondary;
      case const (TertiaryButtonVariant):
        return theme.colorScheme.tertiary;
      case const (ErrorButtonVariant):
        return theme.colorScheme.error;
      default:
        return null;
    }
  }

  Color? _getForegroundColor(ThemeData theme) {
    if (variant.foregroundColor != null) return variant.foregroundColor;
    switch (variant.runtimeType) {
      case const (PrimaryButtonVariant):
      case const (ErrorButtonVariant):
        return theme.colorScheme.onPrimary;
      case const (SecondaryButtonVariant):
        return theme.colorScheme.onSecondary;
      case const (TertiaryButtonVariant):
        return theme.colorScheme.onTertiary;
      case const (OutlineButtonVariant):
      case const (GhostButtonVariant):
        return theme.colorScheme.onSurface;
      default:
        return null;
    }
  }

  Widget _getButtonChild(ThemeData theme) {
    final ch = variant.child ?? Text(_getText());
    if (variant.icon == null) {
      if (variant.isLoading) {
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

  String _getText() {
    return variant.text ?? 'Button';
  }

  BorderSide? _getBorder(ThemeData theme) {
    switch (variant.runtimeType) {
      case const (OutlineButtonVariant):
        return BorderSide(color: theme.colorScheme.outline).w;
      default:
        return null;
    }
  }

  OutlinedBorder? _getShape(ThemeData theme) {
    switch (variant.runtimeType) {
      default:
        return RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(6).r,
        );
    }
  }
}

class _LoadingIndicator extends StatelessWidget {
  const _LoadingIndicator();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 20,
      height: 20,
      child: CircularProgressIndicator(strokeWidth: 2.w),
    );
  }
}

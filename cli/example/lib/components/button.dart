///v0.0.3

import 'package:flutter/material.dart';
import 'package:fcnui_base/fcnui_base.dart';

abstract class ButtonVariant extends Equatable {
  final VoidCallback? onPressed;
  final String? text;
  final Widget? child;
  final bool isLoading;
  final IconData? icon;
  final double iconSize;
  final Size minimumSize;

  const ButtonVariant(
      {this.onPressed,
      this.text,
      this.iconSize = 20,
      this.child,
      this.isLoading = false,
      this.minimumSize = const Size(88, 42),
      this.icon});

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
      super.minimumSize});
}

class SecondaryButtonVariant extends ButtonVariant {
  const SecondaryButtonVariant(
      {super.onPressed,
      super.text,
      super.child,
      super.isLoading,
      super.icon,
      super.iconSize,
      super.minimumSize});
}

class TertiaryButtonVariant extends ButtonVariant {
  const TertiaryButtonVariant(
      {super.onPressed,
      super.text,
      super.child,
      super.isLoading,
      super.icon,
      super.iconSize,
      super.minimumSize});
}

class ErrorButtonVariant extends ButtonVariant {
  const ErrorButtonVariant(
      {super.onPressed,
      super.text,
      super.child,
      super.isLoading,
      super.icon,
      super.iconSize,
      super.minimumSize});
}

class OutlineButtonVariant extends ButtonVariant {
  const OutlineButtonVariant(
      {super.onPressed,
      super.text,
      super.child,
      super.isLoading,
      super.icon,
      super.iconSize,
      super.minimumSize});
}

class GhostButtonVariant extends ButtonVariant {
  const GhostButtonVariant(
      {super.onPressed,
      super.text,
      super.child,
      super.isLoading,
      super.icon,
      super.iconSize,
      super.minimumSize});
}

class DefaultButton extends StatelessWidget {
  final ButtonVariant variant;

  const DefaultButton({
    super.key,
    this.variant = const PrimaryButtonVariant(),
  });

  @override
  Widget build(BuildContext context) {
    return ThemeProvider(
      builder: (context, vm) {
        return getChild(context, vm);
      },
    );
  }

  Widget getChild(BuildContext context, ThemeVm vm) {
    ///! Below part must not be changed

    final theme = vm.theme;

    ///! Above part must not be changed

    return Theme(data: theme, child: _getButtonWidgetType(theme));
  }

  ButtonStyle _getButtonStyle(ThemeData theme) {
    return ElevatedButton.styleFrom(
      backgroundColor: _getBackgroundColor(theme),
      foregroundColor: _getForegroundColor(theme),
      minimumSize: variant.minimumSize,
      shape: _getShape(theme),
      side: _getBorder(theme),
      splashFactory: NoSplash.splashFactory,
    );
  }

  Widget _getButtonWidgetType(ThemeData theme) {
    switch (variant.runtimeType) {
      case PrimaryButtonVariant:
      case SecondaryButtonVariant:
      case TertiaryButtonVariant:
      case ErrorButtonVariant:
        if (variant.icon == null) {
          return ElevatedButton(
            style: _getButtonStyle(theme),
            onPressed: _getOnPressed,
            child: _getButtonChild(theme),
          );
        } else {
          return ElevatedButton.icon(
            style: _getButtonStyle(theme),
            onPressed: _getOnPressed,
            label: _getButtonChild(theme),
            icon: variant.isLoading
                ? const _LoadingIndicator()
                : Icon(variant.icon, size: variant.iconSize),
          );
        }
      case OutlineButtonVariant:
      case GhostButtonVariant:
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
                : Icon(variant.icon, size: variant.iconSize),
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
    switch (variant.runtimeType) {
      case PrimaryButtonVariant:
        return theme.colorScheme.primary;
      case SecondaryButtonVariant:
        return theme.colorScheme.secondary;
      case TertiaryButtonVariant:
        return theme.colorScheme.tertiary;
      case ErrorButtonVariant:
        return theme.colorScheme.error;
      default:
        return null;
    }
  }

  Color? _getForegroundColor(ThemeData theme) {
    switch (variant.runtimeType) {
      case PrimaryButtonVariant:
      case ErrorButtonVariant:
        return theme.colorScheme.onPrimary;
      case SecondaryButtonVariant:
        return theme.colorScheme.onSecondary;
      case TertiaryButtonVariant:
        return theme.colorScheme.onTertiary;
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
            const SizedBox(width: 8),
            ch,
          ],
        );
      }
    }
    return ch;
  }

  String _getText() {
    if (variant.isLoading) {
      return "Please wait";
    }
    return variant.text ?? 'Button';
  }

  BorderSide? _getBorder(ThemeData theme) {
    switch (variant.runtimeType) {
      case OutlineButtonVariant:
        return BorderSide(color: theme.colorScheme.primary, width: 1);
      default:
        return null;
    }
  }

  OutlinedBorder? _getShape(ThemeData theme) {
    switch (variant.runtimeType) {
      case GhostButtonVariant:
        return null;
      default:
        return RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(6),
        );
    }
  }
}

class _LoadingIndicator extends StatelessWidget {
  const _LoadingIndicator();

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      width: 20,
      height: 20,
      child: CircularProgressIndicator(strokeWidth: 2),
    );
  }
}

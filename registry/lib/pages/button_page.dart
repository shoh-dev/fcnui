import 'package:fcnui_base/fcnui_base.dart';
import 'package:flutter/material.dart';
import 'package:registry/ui/default_components/button.dart';

import 'page_impl.dart';

class ButtonPage extends PageImpl {
  final String variant;
  final bool isDisabled;
  final bool isLoading;
  final bool withIcon;

  const ButtonPage(
      {super.key,
      required this.variant,
      required this.isDisabled,
      required this.withIcon,
      required this.isLoading});

  @override
  Widget preview() {
    switch (variant) {
      case 'secondary':
        return DefaultButton(
          variant: SecondaryButtonVariant(
            isLoading: isLoading,
            text: getText(),
            onPressed: isDisabled ? null : () {},
            icon: withIcon ? Icons.email : null,
          ),
        );
      case 'tertiary':
        return DefaultButton(
          variant: TertiaryButtonVariant(
            text: getText(),
            isLoading: isLoading,
            onPressed: isDisabled ? null : () {},
            icon: withIcon ? Icons.email : null,
          ),
        );
      case 'error':
        return DefaultButton(
          variant: ErrorButtonVariant(
            text: getText(),
            isLoading: isLoading,
            onPressed: isDisabled ? null : () {},
            icon: withIcon ? Icons.email : null,
          ),
        );
      case 'outline':
        return DefaultButton(
          variant: OutlineButtonVariant(
            text: getText(),
            isLoading: isLoading,
            onPressed: isDisabled ? null : () {},
            icon: withIcon ? Icons.email : null,
          ),
        );
      case 'ghost':
        return DefaultButton(
          variant: GhostButtonVariant(
            text: getText(),
            isLoading: isLoading,
            onPressed: isDisabled ? null : () {},
            icon: withIcon ? Icons.email : null,
          ),
        );
      default:
        return DefaultButton(
          variant: PrimaryButtonVariant(
            text: getText(),
            isLoading: isLoading,
            onPressed: isDisabled ? null : () {},
            icon: withIcon ? Icons.email : null,
          ),
        );
    }
  }

  String getText() {
    StringBuffer buffer = StringBuffer();

    buffer.write(variant.capitalize);

    if (isLoading) {
      buffer.clear();
      buffer.write('Loading');
    }

    if (isDisabled) {
      buffer.clear();
      buffer.write('Disabled');
    }

    if (withIcon) {
      buffer.clear();
      buffer.write('With Icon');
    }

    return buffer.toString();
  }

  @override
  String getCode() {
    return """
DefaultButton(
  variant: ${variant.capitalize}ButtonVariant(
  text: "${variant.capitalize}${isLoading ? ' Loading' : ''}${isDisabled ? ' Disabled' : ''}${withIcon ? ' With Icon' : ''},
  onPressed: ${isDisabled ? 'null' : '() {}'},
  isLoading: $isLoading,
  icon: ${withIcon ? 'Icons.email' : 'null'},
  ),
),
    """;
  }
}

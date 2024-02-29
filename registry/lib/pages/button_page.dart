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
  Widget preview(BuildContext context) {
    decoration(context, type) {
      return ButtonDecoration(
        context,
        type: type,
        action: ButtonAction(context, onPressed: isDisabled ? null : () {}),
        child: ButtonChild(context,
            text: getText(),
            icon: variant == "icon"
                ? Icons.email
                : (withIcon ? Icons.email : null)),
        state: ButtonState(context, isLoading: isLoading),
      );
    }

    switch (variant) {
      case 'secondary':
        return DefaultButton(
            type: ButtonType.secondary, decorationBuilder: decoration);
      case 'tertiary':
        return DefaultButton(
            type: ButtonType.tertiary, decorationBuilder: decoration);
      case 'error':
        return DefaultButton(
            type: ButtonType.error, decorationBuilder: decoration);
      case 'outline':
        return DefaultButton(
            type: ButtonType.outline, decorationBuilder: decoration);
      case 'ghost':
        return DefaultButton(
            type: ButtonType.ghost, decorationBuilder: decoration);
      case 'icon':
        return DefaultButton(
            type: ButtonType.icon, decorationBuilder: decoration);
      default:
        return DefaultButton(decorationBuilder: decoration);
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

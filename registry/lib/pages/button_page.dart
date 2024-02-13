import 'package:any_syntax_highlighter/any_syntax_highlighter.dart';
import 'package:any_syntax_highlighter/themes/any_syntax_highlighter_theme.dart';
import 'package:fcnui_base/fcnui_base.dart';
import 'package:flutter/material.dart';
import 'package:registry/ui/default_components/default_components.dart';
import 'package:registry/ui/layout/default_layout.dart';

class ButtonPage extends StatelessWidget {
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
  Widget build(BuildContext context) {
    print(variant);
    return DefaultLayout(child: (controller) {
      return TabBarView(
        physics: const NeverScrollableScrollPhysics(),
        clipBehavior: Clip.none,
        controller: controller,
        children: [
          Center(child: preview()),
          code(context),
        ],
      );
    });
  }

  Widget preview() {
    switch (variant) {
      case 'secondary':
        return DefaultButton(
          variant: SecondaryButtonVariant(
            isLoading: isLoading,
            text: "Secondary",
            onPressed: isDisabled ? null : () {},
            icon: withIcon ? Icons.email : null,
          ),
        );
      case 'tertiary':
        return DefaultButton(
          variant: TertiaryButtonVariant(
            text: "Tertiary",
            isLoading: isLoading,
            onPressed: isDisabled ? null : () {},
            icon: withIcon ? Icons.email : null,
          ),
        );
      case 'error':
        return DefaultButton(
          variant: ErrorButtonVariant(
            text: "Error",
            isLoading: isLoading,
            onPressed: isDisabled ? null : () {},
            icon: withIcon ? Icons.email : null,
          ),
        );
      case 'outline':
        return DefaultButton(
          variant: OutlineButtonVariant(
            text: "Outline",
            isLoading: isLoading,
            onPressed: isDisabled ? null : () {},
            icon: withIcon ? Icons.email : null,
          ),
        );
      case 'ghost':
        return DefaultButton(
          variant: GhostButtonVariant(
            text: "Ghost",
            isLoading: isLoading,
            onPressed: isDisabled ? null : () {},
            icon: withIcon ? Icons.email : null,
          ),
        );
      default:
        return DefaultButton(
          variant: PrimaryButtonVariant(
            text: "Primary",
            isLoading: isLoading,
            onPressed: isDisabled ? null : () {},
            icon: withIcon ? Icons.email : null,
          ),
        );
    }
  }

  Widget code(BuildContext context) {
    String code = """
DefaultButton(
  variant: ${variant.capitalize}ButtonVariant(
  text: "${variant.capitalize}${isLoading ? ' Loading' : ''}${isDisabled ? ' Disabled' : ''}${withIcon ? ' With Icon' : ''},
  onPressed: ${isDisabled ? 'null' : '() {}'},
  isLoading: $isLoading,
  icon: ${withIcon ? 'Icons.email' : 'null'},
  ),
),
    """;
    return Center(
        child: SingleChildScrollView(
            child: AnySyntaxHighlighter(code,
                hasCopyButton: true, padding: 16, isSelectableText: true)));
  }
}

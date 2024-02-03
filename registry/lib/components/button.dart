import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:registry/vm_providers/vm_providers.dart';

class MyButton extends StatelessWidget {
  const MyButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ThemeProvider(
      builder: (context, vm) {
        final flexScheme = vm.flexScheme;
        print(flexScheme);
        final theme = vm.themeMode == ThemeMode.dark
            ? FlexThemeData.dark(scheme: flexScheme)
            : FlexThemeData.light(scheme: flexScheme);
        return Theme(
          data: theme,
          child: ElevatedButton(
            onPressed: () {},
            child: const Text('Button'),
          ),
        );
      },
    );
  }
}

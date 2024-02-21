import 'package:any_syntax_highlighter/any_syntax_highlighter.dart';
import 'package:flutter/material.dart';
import 'package:registry/ui/layout/default_layout.dart';

abstract class PageImpl extends StatelessWidget {
  const PageImpl({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(child: (controller) {
      return TabBarView(
        physics: const NeverScrollableScrollPhysics(),
        clipBehavior: Clip.none,
        controller: controller,
        children: [
          Center(child: SingleChildScrollView(child: preview())),
          Center(child: SingleChildScrollView(child: _codeWidget(context))),
        ],
      );
    });
  }

  String getCode();

  Widget preview();

  Widget _codeWidget(BuildContext context) {
    return AnySyntaxHighlighter(getCode(),
        hasCopyButton: true, padding: 16, isSelectableText: true);
  }
}

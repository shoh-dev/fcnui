// import 'package:any_syntax_highlighter/any_syntax_highlighter.dart';
// import 'package:fcnui_base/fcnui_base.dart';
// import 'package:flutter/material.dart';
// import 'package:registry/ui/default_components/default_components.dart';
// import 'package:registry/ui/default_components/form/form.dart';
// import 'package:registry/ui/layout/default_layout.dart';
//
// class FormPage extends StatelessWidget {
//   const FormPage({
//     super.key,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return DefaultLayout(child: (controller) {
//       return TabBarView(
//         physics: const NeverScrollableScrollPhysics(),
//         clipBehavior: Clip.none,
//         controller: controller,
//         children: [
//           Center(
//             child: SingleChildScrollView(
//               child: preview(),
//             ),
//           ),
//           Center(child: SingleChildScrollView(child: code(context))),
//         ],
//       );
//     });
//   }
//
//   Widget preview() {}
//
//   Widget code(BuildContext context) {
//     String code = "";
//
//     if (isCustom) {
//       code = "";
//     } else if (isDecorated) {
//       code = "";
//     } else {
//       code = "";
//     }
//     return AnySyntaxHighlighter(code,
//         hasCopyButton: true, padding: 16, isSelectableText: true);
//   }
// }

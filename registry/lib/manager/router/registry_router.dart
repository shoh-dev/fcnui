import 'package:go_router/go_router.dart';
import 'package:registry/main.dart';
import 'package:registry/pages/pages.dart';

final registryRouter = GoRouter(
  debugLogDiagnostics: true,
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) {
        return const MyHomePage(title: 'Registry App for Flutter cn UI');
      },
    ),
    GoRoute(
      path: "/button",
      builder: (context, state) {
        final variant = state.uri.queryParameters['variant'];
        final String isDisabled =
            state.uri.queryParameters['isDisabled'] ?? "false";
        final String isLoading =
            state.uri.queryParameters['isLoading'] ?? "false";
        final String withIcon =
            state.uri.queryParameters['withIcon'] ?? "false";

        return ButtonPage(
            variant: variant ?? "primary",
            isDisabled: isDisabled == "true",
            isLoading: isLoading == "true",
            withIcon: withIcon == "true");
      },
    ),
    GoRoute(
      path: "/card",
      builder: (context, state) {
        final String isCustom =
            state.uri.queryParameters['isCustom'] ?? "false";
        final String isDecorated =
            state.uri.queryParameters['isDecorated'] ?? "false";

        return CardPage(
          isCustom: isCustom == "true",
          isDecorated: isDecorated == "true",
        );
      },
    ),
    GoRoute(
      path: "/input",
      builder: (context, state) {
        final String isDisabled =
            state.uri.queryParameters['isDisabled'] ?? "false";
        final String withLabel =
            state.uri.queryParameters['withLabel'] ?? "false";
        final String withButton =
            state.uri.queryParameters['withButton'] ?? "false";
        final String isForm = state.uri.queryParameters['isForm'] ?? "false";
        return InputPage(
          isDisabled: isDisabled == "true",
          withLabel: withLabel == "true",
          withButton: withButton == "true",
          isForm: isForm == "true",
        );
      },
    ),

    //CheckboxPage
    GoRoute(
      path: "/checkbox",
      builder: (context, state) {
        final variant = CheckboxVariant.values.firstWhere(
            (e) => e.name == state.uri.queryParameters['variant'],
            orElse: () => CheckboxVariant.withLabel);
        return CheckboxPage(variant: variant);
      },
    ),

    //DropdownPage
    GoRoute(
      path: "/dropdown",
      builder: (context, state) {
        final variant = DpVariant.values.firstWhere(
            (e) => e.name == state.uri.queryParameters['variant'],
            orElse: () => DpVariant.form);
        return DropdownPage(variant: variant);
      },
    ),

    //Switch
    GoRoute(
      path: "/switch",
      builder: (context, state) {
        final variant = SwitchVariant.values.firstWhere(
            (e) => e.name == state.uri.queryParameters['variant'],
            orElse: () => SwitchVariant.withTitle);
        return SwitchPage(variant: variant);
      },
    ),

    //Radio
    GoRoute(
      path: "/radio",
      builder: (context, state) {
        final variant = RadioVariant.values.firstWhere(
            (e) => e.name == state.uri.queryParameters['variant'],
            orElse: () => RadioVariant.idle);
        return RadioPage(variant: variant);
      },
    ),

    //Select
    GoRoute(
      path: "/select",
      builder: (context, state) {
        final variant = SelectVariant.values.firstWhere(
            (e) => e.name == state.uri.queryParameters['variant'],
            orElse: () => SelectVariant.basic);
        return SelectPage(variant: variant);
      },
    ),
  ],
);

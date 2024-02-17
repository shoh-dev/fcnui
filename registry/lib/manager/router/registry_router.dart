import 'package:go_router/go_router.dart';
import 'package:registry/main.dart';
import 'package:registry/pages/pages.dart';

final registryRouter = GoRouter(
  debugLogDiagnostics: true,
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) {
        return MyHomePage(title: 'Registry App for Flutter cn UI');
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
  ],
);

import 'package:fcnui_base/fcnui_base.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:registry/ui/default_components/button.dart';
import 'package:registry/ui/default_components/dp_item.dart';
import 'package:registry/ui/default_components/form.dart';
import 'package:registry/ui/default_components/radio.dart';
import 'package:registry/ui/default_components/save_button.dart';
import 'package:registry/ui/default_components/switch.dart';
import 'package:registry/ui/default_components/with_label.dart';
import 'manager/manager.dart';
import 'ui/default_components/dropdown.dart';
import 'ui/layout/default_layout.dart';

void main() async {
  runApp(DefaultStoreProvider(child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ThemeProvider(
      builder: (context, vm) => MaterialApp.router(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(useMaterial3: true),
        darkTheme: ThemeData(brightness: Brightness.dark, useMaterial3: true),
        // theme: FlexThemeData.light(scheme: vm.flexScheme, useMaterial3: true),
        // darkTheme:
        //     FlexThemeData.dark(scheme: vm.flexScheme, useMaterial3: true),
        themeMode: vm.themeMode,
        title: 'Flutter Demo',
        routerConfig: registryRouter,
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  MyHomePage({super.key, required this.title});

  final String title;

  final formModel = FormModel();

  @override
  Widget build(BuildContext context) {
    return ThemeProvider(
      builder: (context, vm) {
        return Scaffold(
          appBar: const DefaultAppBar(),
          body: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  DefaultButton(
                      variant: SecondaryButtonVariant(
                          onPressed: () => ChangeUsePlatformThemeAction(
                                  usePlatformTheme: !vm.usePlatformTheme)
                              .payload(),
                          text: "Use platform theme ${vm.usePlatformTheme}")),
                  ElevatedButton(
                      onPressed: () => context.go(Uri(
                            path: "/radio",
                            queryParameters: {
                              "variant": "form",
                            },
                          ).toString()),
                      child: const Text("Go to")),

                  //   ------------------------------------------
                ],
              ).spaced(20)),
        );
      },
    );
  }
}

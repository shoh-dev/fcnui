// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:fcnui_base/fcnui_base.dart';
import 'package:go_router/go_router.dart';

import 'manager/manager.dart';
import 'ui/default_components/default_components.dart';

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
        theme: FlexColorScheme.light(scheme: vm.flexScheme).toTheme,
        darkTheme: FlexColorScheme.dark(scheme: vm.flexScheme).toTheme,
        themeMode: vm.themeMode,
        title: 'Flutter Demo',
        routerConfig: registryRouter,
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(title),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              StoreConnector<AppState, String>(
                  converter: (store) => store.state.themeState.themeMode,
                  builder: (context, vm) {
                    return Text("Theme Mode: $vm");
                  }),
              const SizedBox(height: 20),
              ElevatedButton(
                  onPressed: () {},
                  child: const Text("Default Elevated Button")),
              const SizedBox(height: 20),
              DefaultButton(
                variant: PrimaryButtonVariant(
                  text: "Go to Button Page",
                  onPressed: () {
                    context.go(Uri(path: '/button', queryParameters: {
                      "variant": 'secondary',
                    }).toString());
                  },
                ),
              ),
              const SizedBox(height: 20),
              ThemeProvider(builder: (context, vm) {
                return ElevatedButton(
                    onPressed: () {
                      vm.onToggleThemeMode(ThemeMode.dark);
                    },
                    child: const Text("Dark"));
              }),
              const SizedBox(height: 20),
              ThemeProvider(builder: (context, vm) {
                return ElevatedButton(
                    onPressed: () {
                      vm.onToggleThemeMode(ThemeMode.light);
                    },
                    child: const Text("Light"));
              }),
              const SizedBox(height: 20),
              ThemeProvider(builder: (context, vm) {
                return ElevatedButton(
                    onPressed: () {
                      ChangeUsePlatformThemeAction(usePlatformTheme: true)
                          .payload();
                    },
                    child: const Text("Use platform theme"));
              }),
              const SizedBox(height: 20),
              ThemeProvider(
                builder: (context, vm) => SizedBox(
                  width: 200,
                  child: DropdownButtonFormField<int>(
                      menuMaxHeight: 200,
                      value: FlexScheme.values
                          .indexWhere((e) => e.name == vm.flexScheme.name),
                      items: FlexScheme.values
                          .map((e) => DropdownMenuItem<int>(
                              value: e.index, child: Text(e.name)))
                          .toList(),
                      onChanged: (value) {
                        ChangeFlexSchemeAction(
                                flexScheme: FlexScheme.values[value!].name)
                            .payload();
                        // vm.onChangeThemeScheme(FlexScheme.values[value!]);
                      }),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

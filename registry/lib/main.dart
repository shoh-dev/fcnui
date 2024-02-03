// ignore_for_file: deprecated_member_use

import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:registry/components/button.dart';
import 'package:registry/dependency_injection/dependency_injection.dart';
import 'package:registry/store/store.dart';
import 'package:registry/vm_providers/theme_provider.dart';

void main() {
  initDependency();

  runApp(
      StoreProvider(store: getIt.get<Store<AppState>>(), child: const MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ThemeProvider(
      builder: (context, vm) => MaterialApp(
        theme: FlexColorScheme.light(scheme: vm.flexScheme).toTheme,
        darkTheme: FlexColorScheme.dark(scheme: vm.flexScheme).toTheme,
        themeMode: vm.themeMode,
        title: 'Flutter Demo',
        home: const MyHomePage(title: 'Registry App for Flutter cn UI'),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
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
              MyButton(
                variant: PrimaryButtonVariant(
                  onPressed: () {},
                ),
              ),
              const SizedBox(height: 20),
              MyButton(
                variant: SecondaryButtonVariant(
                  text: "Secondary",
                  onPressed: () {},
                ),
              ),
              const SizedBox(height: 20),
              MyButton(
                variant: TertiaryButtonVariant(
                  text: "Tertiary",
                  onPressed: () {},
                ),
              ),
              const SizedBox(height: 20),
              MyButton(
                variant: ErrorButtonVariant(
                  text: "Error",
                  onPressed: () {},
                ),
              ),
              const SizedBox(height: 20),
              MyButton(
                variant: OutlineButtonVariant(
                  text: "Outline",
                  onPressed: () {},
                ),
              ),
              const SizedBox(height: 20),
              MyButton(
                variant: GhostButtonVariant(
                  text: "Ghost",
                  onPressed: () {},
                ),
              ),
              const SizedBox(height: 20),
              MyButton(
                variant: PrimaryButtonVariant(
                  icon: Icons.chevron_right,
                  onPressed: () {},
                ),
              ),
              const SizedBox(height: 20),
              MyButton(
                variant: GhostButtonVariant(
                  icon: Icons.chevron_right,
                  isLoading: true,
                  onPressed: () {},
                  text: "Icon Button with text",
                ),
              ),
              const SizedBox(height: 20),
              MyButton(
                variant: OutlineButtonVariant(
                  isLoading: true,
                  onPressed: () {},
                  text: "Icon Button with text",
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                  onPressed: () {
                    getIt
                        .get<Store<AppState>>()
                        .dispatch(ChangeThemeModeAction(themeMode: 'dark'));
                  },
                  child: const Text("Dark")),
              const SizedBox(height: 20),
              ElevatedButton(
                  onPressed: () {
                    getIt
                        .get<Store<AppState>>()
                        .dispatch(ChangeThemeModeAction(themeMode: 'light'));
                  },
                  child: const Text("Light")),
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
                        getIt.get<Store<AppState>>().dispatch(
                            ChangeFlexSchemeAction(
                                flexScheme: FlexScheme.values[value!].name));
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

// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:fcnui_base/fcnui_base.dart';

import 'ui/default_components/default_components.dart';

void main() {
  runApp(DefaultStoreProvider(child: const MyApp()));
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
      builder: (context, vm) => const MaterialApp(
        // theme: FlexColorScheme.light(scheme: vm.flexScheme).toTheme,
        // darkTheme: FlexColorScheme.dark(scheme: vm.flexScheme).toTheme,
        // themeMode: vm.themeMode,
        title: 'Flutter Demo',
        home: MyHomePage(title: 'Registry App for Flutter cn UI'),
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
              ElevatedButton(
                  onPressed: () {},
                  child: const Text("Default Elevated Button")),
              const SizedBox(height: 20),
              DefaultButton(
                variant: PrimaryButtonVariant(
                  onPressed: () {},
                ),
              ),
              const SizedBox(height: 20),
              DefaultButton(
                variant: SecondaryButtonVariant(
                  text: "Secondary",
                  onPressed: () {},
                ),
              ),
              const SizedBox(height: 20),
              DefaultButton(
                variant: TertiaryButtonVariant(
                  text: "Tertiary",
                  onPressed: () {},
                ),
              ),
              const SizedBox(height: 20),
              DefaultButton(
                variant: ErrorButtonVariant(
                  text: "Error",
                  onPressed: () {},
                ),
              ),
              const SizedBox(height: 20),
              DefaultButton(
                variant: OutlineButtonVariant(
                  text: "Outline",
                  onPressed: () {},
                ),
              ),
              const SizedBox(height: 20),
              DefaultButton(
                variant: GhostButtonVariant(
                  text: "Ghost",
                  onPressed: () {},
                ),
              ),
              const SizedBox(height: 20),
              DefaultButton(
                variant: PrimaryButtonVariant(
                  icon: Icons.chevron_right,
                  onPressed: () {},
                ),
              ),
              const SizedBox(height: 20),
              DefaultButton(
                variant: GhostButtonVariant(
                  icon: Icons.chevron_right,
                  onPressed: () {},
                  text: "Icon Button with text",
                ),
              ),
              const SizedBox(height: 20),
              DefaultButton(
                variant: PrimaryButtonVariant(
                  onPressed: () {},
                  isLoading: true,
                  text: "Login with Email",
                  icon: Icons.email,
                ),
              ),
              const SizedBox(height: 20),
              DefaultButton(
                variant: PrimaryButtonVariant(
                  onPressed: () {},
                  isLoading: true,
                  child: const Icon(Icons.email),
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
                      fcnGetIt.get<Store<AppState>>().dispatch(
                          ChangeUsePlatformThemeAction(usePlatformTheme: true));
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
                        vm.onChangeThemeScheme(FlexScheme.values[value!]);
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

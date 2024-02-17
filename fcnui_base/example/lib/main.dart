/// 0. Components can be found in: lib/components (or the folder specified in fcnui.json)
import 'package:example/components/button.dart';
import 'package:example/components/card.dart';
import 'package:fcnui_base/fcnui_base.dart';
import 'package:flutter/material.dart';

void main() {
  /// 1. Wrap your app with [DefaultStoreProvider]
  runApp(DefaultStoreProvider(child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(useMaterial3: true),
      darkTheme: ThemeData(useMaterial3: true, brightness: Brightness.dark),
      themeMode: ThemeMode.system,
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            /// 2. Use fcnui components ex:[DefaultButton]
            DefaultButton(
              variant: PrimaryButtonVariant(
                onPressed: () {
                  ChangeFlexSchemeAction(flexScheme: FlexScheme.wasabi.name)
                      .payload();
                },
                text: "Increment",
                icon: Icons.add,
              ),
            ),

            const DefaultCard(
              variant: CardVariant(
                  title: CardTitle(title: "Hello"),
                  content: CardContent(content: Text("Context")),
                  footer: CardFooter(footer: [])),
            ),
          ],
        ).spaced(20),
      ),
    );
  }
}

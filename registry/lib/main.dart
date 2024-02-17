// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:fcnui_base/fcnui_base.dart';
import 'package:go_router/go_router.dart';
import 'package:registry/ui/default_components/button.dart';
import 'package:registry/ui/default_components/card.dart';

import 'manager/manager.dart';
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
        theme: ThemeData(),
        darkTheme: ThemeData(brightness: Brightness.dark),
        // theme: FlexThemeData.light(scheme: vm.flexScheme),
        // darkTheme: FlexThemeData.dark(scheme: vm.flexScheme),
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
    return ThemeProvider(
      builder: (context, vm) {
        return Scaffold(
          appBar: const DefaultAppBar(),
          body: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    DefaultButton(
                        variant: PrimaryButtonVariant(
                      text: "Button Page",
                      onPressed: () {
                        context.go(Uri(
                          path: "/button",
                        ).toString());
                      },
                    )),
                    DefaultButton(
                        variant: PrimaryButtonVariant(
                      text: "Default Card Page",
                      onPressed: () {
                        context.go(Uri(
                          path: "/card",
                        ).toString());
                      },
                    )),
                    DefaultButton(
                        variant: PrimaryButtonVariant(
                      text: "Custom Card Page",
                      onPressed: () {
                        context.go(Uri(path: "/card", queryParameters: {
                          "isCustom": "true",
                        }).toString());
                      },
                    )),
                    DefaultButton(
                        variant: PrimaryButtonVariant(
                      text: "Decorated Card Page",
                      onPressed: () {
                        context.go(Uri(path: "/card", queryParameters: {
                          "isDecorated": "true",
                        }).toString());
                      },
                    )),
                    ElevatedButton(
                        onPressed: () {
                          ChangeUsePlatformThemeAction(
                                  usePlatformTheme: !fcnGetIt
                                      .get<Store<AppState>>()
                                      .state
                                      .themeState
                                      .usePlatformTheme)
                              .payload();
                        },
                        child: Text(
                            "Use platform theme ${fcnGetIt.get<Store<AppState>>().state.themeState.usePlatformTheme}")),
                    // const Text("Default Card"),
                    // DefaultCard(
                    //   variant: CardVariant(
                    //     title: const CardTitle(title: "Create project"),
                    //     subtitle: const CardSubtitle(
                    //         subtitle: "Deploy your new project in one-click"),
                    //     content: CardContent(
                    //       content: Column(
                    //         children: [
                    //           TextFormField(
                    //             decoration: const InputDecoration(
                    //               border: OutlineInputBorder(),
                    //               labelText: "Project name",
                    //             ),
                    //           ),
                    //           TextFormField(
                    //             decoration: const InputDecoration(
                    //               border: OutlineInputBorder(),
                    //               labelText: "Deadline",
                    //             ),
                    //           ),
                    //           TextFormField(
                    //             decoration: const InputDecoration(
                    //               border: OutlineInputBorder(),
                    //               labelText: "Description",
                    //             ),
                    //           ),
                    //         ],
                    //       ).spaced(20),
                    //     ),
                    //     footer: CardFooter(
                    //       footer: [
                    //         DefaultButton(
                    //           variant: OutlineButtonVariant(
                    //             onPressed: () {},
                    //             text: "Cancel",
                    //           ),
                    //         ),
                    //         DefaultButton(
                    //           variant: PrimaryButtonVariant(
                    //             onPressed: () {},
                    //             text: "Deploy",
                    //           ),
                    //         ),
                    //       ],
                    //     ),
                    //   ),
                    // ),
                    // const Text("Custom Card"),
                    // DefaultCard(
                    //   custom: CardCustom(
                    //     widget: Column(
                    //         crossAxisAlignment: CrossAxisAlignment.start,
                    //         children: [
                    //           Text('Notification',
                    //               style: textTheme.displaySmall),
                    //           Text('You have 3 new notifications',
                    //               style: textTheme.labelLarge),
                    //           const SizedBox(height: 20),
                    //           DefaultCard(
                    //             custom: CardCustom(
                    //                 widget: Row(
                    //               crossAxisAlignment: CrossAxisAlignment.center,
                    //               mainAxisAlignment:
                    //                   MainAxisAlignment.spaceBetween,
                    //               children: [
                    //                 Row(
                    //                   children: [
                    //                     const Icon(
                    //                       Icons.notifications_active_outlined,
                    //                       size: 32,
                    //                     ),
                    //                     const SizedBox(width: 20),
                    //                     SizedBox(
                    //                       width: MediaQuery.of(context)
                    //                               .size
                    //                               .width *
                    //                           0.5,
                    //                       child: Column(
                    //                         crossAxisAlignment:
                    //                             CrossAxisAlignment.start,
                    //                         children: [
                    //                           Text('Push Notifications',
                    //                               style: textTheme.labelLarge),
                    //                           Text(
                    //                               'Send push notifications to your users',
                    //                               style: textTheme.labelMedium),
                    //                         ],
                    //                       ),
                    //                     ),
                    //                   ],
                    //                 ),
                    //                 Switch(
                    //                   value: false,
                    //                   onChanged: (value) {},
                    //                 ),
                    //               ],
                    //             ).spaced(10)),
                    //           ),
                    //           const SizedBox(height: 20),
                    //           DefaultButton(
                    //               variant: PrimaryButtonVariant(
                    //             backgroundColor: Colors.white,
                    //             foregroundColor: Colors.black,
                    //             minimumSize: const Size(double.infinity, 48),
                    //             onPressed: () {},
                    //             text: "Mark all as read",
                    //             icon: Icons.check,
                    //           )),
                    //         ]),
                    //   ),
                    // ),
                    // const Text("Decorated Card"),
                    // DefaultCard(
                    //   decoration: CardDecoration(
                    //     borderRadius: BorderRadius.circular(24),
                    //     border: Border.all(
                    //         color: colorScheme.error,
                    //         width: 2,
                    //         strokeAlign: BorderSide.strokeAlignInside),
                    //     color: colorScheme.error.withOpacity(0.2),
                    //   ),
                    //   variant: CardVariant(
                    //     title: const CardTitle(title: "Create project"),
                    //     subtitle: const CardSubtitle(
                    //         subtitle: "Deploy your new project in one-click"),
                    //     content: CardContent(
                    //       content: Column(
                    //         children: [
                    //           TextFormField(
                    //             decoration: const InputDecoration(
                    //               border: OutlineInputBorder(),
                    //               labelText: "Project name",
                    //             ),
                    //           ),
                    //           TextFormField(
                    //             decoration: const InputDecoration(
                    //               border: OutlineInputBorder(),
                    //               labelText: "Deadline",
                    //             ),
                    //           ),
                    //           TextFormField(
                    //             decoration: const InputDecoration(
                    //               border: OutlineInputBorder(),
                    //               labelText: "Description",
                    //             ),
                    //           ),
                    //         ],
                    //       ).spaced(20),
                    //     ),
                    //     footer: CardFooter(
                    //       footer: [
                    //         DefaultButton(
                    //           variant: OutlineButtonVariant(
                    //             onPressed: () {},
                    //             text: "Cancel",
                    //           ),
                    //         ),
                    //         DefaultButton(
                    //           variant: PrimaryButtonVariant(
                    //             onPressed: () {},
                    //             text: "Deploy",
                    //           ),
                    //         ),
                    //       ],
                    //     ),
                    //   ),
                    // ),
                  ],
                ).spaced(20),
              )),
        );
      },
    );
  }
}

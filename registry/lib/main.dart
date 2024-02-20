import 'package:fcnui_base/fcnui_base.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:registry/ui/default_components/button.dart';
import 'package:registry/ui/default_components/card.dart';
import 'package:registry/ui/default_components/checkbox.dart';
import 'package:registry/ui/default_components/dp_item.dart';
import 'package:registry/ui/default_components/form.dart';
import 'package:registry/ui/default_components/save_button.dart';
import 'package:registry/ui/default_components/with_label.dart';
import 'manager/manager.dart';
import 'ui/default_components/dropdown.dart';
import 'ui/default_components/input.dart';
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
                  DefaultDropdown(
                      variant: DropdownVariant(
                          name: "dp",
                          decoration: DpDecoration(
                            hintText: "Select an item",
                          ),
                          form: DpForm(
                              onChanged: print,
                              initialValue: "2",
                              hasSearchBox: true,
                              items: [
                                DropdownItem(groupTitle: "sdsdfdsd", items: [
                                  DpItem(
                                      title:
                                          "Item 1kdjsfhdjksfhkjdshfhgjkldshhfkjdsfgkdjshfghkhjdsfg",
                                      id: "1"),
                                  DpItem(
                                      title: "Item 2",
                                      id: "2",
                                      subtitle:
                                          "Hello worlddkjfhgfjdhgjkdfsahflkjasdhfkjldsahkl"),
                                  DpItem(title: "Item 3", id: "3"),
                                ]),
                              ])))
                ],
              ).spaced(20)),
        );
      },
    );
  }
}

class _Form extends StatelessWidget {
  _Form();

  final formModel = FormModel();
  @override
  Widget build(BuildContext context) {
    return DefaultForm(
      vm: formModel,
      child: WithLabel(
        labelVm: const LabelModel(text: "Username"),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DefaultInput(
              vm: InputModel(
                name: "username",
                hintText: "Username",
                helperText: "This is your public display name",
                validators: [
                  FormBuilderValidators.minLength(2,
                      errorText: 'Username must be at least 2 characters.'),
                ],
              ),
            ),
            SaveButton(
                vm: formModel,
                onSave: (value) {
                  if (formModel.isValid) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(formModel.getValues().toString())));
                  }
                },
                text: "Submit"),
          ],
        ).spaced(20),
      ),
    );
  }
}

class _CustomCard extends StatelessWidget {
  const _CustomCard({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return DefaultCard(
      custom: CardCustom(
        widget: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Notification', style: textTheme.displaySmall),
          Text('You have 3 new notifications', style: textTheme.labelLarge),
          const SizedBox(height: 20),
          DefaultCard(
            custom: CardCustom(
                widget: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.notifications_active_outlined,
                      size: 32,
                    ),
                    const SizedBox(width: 20),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.5,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Push Notifications',
                              style: textTheme.labelLarge),
                          Text('Send push notifications to your users',
                              style: textTheme.labelMedium),
                        ],
                      ),
                    ),
                  ],
                ),
                Switch(
                  value: false,
                  onChanged: (value) {},
                ),
              ],
            ).spaced(10)),
          ),
          const SizedBox(height: 20),
          DefaultButton(
              variant: PrimaryButtonVariant(
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            minimumSize: const Size(double.infinity, 48),
            onPressed: () {},
            text: "Mark all as read",
            icon: Icons.check,
          )),
        ]),
      ),
    );
  }
}

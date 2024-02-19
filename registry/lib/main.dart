import 'package:fcnui_base/fcnui_base.dart';
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
                                  usePlatformTheme: true)
                              .payload(),
                          text:
                              "Use platform theme ${fcnGetIt.get<Store<AppState>>().state.themeState.usePlatformTheme}")),
                  ElevatedButton(
                      onPressed: () {
                        context.go(Uri(path: "/checkbox").toString());
                      },
                      child: Text('Checkboxpage')),
                  const FormCheckbox(
                    vm: CheckboxModel(
                      name: "termsField",
                      items: [
                        DpItem(
                            id: "1",
                            title: "Accept terms and conditions",
                            subtitle:
                                "You agree to our Terms of Service and Privacy Policy."),
                      ],
                    ),
                  ),
                  const FormCheckbox(
                    vm: CheckboxModel(
                      name: "termsFieldDisabled",
                      enabled: false,
                      items: [
                        DpItem(id: "1", title: "Accept terms and conditions"),
                      ],
                    ),
                  ),
                  const DefaultCard(
                    decoration: CardDecoration(padding: EdgeInsets.all(16)),
                    custom: CardCustom(
                        widget: FormCheckbox(
                      vm: CheckboxModel(
                        name: "settingsField",
                        orientation: OptionsOrientation.vertical,
                        onChanged: print,
                        items: [
                          DpItem(
                            id: "settings",
                            title:
                                "Use different settings for my mobile devices",
                            subtitle:
                                "You can manage your mobile notifications in the mobile settings page.",
                          ),
                        ],
                      ),
                    )),
                  ),
                  DefaultForm(
                    vm: formModel,
                    child: FormCheckbox(
                      vm: CheckboxModel(
                        title: "Sidebar",
                        subtitle: "Select the items you want to display",
                        disabled: [
                          "3",
                          "2",
                        ],
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        helperText: "You have to select at least one item",
                        name: "termsForm",
                        orientation: OptionsOrientation.vertical,
                        validator: FormBuilderValidators.required(
                            errorText: 'You have to select at least one item'),
                        onChanged: print,
                        items: [
                          const DpItem(id: "1", title: "Recents"),
                          const DpItem(id: "2", title: "Home"),
                          const DpItem(id: "3", title: "Applications"),
                          const DpItem(id: "4", title: "Settings"),
                          const DpItem(id: "5", title: "About"),
                        ],
                      ),
                    ),
                  ),
                  SaveButton(vm: formModel, onSave: print),
                ],
              ).spaced(20)),
        );
      },
    );
  }
}

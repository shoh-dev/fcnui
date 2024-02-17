import 'package:fcnui_base/fcnui_base.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:registry/ui/default_components/button.dart';
import 'package:registry/ui/default_components/form/form.dart';
import 'package:registry/ui/default_components/form/label.dart';
import 'package:registry/ui/default_components/form/save_button.dart';
import 'package:registry/ui/default_components/form/with_label.dart';
import 'manager/manager.dart';
import 'ui/default_components/form/input.dart';
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
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    DefaultButton(
                        variant: PrimaryButtonVariant(
                      onPressed: () {
                        context.go(Uri(path: '/card', queryParameters: {
                          "isDecorated": "true",
                        }).toString());
                      },
                      text: "Card",
                    )),
                    DefaultButton(
                        variant: PrimaryButtonVariant(
                      onPressed: () {
                        context.go(Uri(path: '/input').toString());
                      },
                      text: "Input Page",
                    )),
                    DefaultButton(
                        variant: SecondaryButtonVariant(
                      onPressed: () {
                        ChangeUsePlatformThemeAction(
                                usePlatformTheme: !fcnGetIt
                                    .get<Store<AppState>>()
                                    .state
                                    .themeState
                                    .usePlatformTheme)
                            .payload();
                      },
                      text:
                          "Use platform theme ${fcnGetIt.get<Store<AppState>>().state.themeState.usePlatformTheme}",
                    )),
                    const DefaultInput(
                      vm: InputModel(
                        name: "email",
                        hintText: "Email",
                      ),
                    ),
                    const DefaultInput(
                      vm: InputModel(
                        name: "emailDisabled",
                        enabled: false,
                        hintText: "Email",
                      ),
                    ),
                    const WithLabel(
                        labelVm: LabelModel(text: "Email", enabled: true),
                        child: DefaultInput(
                            vm: InputModel(
                          name: "emailWithLabel",
                          hintText: "Email",
                        ))),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Expanded(
                          child: DefaultInput(
                              vm: InputModel(
                            name: "emailWithButton",
                            hintText: "Email",
                          )),
                        ),
                        SaveButton(
                            text: "Subscribe",
                            vm: formModel,
                            autoValidate: false,
                            onSave: print),
                      ],
                    ).spaced(10),

                    DefaultForm(
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
                                      errorText:
                                          'Username must be at least 2 characters.'),
                                ],
                              ),
                            ),
                            SaveButton(
                                vm: formModel,
                                onSave: (value) {
                                  if (formModel.isValid) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                            content: Text(formModel
                                                .getValues()
                                                .toString())));
                                  }
                                },
                                text: "Submit"),
                          ],
                        ).spaced(20),
                      ),
                    ),
                    // DefaultButton(
                    //     variant: PrimaryButtonVariant(
                    //   onPressed: () {
                    //     formModel.validate();
                    //     print(formModel.getValue("username"));
                    //   },
                    //   text: "Submit",
                    // )),
                  ],
                ).spaced(20),
              )),
        );
      },
    );
  }
}

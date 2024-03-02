import 'package:fcnui_base/fcnui_base.dart';
import 'package:flutter/material.dart';
import 'package:registry/pages/page_impl.dart';
import 'package:registry/ui/default_components/button.dart';
import 'package:registry/ui/default_components/card.dart';
import 'package:registry/ui/default_components/form.dart';
import 'package:registry/ui/snackbar.dart';
import '../ui/default_components/input.dart';
import '../ui/default_components/with_label.dart';

class CardPage extends PageImpl {
  final bool isCustom;
  final bool isDecorated;

  const CardPage({
    super.key,
    required this.isCustom,
    required this.isDecorated,
  });

  @override
  Widget preview(BuildContext context) {
    if (isCustom) {
      return const _CustomCard();
    } else if (isDecorated) {
      return _DecoratedCard();
    } else {
      return _DefaultCardWithForm();
    }
  }

  @override
  String getCode() {
    String code = """
    """;

    if (isCustom) {
      code = """
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
      """;
    } else if (isDecorated) {
      code = """
class _DecoratedCard extends StatelessWidget {
  _DecoratedCard({super.key});

  final formModel = FormModel();

  @override
  Widget build(BuildContext context) {
    return ThemeProvider(builder: (context, vm) {
      final colorScheme = vm.theme.colorScheme;
      return DefaultCard(
        decoration: CardDecoration(
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
              color: colorScheme.primaryContainer,
              width: 2,
              strokeAlign: BorderSide.strokeAlignInside),
          color: colorScheme.primaryContainer.withOpacity(0.2),
        ),
        variant: CardVariant(
          title: const CardTitle(title: "Create project"),
          subtitle: const CardSubtitle(
              subtitle: "Deploy your new project in one-click"),
          content: CardContent(
            content: DefaultForm(
              vm: formModel,
              child: Column(
                children: [
                  WithLabel(
                    labelVm: const LabelModel(text: "Name"),
                    child: DefaultInput(
                      vm: InputModel(
                        name: "name",
                        validators: [
                          FormBuilderValidators.required(),
                        ],
                        hintText: "Name of the project",
                      ),
                    ),
                  ),
                  const WithLabel(
                    labelVm: LabelModel(text: "Description"),
                    child: DefaultInput(
                      vm: InputModel(
                        name: "description",
                        hintText: "Description of the project",
                      ),
                    ),
                  ),
                ],
              ).spaced(20),
            ),
          ),
          footer: CardFooter(
            footer: [
              DefaultButton(
                variant: OutlineButtonVariant(
                  onPressed: () {},
                  text: "Cancel",
                ),
              ),
              SaveButton(
                  vm: formModel,
                  text: "Deploy",
                  onSave: (value) {
                    if (formModel.isValid) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(formModel.getValues().toString())));
                    }
                  })
            ],
          ),
        ),
      );
    });
  }
}
      """;
    } else {
      code = """
class _DefaultCardWithForm extends StatelessWidget {
  _DefaultCardWithForm();
  final formModel = FormModel();

  @override
  Widget build(BuildContext context) {
    return DefaultCard(
      variant: CardVariant(
        title: const CardTitle(title: "Create project"),
        subtitle: const CardSubtitle(
            subtitle: "Deploy your new project in one-click"),
        content: CardContent(
          content: DefaultForm(
            vm: formModel,
            child: Column(
              children: [
                WithLabel(
                  labelVm: const LabelModel(text: "Name"),
                  child: DefaultInput(
                    vm: InputModel(
                      name: "name",
                      validators: [
                        FormBuilderValidators.required(),
                      ],
                      hintText: "Name of the project",
                    ),
                  ),
                ),
                const WithLabel(
                  labelVm: LabelModel(text: "Description"),
                  child: DefaultInput(
                    vm: InputModel(
                      name: "description",
                      hintText: "Description of the project",
                    ),
                  ),
                ),
              ],
            ).spaced(20),
          ),
        ),
        footer: CardFooter(
          footer: [
            DefaultButton(
              variant: OutlineButtonVariant(
                onPressed: () {},
                text: "Cancel",
              ),
            ),
            SaveButton(
                vm: formModel,
                text: "Deploy",
                onSave: (value) {
                  if (formModel.isValid) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(formModel.getValues().toString())));
                  }
                })
          ],
        ),
      ),
    );
  }
}
      """;
    }
    return code;
  }
}

class _DefaultCardWithForm extends StatelessWidget {
  _DefaultCardWithForm();

  final formModel = FormModel();

  @override
  Widget build(BuildContext context) {
    return DefaultCard(decorationBuilder: (themeVm) {
      return CardDecoration(themeVm,
          child: CardChild(
            themeVm,
            title: const CardTitle(title: "Create project"),
            subtitle: const CardSubtitle(
                subtitle: "Deploy your new project in one-click"),
            content: CardContent(
                content: DefaultForm(
                    vm: formModel,
                    child: Column(children: [
                      WithLabel(
                          labelBuilder: (themeVm) => LabelDecoration(themeVm,
                              child: LabelChild(themeVm, text: "Name"),
                              state: LabelState(themeVm, isRequired: true)),
                          child: DefaultInput(
                              decorationBuilder: (themeVm) => InputDecor(
                                  themeVm,
                                  child: InputChild(themeVm,
                                      name: "name",
                                      hintText: "Name of the project"),
                                  value: InputValue(themeVm, validators: [
                                    FormBuilderValidators.required()
                                  ])))),
                      WithLabel(
                          labelBuilder: (themeVm) => LabelDecoration(themeVm,
                              child: LabelChild(themeVm, text: "Description")),
                          child: DefaultInput(
                              decorationBuilder: (themeVm) => InputDecor(
                                  themeVm,
                                  child: InputChild(themeVm,
                                      name: "description",
                                      hintText: "Description of the project"))))
                    ]).spaced(20))),
            footer: CardFooter(
              footer: [
                DefaultButton(
                  decorationBuilder: (context, type) {
                    return ButtonDecoration(
                      context,
                      type: type,
                      child: ButtonChild(context, text: "Cancel"),
                      action: ButtonAction(context, onPressed: () {}),
                    );
                  },
                ),
                DefaultButton(
                    decorationBuilder: (themeVm, type) =>
                        ButtonDecoration(themeVm,
                            type: type,
                            action: ButtonAction(themeVm, onPressed: () {
                              if (formModel.isValid) {
                                showSnackbar(context, formModel.getValues());
                              }
                            }),
                            child: ButtonChild(themeVm, text: "Deploy")))
              ],
            ),
          ));
    });
  }
}

class _CustomCard extends StatelessWidget {
  const _CustomCard();

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return DefaultCard(
      decorationBuilder: (themeVm) => CardDecoration(themeVm,
          child: CardChild(themeVm,
              custom: CardCustom(
                widget: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Notification', style: textTheme.displaySmall),
                      Text('You have 3 new notifications',
                          style: textTheme.labelLarge),
                      const SizedBox(height: 20),
                      DefaultCard(
                          decorationBuilder: (themeVm) => CardDecoration(
                              themeVm,
                              child: CardChild(themeVm,
                                  custom: CardCustom(
                                      widget: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          const Icon(
                                            Icons.notifications_active_outlined,
                                            size: 32,
                                          ),
                                          const SizedBox(width: 20),
                                          SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.5,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text('Push Notifications',
                                                    style:
                                                        textTheme.labelLarge),
                                                Text(
                                                    'Send push notifications to your users',
                                                    style:
                                                        textTheme.labelMedium),
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
                                  ).spaced(10))))),
                      const SizedBox(height: 20),
                      DefaultButton(decorationBuilder: (context, type) {
                        return ButtonDecoration(
                          context,
                          type: type,
                          child: ButtonChild(context,
                              text: "Mark all as read", icon: Icons.check),
                          action: ButtonAction(context, onPressed: () {}),
                          color: ButtonColor(context,
                              type: type,
                              background: Colors.white,
                              foreground: Colors.black),
                          size: ButtonSize(context, type,
                              minimumSize: const Size(double.infinity, 48)),
                        );
                      }),
                    ]),
              ))),
    );
  }
}

class _DecoratedCard extends StatelessWidget {
  _DecoratedCard();

  final formModel = FormModel();

  @override
  Widget build(BuildContext context) {
    return ThemeProvider(builder: (context, vm) {
      final colorScheme = vm.theme.colorScheme;
      return DefaultCard(
        decorationBuilder: (themeVm) {
          return CardDecoration(themeVm,
              border: CardBorder(themeVm,
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide(
                      color: colorScheme.primaryContainer,
                      width: 2,
                      strokeAlign: BorderSide.strokeAlignInside)),
              color: CardColor(themeVm,
                  background: colorScheme.primaryContainer.withOpacity(0.2)),
              child: CardChild(
                themeVm,
                title: const CardTitle(title: "Create project"),
                subtitle: const CardSubtitle(
                    subtitle: "Deploy your new project in one-click"),
                content: CardContent(
                    content: DefaultForm(
                        vm: formModel,
                        child: Column(children: [
                          WithLabel(
                              labelBuilder: (context) => LabelDecoration(
                                  context,
                                  child: LabelChild(context, text: "Name"),
                                  state: LabelState(context, isRequired: true)),
                              child: DefaultInput(
                                  decorationBuilder: (themeVm) => InputDecor(
                                      themeVm,
                                      child: InputChild(themeVm,
                                          name: "name",
                                          hintText: "Name of the project"),
                                      value: InputValue(themeVm, validators: [
                                        FormBuilderValidators.required()
                                      ])))),
                          WithLabel(
                              labelBuilder: (themeVm) => LabelDecoration(
                                  themeVm,
                                  child:
                                      LabelChild(themeVm, text: "Description")),
                              child: DefaultInput(
                                  decorationBuilder: (themeVm) => InputDecor(
                                        themeVm,
                                        child: InputChild(themeVm,
                                            name: "description",
                                            hintText:
                                                "Description of the project"),
                                      )))
                        ]).spaced(20))),
                footer: CardFooter(
                  footer: [
                    DefaultButton(decorationBuilder: (context, type) {
                      return ButtonDecoration(
                        context,
                        type: type,
                        child: ButtonChild(context, text: "Cancel"),
                        action: ButtonAction(context, onPressed: () {}),
                      );
                    }),
                    DefaultButton(
                        decorationBuilder: (themeVm, type) => ButtonDecoration(
                            themeVm,
                            type: type,
                            action: ButtonAction(themeVm, onPressed: () {
                              if (formModel.isValid) {
                                showSnackbar(context, formModel.getValues());
                              }
                            }),
                            child: ButtonChild(themeVm, text: "Deploy")))
                  ],
                ),
              ));
        },
      );
    });
  }
}

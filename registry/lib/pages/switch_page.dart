import 'package:fcnui_base/fcnui_base.dart';
import 'package:flutter/material.dart';
import 'package:registry/pages/page_impl.dart';
import 'package:registry/ui/default_components/button.dart';
import 'package:registry/ui/default_components/card.dart';
import 'package:registry/ui/default_components/form.dart';
import 'package:registry/ui/default_components/switch.dart';
import 'package:registry/ui/snackbar.dart';

enum SwitchVariant {
  withTitle,
  decorated,
  form,
}

class SwitchPage extends PageImpl {
  final SwitchVariant variant;

  const SwitchPage({
    super.key,
    required this.variant,
  });

  @override
  String getCode() {
    return switch (variant) {
      (SwitchVariant.withTitle) => '''
class _WithTitle extends StatelessWidget {
  const _WithTitle();

  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        DefaultSwitch(
          vm: SwitchModel(
            name: "switch",
            decoration: SwitchDecoration(
              title: "With title",
            ),
          ),
        ),
        DefaultSwitch(
          vm: SwitchModel(
            name: "switch",
            decoration: SwitchDecoration(
              title: "With subtitle",
              subtitle: "Turn on while flying",
            ),
          ),
        ),
      ],
    ).spaced(20);
  }
}
      ''',
      (SwitchVariant.decorated) => '''
class _Decorated extends StatelessWidget {
  const _Decorated();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const DefaultSwitch(
          vm: SwitchModel(
            name: "switch",
            decoration: SwitchDecoration(
              title: "Airplane mode",
              thumbActiveColor: Colors.red,
              thumbInactiveColor: Colors.blue,
              trackActiveColor: Colors.green,
              trackInactiveColor: Colors.yellow,
              thumbActiveIcon: Icons.airplanemode_active,
              thumbInactiveIcon: Icons.airplanemode_inactive,
              width: 100,
              height: 50,
            ),
          ),
        ),
        //another switch with unique decoration other than the first one
        DefaultSwitch(
          vm: SwitchModel(
            name: "switch",
            decoration: SwitchDecoration(
              title: "Sound on/off",
              trackInactiveColor: Theme.of(context).colorScheme.secondary,
              trackActiveColor: Theme.of(context).primaryColor,
              thumbActiveIcon: Icons.volume_up,
              thumbInactiveIcon: Icons.volume_off,
              width: 50,
              height: 25,
            ),
          ),
        ),
      ],
    ).spaced(20);
  }
}
''',
      (SwitchVariant.form) => '''
class _Form extends StatelessWidget {
  _Form();

  final formModel = FormModel();

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return DefaultForm(
      vm: formModel,
      child: DefaultCard(
        custom: CardCustom(
          widget:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
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
                                style: textTheme.labelLarge!.copyWith(
                                  fontWeight: FontWeight.bold,
                                )),
                            Text('Send push notifications to your users',
                                style: textTheme.labelMedium),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const DefaultSwitch(
                      vm: SwitchModel(name: "pushNotifications")),
                ],
              ).spaced(10)),
            ),
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
                        Icons.email,
                        size: 32,
                      ),
                      const SizedBox(width: 20),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.5,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Marketing Emails',
                                style: textTheme.labelLarge!.copyWith(
                                  fontWeight: FontWeight.bold,
                                )),
                            Text('Receive marketing emails from us',
                                style: textTheme.labelMedium),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const DefaultSwitch(vm: SwitchModel(name: "marketingEmails")),
                ],
              ).spaced(10)),
            ),
            const SizedBox(height: 20),
            DefaultSwitch(
                vm: SwitchModel(
                    name: "checkAll",
                    decoration: const SwitchDecoration(
                      title: "Check all required switches",
                    ),
                    form: SwitchForm(
                      onChanged: (value) {
                        formModel.patchValue({
                          "pushNotifications": value,
                        });
                      },
                      validator: (p0) {
                        //check if all switches are on
                        if (formModel.getValue("pushNotifications") == false) {
                          return "Please check all required switches";
                        }
                        return null;
                      },
                    ))),
            const SizedBox(height: 20),
            DefaultButton(
                variant: PrimaryButtonVariant(
              minimumSize: const Size(double.infinity, 48),
              onPressed: () {
                formModel.saveAndValidate();
                if (!formModel.formKey.currentState!.validate()) return;
                showSnackbar(themeVm, formModel.getValues());
              },
              text: "Mark all as read",
              icon: Icons.check,
            )),
          ]),
        ),
      ),
    );
  }
}
''',
    };
  }

  @override
  Widget preview(BuildContext themeVm) {
    return switch (variant) {
      (SwitchVariant.withTitle) => const _WithTitle(),
      (SwitchVariant.decorated) => const _Decorated(),
      (SwitchVariant.form) => _Form(),
    };
  }
}

class _WithTitle extends StatelessWidget {
  const _WithTitle();

  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        DefaultSwitch(
          vm: SwitchModel(
            name: "switch",
            decoration: SwitchDecoration(
              title: "With title",
            ),
          ),
        ),
        DefaultSwitch(
          vm: SwitchModel(
            name: "switch",
            decoration: SwitchDecoration(
              title: "With subtitle",
              subtitle: "Turn on while flying",
            ),
          ),
        ),
      ],
    ).spaced(20);
  }
}

class _Decorated extends StatelessWidget {
  const _Decorated();

  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        DefaultSwitch(
          vm: SwitchModel(
            name: "switch",
            decoration: SwitchDecoration(
              title: "Airplane mode",
              thumbActiveColor: Colors.red,
              thumbInactiveColor: Colors.blue,
              trackActiveColor: Colors.green,
              trackInactiveColor: Colors.yellow,
              thumbActiveIcon: Icons.airplanemode_active,
              thumbInactiveIcon: Icons.airplanemode_inactive,
              width: 100,
              height: 50,
            ),
          ),
        ),
        //another switch with unique decoration other than the first one
        DefaultSwitch(
          vm: SwitchModel(
            name: "switch",
            decoration: SwitchDecoration(
              title: "Sound on/off",
              subtitle: "Disabled",
              enabled: false,
              thumbActiveIcon: Icons.volume_up,
              thumbInactiveIcon: Icons.volume_off,
              width: 50,
              height: 25,
            ),
          ),
        ),
      ],
    ).spaced(20);
  }
}

class _Form extends StatelessWidget {
  _Form();

  final formModel = FormModel();

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return DefaultForm(
      vm: formModel,
      child: DefaultCard(
        decorationBuilder: (themeVm) => CardDecoration(themeVm,
            child: CardChild(
              themeVm,
              custom: CardCustom(
                widget: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Notification', style: textTheme.displaySmall),
                      Text('You have 3 new notifications',
                          style: textTheme.labelLarge),
                      const SizedBox(height: 20),
                      DefaultCard(
                        decorationBuilder: (themeVm) {
                          return CardDecoration(themeVm,
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
                                                    style: textTheme.labelLarge!
                                                        .copyWith(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    )),
                                                Text(
                                                    'Send push notifications to your users',
                                                    style:
                                                        textTheme.labelMedium),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      const DefaultSwitch(
                                          vm: SwitchModel(
                                              name: "pushNotifications")),
                                    ],
                                  ).spaced(10))));
                        },
                      ),
                      const SizedBox(height: 20),
                      DefaultCard(
                        decorationBuilder: (themeVm) {
                          return CardDecoration(themeVm,
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
                                            Icons.email,
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
                                                Text('Marketing Emails',
                                                    style: textTheme.labelLarge!
                                                        .copyWith(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    )),
                                                Text(
                                                    'Receive marketing emails from us',
                                                    style:
                                                        textTheme.labelMedium),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      const DefaultSwitch(
                                          vm: SwitchModel(
                                              name: "marketingEmails")),
                                    ],
                                  ).spaced(10))));
                        },
                      ),
                      const SizedBox(height: 20),
                      DefaultSwitch(
                          vm: SwitchModel(
                              name: "checkAll",
                              decoration: const SwitchDecoration(
                                title: "Check all required switches",
                              ),
                              form: SwitchForm(
                                onChanged: (value) {
                                  formModel.patchValue({
                                    "pushNotifications": value,
                                  });
                                },
                                validator: (p0) {
                                  //check if all switches are on
                                  if (formModel.getValue("pushNotifications") ==
                                      false) {
                                    return "Please check all required switches";
                                  }
                                  return null;
                                },
                              ))),
                      const SizedBox(height: 20),
                      DefaultButton(decorationBuilder: (themeVm, type) {
                        return ButtonDecoration(
                          themeVm,
                          type: type,
                          color: ButtonColor(themeVm, type: type),
                          action: ButtonAction(themeVm, onPressed: () {
                            formModel.saveAndValidate();
                            if (!formModel.formKey.currentState!.validate())
                              return;
                            showSnackbar(context, formModel.getValues());
                          }),
                          child: ButtonChild(themeVm,
                              icon: Icons.check, text: "Mark all as read"),
                          size: ButtonSize(themeVm, type,
                              minimumSize: const Size(double.infinity, 48)),
                        );
                      }),
                    ]),
              ),
            )),
      ),
    );
  }
}

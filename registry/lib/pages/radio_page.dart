import 'package:fcnui_base/fcnui_base.dart';
import 'package:flutter/material.dart';
import 'package:registry/pages/page_impl.dart';
import 'package:registry/ui/default_components/button.dart';
import 'package:registry/ui/default_components/dp_item.dart';
import 'package:registry/ui/default_components/form.dart';
import 'package:registry/ui/default_components/radio.dart';
import 'package:registry/ui/snackbar.dart';

enum RadioVariant {
  idle,
  form,
}

class RadioPage extends PageImpl {
  final RadioVariant variant;

  const RadioPage({
    super.key,
    required this.variant,
  });

  @override
  String getCode() {
    return switch (variant) {
      (RadioVariant.idle) => '''
class _Idle extends StatelessWidget {
  const _Idle();

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
      (RadioVariant.form) => '''
class _Form extends StatelessWidget {
  _Form();

  final formModel = FormModel();

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(themeVm).textTheme;
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
                        width: MediaQuery.of(themeVm).size.width * 0.5,
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
                        width: MediaQuery.of(themeVm).size.width * 0.5,
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
  Widget preview(BuildContext context) {
    return switch (variant) {
      (RadioVariant.idle) => const _Idle(),
      (RadioVariant.form) => _Form(),
    };
  }
}

class _Idle extends StatelessWidget {
  const _Idle();

  @override
  Widget build(BuildContext context) {
    return DefaultRadio(
        decorationBuilder: (themeVm) => RadioDecoration(themeVm,
            value: RadioValue(themeVm, name: "radio", items: const [
              DpItem(id: 'default', title: "Default"),
              DpItem(id: 'disabled', title: "Disabled"),
              DpItem(id: 'comfortable', title: "Comfortable"),
              DpItem(id: 'compact', title: "Compact"),
            ], disabledItems: [
              'disabled',
            ]),
            action: RadioAction(
              themeVm,
              onChanged: (value) {
                showSnackbar(context, value);
              },
            ),
            child: RadioChild(
              themeVm,
              title: "Select your favorite city",
            )));
  }
}

class _Form extends StatelessWidget {
  _Form();

  final formModel = FormModel();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        DefaultForm(
          vm: formModel,
          child: DefaultRadio(
              decorationBuilder: (themeVm) => RadioDecoration(themeVm,
                  value: RadioValue(
                    themeVm,
                    name: "radio",
                    items: const [
                      DpItem(id: 'buenosAires', title: "Buenos Aires"),
                      DpItem(
                        id: 'newYork',
                        title: "New York",
                        subtitle: "Not available",
                      ),
                      DpItem(id: 'paris', title: "Paris"),
                      DpItem(id: 'rome', title: "Rome"),
                    ],
                    validator: (v) {
                      if (v == null) {
                        return "Please select a city";
                      }
                      return null;
                    },
                    disabledItems: [
                      'newYork',
                    ],
                  ),
                  child:
                      RadioChild(themeVm, title: "Select your favorite city"),
                  action: RadioAction(
                    themeVm,
                    onChanged: (value) {
                      formModel.patchValue({
                        "radio": value,
                      });
                    },
                  ))),
        ),
        DefaultButton(
            decorationBuilder: (themeVm, type) => ButtonDecoration(themeVm,
                type: type,
                action: ButtonAction(themeVm, onPressed: () {
                  if (!formModel.formKey.currentState!.validate()) return;
                  showSnackbar(context, formModel.getValues());
                }),
                child: ButtonChild(themeVm, text: "Save")))
      ],
    ).spaced(20);
  }
}

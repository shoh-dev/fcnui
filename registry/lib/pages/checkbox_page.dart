import 'package:fcnui_base/fcnui_base.dart';
import 'package:flutter/material.dart';
import 'package:registry/pages/page_impl.dart';
import 'package:registry/ui/default_components/card.dart';
import 'package:registry/ui/default_components/checkbox.dart';
import 'package:registry/ui/default_components/dp_item.dart';
import 'package:registry/ui/default_components/form.dart';
import 'package:registry/ui/default_components/save_button.dart';

enum CheckboxVariant {
  withLabel,
  disabled,
  form,
  card,
}

class CheckboxPage extends PageImpl {
  final CheckboxVariant variant;

  const CheckboxPage({super.key, required this.variant});

  @override
  String getCode() {
    return switch (variant) {
      (CheckboxVariant.withLabel) => '''
class _WithLabel extends StatelessWidget {
  const _WithLabel();

  @override
  Widget build(BuildContext context) {
    return const DefaultCheckbox(
      vm: CheckboxModel(
        name: "withLabel",
        items: [
          DpItem(
              id: "1",
              title: "Accept terms and conditions",
              subtitle:
                  "You agree to our Terms of Service and Privacy Policy."),
        ],
      ),
    );
  }
}
      ''',
      (CheckboxVariant.disabled) => '''
class _Disabled extends StatelessWidget {
  const _Disabled();

  @override
  Widget build(BuildContext context) {
    return const DefaultCheckbox(
      vm: CheckboxModel(
        name: "disabled",
        enabled: false,
        items: [
          DpItem(id: "1", title: "Accept terms and conditions"),
        ],
      ),
    );
  }
}
      ''',
      (CheckboxVariant.form) => '''
class _Form extends StatelessWidget {
  _Form();

  final formModel = FormModel();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DefaultForm(
          vm: formModel,
          child: DefaultCheckbox(
            vm: CheckboxModel(
              title: "Sidebar",
              subtitle: "Select the items you want to display",
              disabled: const [
                "home",
                "apps",
              ],
              autovalidateMode: AutovalidateMode.onUserInteraction,
              helperText: "You have to select at least one item",
              name: "termsForm",
              orientation: OptionsOrientation.vertical,
              validator: FormBuilderValidators.required(
                  errorText: 'You have to select at least one item'),
              onChanged: print,
              items: const [
                DpItem(id: "recents", title: "Recents"),
                DpItem(id: "home", title: "Home"),
                DpItem(id: "apps", title: "Applications"),
                DpItem(id: "settings", title: "Settings"),
                DpItem(id: "about", title: "About"),
              ],
            ),
          ),
        ),
        SaveButton(
            vm: formModel,
            onSave: (value) {
              if (formModel.isValid) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(value.toString())),
                );
              }
            }),
      ],
    ).spaced(20);
  }
}
      ''',
      (CheckboxVariant.card) => '''
class _Card extends StatelessWidget {
  const _Card();

  @override
  Widget build(BuildContext context) {
    return const DefaultCard(
      decoration: CardDecoration(padding: EdgeInsets.all(16)),
      custom: CardCustom(
          widget: DefaultCheckbox(
        vm: CheckboxModel(
          name: "settingsField",
          orientation: OptionsOrientation.vertical,
          items: [
            DpItem(
              id: "settings",
              title: "Use different settings for my mobile devices",
              subtitle:
                  "You can manage your mobile notifications in the mobile settings page.",
            ),
          ],
        ),
      )),
    );
  }
}
      ''',
    };
  }

  @override
  Widget preview(BuildContext context) {
    return switch (variant) {
      (CheckboxVariant.withLabel) => const _WithLabel(),
      (CheckboxVariant.disabled) => const _Disabled(),
      (CheckboxVariant.form) => _Form(),
      (CheckboxVariant.card) => const _Card(),
    };
  }
}

class _WithLabel extends StatelessWidget {
  const _WithLabel();

  @override
  Widget build(BuildContext context) {
    return DefaultCheckbox(
      decorationBuilder: (themeVm) => CheckboxDecoration(
        themeVm,
        value: CheckboxValue(themeVm, name: "withLabel", items: [
          const DpItem(
              id: "1",
              title: "Accept terms and conditions",
              subtitle:
                  "You agree to our Terms of Service and Privacy Policy."),
        ]),
      ),
    );
  }
}

class _Disabled extends StatelessWidget {
  const _Disabled();

  @override
  Widget build(BuildContext context) {
    return DefaultCheckbox(
        decorationBuilder: (themeVm) => CheckboxDecoration(themeVm,
            value: CheckboxValue(themeVm, name: "disabled", items: [
              const DpItem(id: "1", title: "Accept terms and conditions"),
            ]),
            state: CheckboxState(themeVm, isDisabled: true)));
  }
}

class _Form extends StatelessWidget {
  _Form();

  final formModel = FormModel();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DefaultForm(
          vm: formModel,
          child: DefaultCheckbox(
            decorationBuilder: (themeVm) => CheckboxDecoration(
              themeVm,
              value: CheckboxValue(themeVm,
                  name: "termsForm",
                  disabledItems: const [
                    "home",
                    "apps",
                  ],
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: FormBuilderValidators.required(
                      errorText: 'You have to select at least one item'),
                  items: const [
                    DpItem(id: "recents", title: "Recents"),
                    DpItem(id: "home", title: "Home"),
                    DpItem(id: "apps", title: "Applications"),
                    DpItem(id: "settings", title: "Settings"),
                    DpItem(id: "about", title: "About"),
                  ]),
              action: CheckboxAction(themeVm, onChanged: print),
              child: CheckboxChild(
                themeVm,
                title: "Sidebar",
                subtitle: "Select the items you want to display",
                helperText: "You have to select at least one item",
                orientation: OptionsOrientation.vertical,
              ),
            ),
          ),
        ),
        SaveButton(
            vm: formModel,
            onSave: (value) {
              if (formModel.isValid) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(value.toString())),
                );
              }
            }),
      ],
    ).spaced(20);
  }
}

class _Card extends StatelessWidget {
  const _Card();

  @override
  Widget build(BuildContext context) {
    return DefaultCard(
      decorationBuilder: (context) {
        return CardDecoration(context,
            size: CardSize(context, padding: const EdgeInsets.all(16)),
            child: CardChild(context,
                custom: CardCustom(
                    widget: DefaultCheckbox(
                        decorationBuilder: (themeVm) => CheckboxDecoration(
                            themeVm,
                            value: CheckboxValue(themeVm,
                                name: "settingsField",
                                items: [
                                  const DpItem(
                                      id: "settings",
                                      title:
                                          "Use different settings for my mobile devices",
                                      subtitle:
                                          "You can manage your mobile notifications in the mobile settings page.")
                                ]),
                            child: CheckboxChild(themeVm,
                                orientation: OptionsOrientation.vertical))))));
      },
    );
  }
}

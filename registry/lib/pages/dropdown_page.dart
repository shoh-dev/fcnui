import 'package:fcnui_base/fcnui_base.dart';
import 'package:flutter/material.dart';
import 'package:registry/pages/page_impl.dart';
import 'package:registry/ui/default_components/dp_item.dart';
import 'package:registry/ui/default_components/dropdown.dart';
import 'package:registry/ui/default_components/form.dart';
import 'package:registry/ui/default_components/save_button.dart';
import 'package:registry/ui/default_components/with_label.dart';
import 'package:registry/ui/snackbar.dart';

enum DpVariant {
  form,
  decorated,
  disabled,
  disabledItems,
  withIcons,
  search,
  group,
}

class DropdownPage extends PageImpl {
  final DpVariant variant;

  const DropdownPage({super.key, required this.variant});

  @override
  String getCode() {
    return switch (variant) {
      DpVariant.form => r'''
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
          child: WithLabel(
            labelVm: const LabelModel(text: "Email"),
            child: DefaultDropdown(
                variant: DropdownVariant(
              name: "email",
              decoration: const DpDecoration(
                hintText: "Select a verified email",
                helperText:
                    "You can manage email addresses in your email settings.",
              ),
              form: DpForm(
                  onChanged: (_) {},
                  validator: FormBuilderValidators.required(),
                  items: [
                    DropdownItem(items: [
                      for (int i = 0; i < 5; i++)
                        DpItem(id: "$i@mail.com", title: "$i@mail.com")
                    ]),
                  ]),
            )),
          ),
        ),
        SaveButton(
          vm: formModel,
          text: "Submit",
          onSave: (value) {
            if (formModel.isValid) {
              showSnackbar(context, value);
            }
          },
        ),
      ],
    ).spaced(20);
  }
}
    ''',
      DpVariant.decorated => r'''
class _Decorated extends StatelessWidget {
  const _Decorated();

  @override
  Widget build(BuildContext context) {
    return ThemeProvider(builder: (context, vm) {
      final theme = vm.theme;
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          DefaultDropdown(
              variant: DropdownVariant(
                  name: "name",
                  decoration: const DpDecoration(
                    hintText: "Select a name",
                  ),
                  form: DpForm(
                      onChanged: (p0) {
                        showSnackbar(context, p0);
                      },
                      items: const [
                        DropdownItem(items: [
                          DpItem(title: "John", id: "john"),
                          DpItem(title: "Doe", id: "doe"),
                          DpItem(title: "Jane", id: "jane"),
                        ]),
                      ]))),
          DefaultDropdown(
              variant: DropdownVariant(
                  name: "fruits",
                  decoration: DpDecoration(
                    backgroundColor: theme.colorScheme.primary.withOpacity(.1),
                    foregroundColor: theme.colorScheme.primary,
                    icon: Icons.apple,
                    hintText: "Select a fruit",
                  ),
                  form: DpForm(
                      onChanged: (p0) {
                        showSnackbar(context, p0);
                      },
                      items: const [
                        DropdownItem(items: [
                          DpItem(title: "Apple", id: "apple"),
                          DpItem(title: "Banana", id: "banana"),
                          DpItem(title: "Orange", id: "orange"),
                          DpItem(title: "Pineapple", id: "pineapple"),
                          DpItem(title: "Grapes", id: "grapes"),
                        ]),
                      ]))),
          DefaultDropdown(
              variant: DropdownVariant(
                  name: "animals",
                  decoration: DpDecoration(
                    backgroundColor:
                        theme.colorScheme.secondary.withOpacity(.1),
                    foregroundColor: theme.colorScheme.secondary,
                    icon: Icons.pets,
                    hintText: "Select an animal",
                  ),
                  form: DpForm(
                      onChanged: (p0) {
                        showSnackbar(context, p0);
                      },
                      items: const [
                        DropdownItem(items: [
                          DpItem(title: "Dog", id: "dog"),
                          DpItem(title: "Cat", id: "cat"),
                          DpItem(title: "Rabbit", id: "rabbit"),
                          DpItem(title: "Tiger", id: "tiger"),
                          DpItem(title: "Lion", id: "lion"),
                        ]),
                      ]))),
          DefaultDropdown(
              variant: DropdownVariant(
                  name: "country",
                  decoration: DpDecoration(
                    backgroundColor: theme.colorScheme.tertiary.withOpacity(.1),
                    foregroundColor: theme.colorScheme.tertiary,
                    icon: Icons.flag,
                    hintText: "Select a country",
                  ),
                  form: DpForm(
                      onChanged: (p0) {
                        showSnackbar(context, p0);
                      },
                      items: const [
                        DropdownItem(items: [
                          DpItem(title: "Australia", id: "aus"),
                          DpItem(title: "Bangladesh", id: "bng"),
                          DpItem(title: "UK", id: "uk"),
                          DpItem(title: "USA", id: "usa"),
                          DpItem(title: "Uzbekistan", id: "uzb"),
                        ]),
                      ]))),
        ],
      ).spaced(20);
    });
  }
}
''',
      DpVariant.disabled => r'''
class _Disabled extends StatelessWidget {
  const _Disabled({super.key});

  @override
  Widget build(BuildContext context) {
    return WithLabel(
        labelVm: const LabelModel(text: "Helper"),
        child: DefaultDropdown(
            variant: DropdownVariant(
                name: "name",
                decoration: const DpDecoration(
                  hintText: "Select a country",
                  helperText: "Favorite country",
                ),
                form: DpForm(items: _items))));
  }
}
''',
      DpVariant.disabledItems => r'''
class _DisabledItems extends StatelessWidget {
  const _DisabledItems({super.key});

  @override
  Widget build(BuildContext context) {
    return WithLabel(
        labelVm: const LabelModel(text: "Helper"),
        child: DefaultDropdown(
            variant: DropdownVariant(
                name: "name",
                disabledItems: [
                  "usa",
                  "uk",
                ],
                decoration: const DpDecoration(
                  hintText: "Select a country",
                  helperText: "Favorite country",
                ),
                form: DpForm(
                  onChanged: (p0) {
                    showSnackbar(context, p0);
                  },
                  items: _items,
                ))));
  }
}
''',
      DpVariant.withIcons => r'''
class _WithIcons extends StatelessWidget {
  const _WithIcons({super.key});

  @override
  Widget build(BuildContext context) {
    return WithLabel(
        labelVm: const LabelModel(text: "With icons"),
        child: DefaultDropdown(
            variant: DropdownVariant(
                name: "name",
                decoration: const DpDecoration(hintText: "Select a country"),
                form: DpForm(
                    items: _items
                        .map((e) => e.copyWith(
                            items: e.items
                                .map((e) => e.copyWith(icon: Icons.flag))
                                .toList()))
                        .toList(),
                    onChanged: (p0) {
                      showSnackbar(context, p0);
                    }))));
  }
}
''',
      DpVariant.search => r'''
class _Search extends StatelessWidget {
  const _Search({super.key});

  @override
  Widget build(BuildContext context) {
    return WithLabel(
        labelVm: const LabelModel(text: "Search"),
        child: DefaultDropdown(
            variant: DropdownVariant(
                name: "name",
                decoration: const DpDecoration(
                  hintText: "Select a country",
                  hasSearchBox: true,
                ),
                form: DpForm(
                    items: _items
                        .map((e) => e.copyWith(
                            items: e.items
                                .map((e) => e.copyWith(icon: Icons.flag))
                                .toList()))
                        .toList(),
                    onChanged: (p0) {
                      showSnackbar(context, p0);
                    }))));
  }
}
''',
      DpVariant.group => r'''
class _Group extends StatelessWidget {
  const _Group();

  @override
  Widget build(BuildContext context) {
    return WithLabel(
        labelVm: const LabelModel(text: "Group"),
        child: DefaultDropdown(
            variant: DropdownVariant(
                name: "name",
                decoration: const DpDecoration(
                  hintText: "Select a country",
                  hasSearchBox: true,
                ),
                form: DpForm(
                    items: const [
                      DropdownItem(
                        groupTitle: "Asia",
                        groupIcon: Icons.east,
                        items: [
                          DpItem(title: "Bangladesh", id: "bng"),
                          DpItem(title: "Uzbekistan", id: "uzb"),
                        ],
                      ),
                      DropdownItem(
                        groupTitle: "Europe",
                        groupIcon: Icons.west,
                        items: [
                          DpItem(title: "UK", id: "uk"),
                          DpItem(title: "Spain", id: "spn"),
                          DpItem(title: "Germany", id: "ger"),
                        ],
                      ),
                      DropdownItem(
                        groupTitle: "America",
                        groupIcon: Icons.west,
                        items: [
                          DpItem(title: "USA", id: "usa"),
                          DpItem(title: "Canada", id: "can"),
                          DpItem(title: "Mexico", id: "mex"),
                        ],
                      ),
                      DropdownItem(
                        groupTitle: "Africa",
                        groupIcon: Icons.south,
                        items: [
                          DpItem(title: "Nigeria", id: "nga"),
                          DpItem(title: "Egypt", id: "egy"),
                          DpItem(title: "South Africa", id: "saf"),
                        ],
                      ),
                    ],
                    onChanged: (p0) {
                      showSnackbar(context, p0);
                    }))));
  }
}
''',
    };
  }

  @override
  Widget preview(BuildContext context) {
    return switch (variant) {
      DpVariant.form => _Form(),
      DpVariant.decorated => const _Decorated(),
      DpVariant.disabled => const _Disabled(),
      DpVariant.disabledItems => const _DisabledItems(),
      DpVariant.withIcons => const _WithIcons(),
      DpVariant.search => const _Search(),
      DpVariant.group => const _Group(),
    };
  }
}

const _items = [
  DropdownItem(items: [
    DpItem(title: "Australia", id: "aus"),
    DpItem(title: "Bangladesh", id: "bng"),
    DpItem(title: "UK", id: "uk"),
    DpItem(title: "USA", id: "usa"),
    DpItem(title: "Uzbekistan", id: "uzb"),
  ]),
];

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
          child: WithLabel(
            labelVm: const LabelModel(text: "Email"),
            child: DefaultDropdown(
                variant: DropdownVariant(
              name: "email",
              decoration: const DpDecoration(
                hintText: "Select a verified email",
                helperText:
                    "You can manage email addresses in your email settings.",
              ),
              form: DpForm(
                  onChanged: (_) {},
                  validator: FormBuilderValidators.required(),
                  items: [
                    DropdownItem(items: [
                      for (int i = 0; i < 5; i++)
                        DpItem(id: "$i@mail.com", title: "$i@mail.com")
                    ]),
                  ]),
            )),
          ),
        ),
        SaveButton(
          vm: formModel,
          text: "Submit",
          onSave: (value) {
            if (formModel.isValid) {
              showSnackbar(context, value);
            }
          },
        ),
      ],
    ).spaced(20);
  }
}

class _Decorated extends StatelessWidget {
  const _Decorated();

  @override
  Widget build(BuildContext context) {
    return ThemeProvider(builder: (context, vm) {
      final theme = vm.theme;
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          DefaultDropdown(
              variant: DropdownVariant(
                  name: "name",
                  decoration: const DpDecoration(
                    hintText: "Select a name",
                  ),
                  form: DpForm(
                      onChanged: (p0) {
                        showSnackbar(context, p0);
                      },
                      items: const [
                        DropdownItem(items: [
                          DpItem(title: "John", id: "john"),
                          DpItem(title: "Doe", id: "doe"),
                          DpItem(title: "Jane", id: "jane"),
                        ]),
                      ]))),
          DefaultDropdown(
              variant: DropdownVariant(
                  name: "fruits",
                  decoration: DpDecoration(
                    backgroundColor: theme.colorScheme.primary.withOpacity(.1),
                    foregroundColor: theme.colorScheme.primary,
                    icon: Icons.apple,
                    hintText: "Select a fruit",
                  ),
                  form: DpForm(
                      onChanged: (p0) {
                        showSnackbar(context, p0);
                      },
                      items: const [
                        DropdownItem(items: [
                          DpItem(title: "Apple", id: "apple"),
                          DpItem(title: "Banana", id: "banana"),
                          DpItem(title: "Orange", id: "orange"),
                          DpItem(title: "Pineapple", id: "pineapple"),
                          DpItem(title: "Grapes", id: "grapes"),
                        ]),
                      ]))),
          DefaultDropdown(
              variant: DropdownVariant(
                  name: "animals",
                  decoration: DpDecoration(
                    backgroundColor:
                        theme.colorScheme.secondary.withOpacity(.1),
                    foregroundColor: theme.colorScheme.secondary,
                    icon: Icons.pets,
                    hintText: "Select an animal",
                  ),
                  form: DpForm(
                      onChanged: (p0) {
                        showSnackbar(context, p0);
                      },
                      items: const [
                        DropdownItem(items: [
                          DpItem(title: "Dog", id: "dog"),
                          DpItem(title: "Cat", id: "cat"),
                          DpItem(title: "Rabbit", id: "rabbit"),
                          DpItem(title: "Tiger", id: "tiger"),
                          DpItem(title: "Lion", id: "lion"),
                        ]),
                      ]))),
          DefaultDropdown(
              variant: DropdownVariant(
                  name: "country",
                  decoration: DpDecoration(
                    backgroundColor: theme.colorScheme.tertiary.withOpacity(.1),
                    foregroundColor: theme.colorScheme.tertiary,
                    icon: Icons.flag,
                    hintText: "Select a country",
                  ),
                  form: DpForm(
                      onChanged: (p0) {
                        showSnackbar(context, p0);
                      },
                      items: const [
                        DropdownItem(items: [
                          DpItem(title: "Australia", id: "aus"),
                          DpItem(title: "Bangladesh", id: "bng"),
                          DpItem(title: "UK", id: "uk"),
                          DpItem(title: "USA", id: "usa"),
                          DpItem(title: "Uzbekistan", id: "uzb"),
                        ]),
                      ]))),
        ],
      ).spaced(20);
    });
  }
}

class _Disabled extends StatelessWidget {
  const _Disabled();

  @override
  Widget build(BuildContext context) {
    return WithLabel(
        labelVm: const LabelModel(text: "Helper"),
        child: DefaultDropdown(
            variant: DropdownVariant(
                name: "name",
                decoration: const DpDecoration(
                  hintText: "Select a country",
                  helperText: "Favorite country",
                ),
                form: DpForm(items: _items))));
  }
}

class _DisabledItems extends StatelessWidget {
  const _DisabledItems();

  @override
  Widget build(BuildContext context) {
    return WithLabel(
        labelVm: const LabelModel(text: "Helper"),
        child: DefaultDropdown(
            variant: DropdownVariant(
                name: "name",
                disabledItems: const [
                  "usa",
                  "uk",
                ],
                decoration: const DpDecoration(
                  hintText: "Select a country",
                  helperText: "Favorite country",
                ),
                form: DpForm(
                  onChanged: (p0) {
                    showSnackbar(context, p0);
                  },
                  items: _items,
                ))));
  }
}

class _WithIcons extends StatelessWidget {
  const _WithIcons();

  @override
  Widget build(BuildContext context) {
    return WithLabel(
        labelVm: const LabelModel(text: "With icons"),
        child: DefaultDropdown(
            variant: DropdownVariant(
                name: "name",
                decoration: const DpDecoration(hintText: "Select a country"),
                form: DpForm(
                    items: _items
                        .map((e) => e.copyWith(
                            items: e.items
                                .map((e) => e.copyWith(icon: Icons.flag))
                                .toList()))
                        .toList(),
                    onChanged: (p0) {
                      showSnackbar(context, p0);
                    }))));
  }
}

class _Search extends StatelessWidget {
  const _Search();

  @override
  Widget build(BuildContext context) {
    return WithLabel(
        labelVm: const LabelModel(text: "Search"),
        child: DefaultDropdown(
            variant: DropdownVariant(
                name: "name",
                decoration: const DpDecoration(
                  hintText: "Select a country",
                  hasSearchBox: true,
                ),
                form: DpForm(
                    items: _items
                        .map((e) => e.copyWith(
                            items: e.items
                                .map((e) => e.copyWith(icon: Icons.flag))
                                .toList()))
                        .toList(),
                    onChanged: (p0) {
                      showSnackbar(context, p0);
                    }))));
  }
}

class _Group extends StatelessWidget {
  const _Group();

  @override
  Widget build(BuildContext context) {
    return WithLabel(
        labelVm: const LabelModel(text: "Group"),
        child: DefaultDropdown(
            variant: DropdownVariant(
                name: "name",
                decoration: const DpDecoration(
                  hintText: "Select a country",
                  hasSearchBox: true,
                ),
                form: DpForm(
                    items: const [
                      DropdownItem(
                        groupTitle: "Asia",
                        groupIcon: Icons.east,
                        items: [
                          DpItem(title: "Bangladesh", id: "bng"),
                          DpItem(title: "Uzbekistan", id: "uzb"),
                        ],
                      ),
                      DropdownItem(
                        groupTitle: "Europe",
                        groupIcon: Icons.west,
                        items: [
                          DpItem(title: "UK", id: "uk"),
                          DpItem(title: "Spain", id: "spn"),
                          DpItem(title: "Germany", id: "ger"),
                        ],
                      ),
                      DropdownItem(
                        groupTitle: "America",
                        groupIcon: Icons.west,
                        items: [
                          DpItem(title: "USA", id: "usa"),
                          DpItem(title: "Canada", id: "can"),
                          DpItem(title: "Mexico", id: "mex"),
                        ],
                      ),
                      DropdownItem(
                        groupTitle: "Africa",
                        groupIcon: Icons.south,
                        items: [
                          DpItem(title: "Nigeria", id: "nga"),
                          DpItem(title: "Egypt", id: "egy"),
                          DpItem(title: "South Africa", id: "saf"),
                        ],
                      ),
                    ],
                    onChanged: (p0) {
                      showSnackbar(context, p0);
                    }))));
  }
}

import 'package:fcnui_base/fcnui_base.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:registry/pages/pages.dart';
import 'package:registry/ui/default_components/button.dart';
import 'package:registry/ui/default_components/form.dart';
import 'package:registry/ui/default_components/save_button.dart';
import 'package:registry/ui/default_components/select.dart';
import 'package:registry/ui/snackbar.dart';

final List<String> animals = [
  "Cat",
  "Dog",
  "Elephant",
  "Lion",
  "Tiger",
  "Cow",
  "Buffalo",
];

enum SelectVariant {
  basic,
  multiSelect,
  disabled,
  disabledItems,
  form,
  colorful,
  search,
  controlled,
  customItems,
  network,
  customButton,
}

class SelectPage extends PageImpl {
  final SelectVariant variant;

  const SelectPage({super.key, required this.variant});

  @override
  String getCode() {
    String code = "";
    switch (variant) {
      case SelectVariant.basic:
        code = """
class Basic extends StatelessWidget {
  const Basic({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultSelect(
      form: const SelectForm(name: "animal"),
      decoration: const SelectDecoration(
        labelText: "Favorite Animal",
        hintText: "Select an animal",
      ),
      options: SelectOptions(
        options: animals.map((e) => ValueItem(label: e, value: e)).toList(),
      ),
    );
  }
}
""";
      case SelectVariant.multiSelect:
        code = """
class MultiSelect extends StatelessWidget {
  const MultiSelect({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultSelect(
      form: const SelectForm(name: "animal"),
      decoration: const SelectDecoration(
        selectionType: SelectionType.multi,
        labelText: "Favorite Animal",
        hintText: "Select an animal(s)",
      ),
      options: SelectOptions(
        options: animals.map((e) => ValueItem(label: e, value: e)).toList(),
      ),
    );
  }
}
""";
      case SelectVariant.disabled:
        code = """
class Disabled extends StatelessWidget {
  const Disabled({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultSelect(
      form: const SelectForm(name: "animal"),
      decoration: const SelectDecoration(
        disabled: true,
        labelText: "Favorite Animal",
        hintText: "Select an animal",
      ),
      options: SelectOptions(
        options: animals.map((e) => ValueItem(label: e, value: e)).toList(),
      ),
    );
  }
}
""";
      case SelectVariant.disabledItems:
        code = """
class DisabledItems extends StatelessWidget {
  const DisabledItems({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300,
      child: DefaultSelect(
        form: const SelectForm(name: "animal"),
        decoration: const SelectDecoration(
          labelText: "Favorite Animal",
          hintText: "Select an animal",
        ),
        options: SelectOptions(
          disabledOptions: [
            for (var i = 3; i < animals.length - 1; i++)
              ValueItem(label: animals[i], value: animals[i])
          ],
          options: animals.map((e) => ValueItem(label: e, value: e)).toList(),
        ),
      ),
    );
  }
}
""";
      case SelectVariant.form:
        code = """
class Form extends StatelessWidget {
  Form({super.key});

  final formModel = FormModel();

  @override
  Widget build(BuildContext context) {
    return DefaultForm(
      vm: formModel,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DefaultSelect(
            form: SelectForm(
              name: "animal",
              validator: (p0) {
                if (p0.isEmpty) return "Please select an animal";
                if (p0.length < 2) return "Please select at least 2 animals";
                return null;
              },
            ),
            decoration: const SelectDecoration(
              labelText: "Favorite Animal",
              hintText: "Select an animal",
              selectionType: SelectionType.multi,
              showClearIcon: true,
            ),
            options: SelectOptions(
                options:
                    animals.map((e) => ValueItem(label: e, value: e)).toList()),
          ),

          // Submit button
          SaveButton(
            vm: formModel,
            onSave: (value) {
              if (!formModel.isValid) return;
              showSnackbar(context, formModel.getValues());
            },
          ),
        ],
      ).spaced(8),
    );
  }
}
""";
      case SelectVariant.colorful:
        code = """
class Colorful extends StatelessWidget {
  const Colorful({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultSelect(
      form: const SelectForm(name: "animal"),
      decoration: const SelectDecoration(
        labelText: "Favorite Animal",
        hintText: "Select an animal",
        isColorful: true,
        selectionType: SelectionType.multi,
        showClearIcon: true,
      ),
      options: SelectOptions(
        options: animals.map((e) => ValueItem(label: e, value: e)).toList(),
      ),
    );
  }
}
""";
      case SelectVariant.search:
        code = """
class Search extends StatelessWidget {
  const Search({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultSelect(
      form: const SelectForm(name: "animal"),
      decoration: const SelectDecoration(
        labelText: "Favorite Animal",
        hintText: "Select an animal",
        searchEnabled: true,
      ),
      options: SelectOptions(
        options: animals.map((e) => ValueItem(label: e, value: e)).toList(),
      ),
    );
  }
}
""";
      case SelectVariant.controlled:
        code = """
class Controlled extends StatefulWidget {
  const Controlled({super.key});

  @override
  State<Controlled> createState() => _ControlledState();
}

class _ControlledState extends State<Controlled> {
  final SelectController<String> controller = SelectController<String>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      controller.addListener(() {
        setState(() {});
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: DefaultSelect<String>(
                form: const SelectForm(name: "animal"),
                decoration: SelectDecoration(
                    controller: controller,
                    labelText: "Favorite Animal",
                    hintText: "Select an animal",
                    selectionType: SelectionType.multi),
                options: SelectOptions(
                  options: animals
                      .map((e) => ValueItem(label: e, value: e))
                      .toList(),
                ),
              ),
            ),
            DefaultButton(
                variant: PrimaryButtonVariant(
                    onPressed: controller.openDropdown, text: "Open"))
          ],
        ).spaced(8),
        Text(
          "Selected: controller.selectedOptions.map((e) => e.label).join(", ")",
          style: const TextStyle(color: Colors.grey),
        ),
      ],
    ).spaced(8);
  }
}
""";
      case SelectVariant.customItems:
        code = """
class CustomItems extends StatelessWidget {
  const CustomItems({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultSelect<String>(
      form: const SelectForm(name: "animal"),
      decoration: const SelectDecoration(
        labelText: "Favorite Animal",
        hintText: "Select an animal",
      ),
      options: SelectOptions(
        options: animals
            .map((e) => ValueItem(
                label: e,
                value: e,
                subtitle: e.startsWith("C") ? "Starts with C" : null))
            .toList(),
        optionItemBuilder: (context, item, selected) {
          return ListTile(
              title: Text(item.label),
              selected: selected,
              subtitle: item.subtitle != null ? Text(item.subtitle!) : null,
              selectedTileColor: Colors.grey[200],
              leading: CircleAvatar(
                child:
                    Text(item.label[0], style: const TextStyle(fontSize: 24)),
              ));
        },
      ),
    );
  }
}
""";
      case SelectVariant.network:
        code = """
class Network extends StatelessWidget {
  const Network({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultSelect<String>.network(
      networkConfig: SelectNetwork(
        networkConfig: NetworkConfig(
          url: "https://dummyjson.com/products",
          method: RequestMethod.get,
          headers: {
            'Content-Type': 'application/json',
          },
        ),
        responseParser: (p0) {
          final list = (p0['products'] as List<dynamic>).map((e) {
            final item = e as Map<String, dynamic>;
            return ValueItem(
                label: item['title'],
                value: item['id'].toString(),
                subtitle: "\${item['price']}");
          }).toList();

          return Future.value(list);
        },
        responseErrorBuilder: (p0, p1) {
          return Text("Error p1");
        },
      ),
      decoration: const SelectDecoration(
        dropdownMenuMaxHeight: 300,
        hintText: "Select a product",
        selectionType: SelectionType.single,
        labelText: "Product",
      ),
      form: const SelectForm(name: "dp"),
    );
  }
}
""";
      case SelectVariant.customButton:
        code = """
class CustomButton extends StatelessWidget {
  const CustomButton({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultSelect<String>(
      form: const SelectForm(name: "animal"),
      decoration: const SelectDecoration(
        labelText: "Favorite Animal",
        hintText: "Select an animal",
        customWidget: Icon(Icons.more_vert),
      ),
      options: SelectOptions(
        options: animals.map((e) => ValueItem(label: e, value: e)).toList(),
      ),
    );
  }
}
""";
    }
    return code;
  }

  @override
  Widget preview(BuildContext context) {
    return SizedBox(
        width: 300,
        child: switch (variant) {
          SelectVariant.basic => const Basic(),
          SelectVariant.multiSelect => const MultiSelect(),
          SelectVariant.disabled => const Disabled(),
          SelectVariant.disabledItems => const DisabledItems(),
          SelectVariant.form => Form(),
          SelectVariant.colorful => const Colorful(),
          SelectVariant.search => const Search(),
          SelectVariant.controlled => const Controlled(),
          SelectVariant.customItems => const CustomItems(),
          SelectVariant.network => const Network(),
          SelectVariant.customButton => const CustomButton(),
        });
  }
}

class Basic extends StatelessWidget {
  const Basic({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultSelect(
      form: const SelectForm(name: "animal"),
      decoration: const SelectDecoration(
        labelText: "Favorite Animal",
        hintText: "Select an animal",
      ),
      options: SelectOptions(
        options: animals.map((e) => ValueItem(label: e, value: e)).toList(),
      ),
    );
  }
}

class MultiSelect extends StatelessWidget {
  const MultiSelect({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultSelect(
      form: const SelectForm(name: "animal"),
      decoration: const SelectDecoration(
        selectionType: SelectionType.multi,
        labelText: "Favorite Animal",
        hintText: "Select an animal(s)",
      ),
      options: SelectOptions(
        options: animals.map((e) => ValueItem(label: e, value: e)).toList(),
      ),
    );
  }
}

class Disabled extends StatelessWidget {
  const Disabled({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultSelect(
      form: const SelectForm(name: "animal"),
      decoration: const SelectDecoration(
        disabled: true,
        labelText: "Favorite Animal",
        hintText: "Select an animal",
      ),
      options: SelectOptions(
        options: animals.map((e) => ValueItem(label: e, value: e)).toList(),
      ),
    );
  }
}

class DisabledItems extends StatelessWidget {
  const DisabledItems({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300,
      child: DefaultSelect(
        form: const SelectForm(name: "animal"),
        decoration: const SelectDecoration(
          labelText: "Favorite Animal",
          hintText: "Select an animal",
        ),
        options: SelectOptions(
          disabledOptions: [
            for (var i = 3; i < animals.length - 1; i++)
              ValueItem(label: animals[i], value: animals[i])
          ],
          options: animals.map((e) => ValueItem(label: e, value: e)).toList(),
        ),
      ),
    );
  }
}

class Form extends StatelessWidget {
  Form({super.key});

  final formModel = FormModel();

  @override
  Widget build(BuildContext context) {
    return DefaultForm(
      vm: formModel,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DefaultSelect(
            form: SelectForm(
              name: "animal",
              validator: (p0) {
                if (p0.isEmpty) return "Please select an animal";
                if (p0.length < 2) return "Please select at least 2 animals";
                return null;
              },
            ),
            decoration: const SelectDecoration(
              labelText: "Favorite Animal",
              hintText: "Select an animal",
              selectionType: SelectionType.multi,
              showClearIcon: true,
            ),
            options: SelectOptions(
                options:
                    animals.map((e) => ValueItem(label: e, value: e)).toList()),
          ),

          // Submit button
          SaveButton(
            vm: formModel,
            onSave: (value) {
              if (!formModel.isValid) return;
              showSnackbar(context, formModel.getValues());
            },
          ),
        ],
      ).spaced(8),
    );
  }
}

class Colorful extends StatelessWidget {
  const Colorful({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultSelect(
      form: const SelectForm(name: "animal"),
      decoration: const SelectDecoration(
        labelText: "Favorite Animal",
        hintText: "Try changing the theme",
        isColorful: true,
        selectionType: SelectionType.multi,
        showClearIcon: true,
      ),
      options: SelectOptions(
        options: animals.map((e) => ValueItem(label: e, value: e)).toList(),
      ),
    );
  }
}

class Search extends StatelessWidget {
  const Search({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultSelect(
      form: const SelectForm(name: "animal"),
      decoration: const SelectDecoration(
        labelText: "Favorite Animal",
        hintText: "Select an animal",
        searchEnabled: true,
      ),
      options: SelectOptions(
        options: animals.map((e) => ValueItem(label: e, value: e)).toList(),
      ),
    );
  }
}

class Controlled extends StatefulWidget {
  const Controlled({super.key});

  @override
  State<Controlled> createState() => _ControlledState();
}

class _ControlledState extends State<Controlled> {
  final SelectController<String> controller = SelectController<String>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      controller.addListener(() {
        setState(() {});
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: DefaultSelect<String>(
                form: const SelectForm(name: "animal"),
                decoration: SelectDecoration(
                    controller: controller,
                    labelText: "Favorite Animal",
                    hintText: "Select an animal",
                    selectionType: SelectionType.multi),
                options: SelectOptions(
                  options: animals
                      .map((e) => ValueItem(label: e, value: e))
                      .toList(),
                ),
              ),
            ),
            DefaultButton(decorationBuilder: (context, type) {
              return ButtonDecoration(
                context,
                type: type,
                child: ButtonChild(context, text: "Open"),
                action:
                    ButtonAction(context, onPressed: controller.openDropdown),
              );
            })
          ],
        ).spaced(8),
        Text(
          "Selected: ${controller.selectedOptions.map((e) => e.label).join(", ")}",
          style: const TextStyle(color: Colors.grey),
        ),
      ],
    ).spaced(8);
  }
}

class CustomItems extends StatelessWidget {
  const CustomItems({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultSelect<String>(
      form: const SelectForm(name: "animal"),
      decoration: const SelectDecoration(
        labelText: "Favorite Animal",
        hintText: "Select an animal",
        selectionType: SelectionType.multi,
      ),
      options: SelectOptions(
        options: animals
            .map((e) => ValueItem(
                label: e,
                value: e,
                subtitle: e.startsWith("C") ? "Starts with C" : null))
            .toList(),
        optionItemBuilder: (context, item, selected) {
          return ListTile(
              title: Text(item.label),
              selected: selected,
              subtitle: item.subtitle != null ? Text(item.subtitle!) : null,
              selectedTileColor: Colors.grey[200],
              leading: CircleAvatar(
                child:
                    Text(item.label[0], style: const TextStyle(fontSize: 24)),
              ));
        },
      ),
    );
  }
}

class Network extends StatelessWidget {
  const Network({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultSelect<String>.network(
      networkConfig: SelectNetwork(
        networkConfig: NetworkConfig(
          url: "https://dummyjson.com/products",
          method: RequestMethod.get,
          headers: {
            'Content-Type': 'application/json',
          },
        ),
        responseParser: (p0) {
          final list = (p0['products'] as List<dynamic>).map((e) {
            final item = e as Map<String, dynamic>;
            return ValueItem(
                label: item['title'],
                value: item['id'].toString(),
                subtitle: "\$${item['price']}");
          }).toList();

          return Future.value(list);
        },
        responseErrorBuilder: (p0, p1) {
          return Text("Error $p1");
        },
      ),
      decoration: const SelectDecoration(
        hintText: "Select a product",
        selectionType: SelectionType.single,
        labelText: "Product",
      ),
      form: const SelectForm(name: "dp"),
    );
  }
}

class CustomButton extends StatelessWidget {
  const CustomButton({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultSelect<String>(
      form: const SelectForm(name: "animal"),
      decoration: const SelectDecoration(
        labelText: "Favorite Animal",
        hintText: "Select an animal",
        customWidget: Icon(Icons.more_vert),
      ),
      options: SelectOptions(
        options: animals.map((e) => ValueItem(label: e, value: e)).toList(),
      ),
    );
  }
}

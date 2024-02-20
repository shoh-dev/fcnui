import 'package:fcnui_base/fcnui_base.dart';
import 'package:flutter/material.dart';
import 'package:registry/ui/default_components/disabled.dart';
import 'package:registry/ui/default_components/input.dart';

import 'dp_item.dart';
import 'form.dart';

class DropdownItem extends Equatable {
  final String? groupTitle;
  final List<DpItem> items;
  final List<String> disabledItems;

  const DropdownItem({
    this.groupTitle,
    required this.items,
    this.disabledItems = const [],
  });

  @override
  List<Object?> get props => [groupTitle, items, disabledItems];
}

class DropdownVariant extends IFormModel {
  final DpForm form;
  final DpDecoration decoration;

  const DropdownVariant({
    required super.name,
    required this.form,
    this.decoration = const DpDecoration(),
  });

  @override
  List<Object?> get props => [name, form, decoration];
}

class DpForm extends Equatable {
  final List<DropdownItem> items;
  final bool hasSearchBox;

  ///If null, then disabled
  final void Function(String?)? onChanged;

  final String? initialValue;
  final String? Function(String?)? validator;
  final AutovalidateMode? autovalidateMode;

  DpForm({
    required this.items,
    this.hasSearchBox = false,
    this.onChanged,
    this.initialValue,
    this.validator,
    this.autovalidateMode,
  })  :
        //assert if items has same id
        assert(
            items
                    .expand((element) => element.items)
                    .map((e) => e.id)
                    .toSet()
                    .length ==
                items
                    .expand((element) => element.items)
                    .map((e) => e.id)
                    .length,
            "Items id must be unique"),
        //assert if items has at least one item
        assert(items.isNotEmpty, "Items cannot be empty");

  @override
  List<Object?> get props => [
        items,
        hasSearchBox,
        onChanged,
        initialValue,
        validator,
        autovalidateMode
      ];
}

class DpDecoration extends Equatable {
  final String? hintText;
  final IconData? icon;

  const DpDecoration({
    this.hintText,
    this.icon,
  });

  @override
  List<Object?> get props => [hintText, icon];
}

class DefaultDropdown extends StatelessWidget {
  final DropdownVariant variant;

  const DefaultDropdown({super.key, required this.variant});

  @override
  Widget build(BuildContext context) {
    return DefaultDisabled(
      vm: DisabledVm(
          disabled: variant.form.onChanged == null,
          child: FormBuilderField<String>(
            name: variant.name,
            validator: variant.form.validator,
            initialValue: variant.form.initialValue,
            onChanged: variant.form.onChanged,
            autovalidateMode: variant.form.autovalidateMode,
            enabled: variant.form.onChanged != null,
            builder: (FormFieldState<String> state) {
              return _DropdownSelect(state: state, variant: variant);
            },
          )),
    );
  }
}

class _DropdownSelect extends StatefulWidget {
  final FormFieldState<String> state;
  final DropdownVariant variant;

  const _DropdownSelect({required this.state, required this.variant});

  @override
  State<_DropdownSelect> createState() => __DropdownSelectState();
}

class __DropdownSelectState extends State<_DropdownSelect> {
  final TextEditingController searchController = TextEditingController();

  DropdownVariant get variant => widget.variant;

  FormFieldState<String> get state => widget.state;

  String? get errorText => state.errorText;

  DpItem? get selectedItem => variant.form.items
      .expand((element) => element.items)
      .firstWhereOrNull((element) => element.id == state.value);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (variant.form.initialValue != null) {
        state.didChange(variant.form.initialValue);
      }
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  InputDecorationTheme _getInputDecoration(ThemeData theme) {
    return theme.inputDecorationTheme.copyWith(
      contentPadding: const EdgeInsets.all(0),
      //Border when tapped and focused
      focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4).r,
          borderSide: BorderSide(
                  color: theme.dividerColor.withOpacity(0.6),
                  width: 1,
                  strokeAlign: BorderSide.strokeAlignOutside)
              .w),
      //Idle state border
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(4).r,
        borderSide: BorderSide(
                color: theme.dividerColor.withOpacity(0.6),
                strokeAlign: BorderSide.strokeAlignInside)
            .w,
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(4).r,
        borderSide: const BorderSide(
                color: Colors.red, strokeAlign: BorderSide.strokeAlignInside)
            .w,
      ),
      disabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(4).r,
        borderSide: BorderSide(
                color: theme.dividerColor.withOpacity(0.6),
                strokeAlign: BorderSide.strokeAlignInside)
            .w,
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(4).r,
        borderSide: const BorderSide(
                color: Colors.red,
                width: 1,
                strokeAlign: BorderSide.strokeAlignOutside)
            .w,
      ),
      constraints: BoxConstraints.tightFor(height: 40.h),
      focusColor: Colors.transparent,
      hoverColor: Colors.transparent,
      filled: true,
      fillColor: theme.colorScheme.surface,
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isError = state.hasError;
    final String? errorText = state.errorText;

    return ThemeProvider(builder: (context, themeVm) {
      final ThemeData theme = themeVm.theme;
      return Theme(
        data: theme.copyWith(
          inputDecorationTheme: _getInputDecoration(theme),
        ),
        child: DecoratedBox(
          decoration: BoxDecoration(boxShadow: [
            BoxShadow(
              offset: const Offset(0, 1).w,
              color: Colors.black.withOpacity(0.02),
              blurRadius: 2.w,
              spreadRadius: 0,
            ),
            BoxShadow(
              offset: const Offset(0, 2).w,
              color: Colors.black.withOpacity(0.025),
              blurRadius: 5.w,
              spreadRadius: 0,
            ),
          ]),
          child: DropdownButtonFormField2<DpItem>(
            items: _getItems(themeVm.theme),
            isExpanded: true,
            hint: variant.decoration.hintText != null
                ? Text(
                    variant.decoration.hintText!,
                    style: theme.textTheme.bodyMedium!
                        .copyWith(fontWeight: FontWeight.normal),
                  )
                : null,
            dropdownSearchData: variant.form.hasSearchBox
                ? DropdownSearchData(
                    searchController: searchController,
                    searchInnerWidget: Padding(
                      padding:
                          const EdgeInsets.only(left: 8, right: 8, top: 8).w,
                      child: DefaultInput(
                          vm: InputModel(
                        controller: searchController,
                        name: "${variant.name}Search",
                        hintText: "Search",
                      )),
                    ),
                    searchMatchFn: (item, searchValue) {
                      bool found = false;
                      if (item.value?.title
                              .toLowerCase()
                              .contains(searchValue.toLowerCase()) ??
                          false) {
                        found = true;
                      } else {
                        if (item.value?.subtitle
                                ?.toLowerCase()
                                .contains(searchValue.toLowerCase()) ??
                            false) {
                          found = true;
                        }
                      }
                      return found;
                    },
                    searchInnerWidgetHeight: 36.h,
                  )
                : null,
            decoration: InputDecoration(
              errorText: isError ? errorText : null,
              errorStyle:
                  theme.textTheme.bodyMedium!.copyWith(color: Colors.red),
              hintText: variant.decoration.hintText,
              icon: variant.decoration.icon != null
                  ? Icon(variant.decoration.icon)
                  : null,
            ),
            onChanged: variant.form.onChanged == null
                ? null
                : (value) {
                    state.didChange(value?.id);
                    variant.form.onChanged!(value?.id);
                  },
            dropdownStyleData: _getDropdownStyle(theme),
            iconStyleData: _getIconStyle(theme),
            menuItemStyleData: _getMenuItemStyle(theme),
            selectedItemBuilder: (context) {
              return _getItems(theme).map((e) {
                return RichText(
                  text: TextSpan(children: [
                    TextSpan(
                      text: selectedItem?.title,
                      style: theme.textTheme.bodyLarge,
                    ),
                  ]),
                );
              }).toList();
            },
          ),
        ),
      );
    });
  }

  IconStyleData _getIconStyle(ThemeData theme) {
    return IconStyleData(
      icon: Padding(
        padding: const EdgeInsets.only(right: 16.0).w,
        child: Icon(
          variant.decoration.icon ?? Icons.unfold_more,
          color: theme.colorScheme.onSurface.withOpacity(0.6),
          size: 16.w,
        ),
      ),
    );
  }

  DropdownStyleData _getDropdownStyle(ThemeData theme) {
    final shadows = [
      BoxShadow(
        offset: const Offset(0, 2).w,
        color: Colors.black.withOpacity(0.08),
        blurRadius: 4.w,
        spreadRadius: 0,
      ),
      BoxShadow(
        offset: const Offset(0, 4).w,
        color: Colors.black.withOpacity(0.1),
        blurRadius: 10.w,
        spreadRadius: 0,
      ),
    ];
    return DropdownStyleData(
      maxHeight: 300.h,
      padding: const EdgeInsets.all(14).w,
      elevation: 0,
      offset: const Offset(0, -4).w,
      decoration: BoxDecoration(
        boxShadow: shadows,
        border: Border.all(
          color: theme.dividerColor.withOpacity(0.6),
          width: 1.w,
        ),
        borderRadius: BorderRadius.circular(4).r,
      ),
    );
  }

  MenuItemStyleData _getMenuItemStyle(ThemeData theme) {
    return MenuItemStyleData(
        overlayColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.hovered)) {
            return theme.dividerColor.withOpacity(0.8);
          }
        }),
        selectedMenuItemBuilder: (context, child) {
          return DecoratedBox(
            decoration: BoxDecoration(
              color: theme.dividerColor.withOpacity(0.6),
              borderRadius: BorderRadius.circular(4).r,
            ),
            child: child,
          );
        },
        padding: const EdgeInsets.all(0).w,
        customHeights: _getCustomHeights());
  }

  List<double> _getCustomHeights() {
    final List<double> customHeights = [];
    //if has group title => 40
    //if has subtitle => 56
    //if has only title => 40
    for (final groupItem in variant.form.items) {
      if (groupItem.groupTitle != null) {
        customHeights.add(40.h);
      }
      for (final item in groupItem.items) {
        if (item.subtitle != null) {
          customHeights.add(56.h);
        } else {
          customHeights.add(40.h);
        }
      }
    }
    return customHeights;
  }

  String? hoveringId;

  List<DropdownMenuItem<DpItem>> _getItems(ThemeData theme) {
    final List<DropdownMenuItem<DpItem>> items = [];

    for (final groupItem in variant.form.items) {
      if (groupItem.groupTitle != null) {
        items.add(DropdownMenuItem<DpItem>(
          value: DpItem(
              id: "title${groupItem.groupTitle}", title: groupItem.groupTitle!),
          enabled: false,
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 12).w,
            child: Text(groupItem.groupTitle!,
                style: theme.textTheme.bodyLarge!
                    .copyWith(fontWeight: FontWeight.bold)),
          ),
        ));
      }
      for (final item in groupItem.items) {
        items.add(DropdownMenuItem<DpItem>(
          value: item,
          child: Container(
            width: double.infinity,
            height: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 12).w,
            alignment: Alignment.centerLeft,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(item.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodyLarge),
                if (item.subtitle != null)
                  Text(item.subtitle!,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodyMedium!.copyWith(
                        color: theme.colorScheme.onSurface.withOpacity(0.6),
                      )),
              ],
            ),
          ),
        ));
      }
    }
    return items;
  }
}

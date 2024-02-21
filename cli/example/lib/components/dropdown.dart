import 'package:fcnui_base/fcnui_base.dart';
import 'package:flutter/material.dart';
import 'form.dart';
import 'input.dart';
import 'disabled.dart';
import 'dp_item.dart';

class DropdownItem extends Equatable {
  final String? groupTitle;
  final IconData? groupIcon;
  final List<DpItem> items;

  const DropdownItem({
    this.groupTitle,
    required this.items,
    this.groupIcon,
  });

  @override
  List<Object?> get props => [groupTitle, items, groupIcon];

  //copyWith
  DropdownItem copyWith({
    String? groupTitle,
    IconData? groupIcon,
    List<DpItem>? items,
  }) {
    return DropdownItem(
      groupTitle: groupTitle ?? this.groupTitle,
      groupIcon: groupIcon ?? this.groupIcon,
      items: items ?? this.items,
    );
  }
}

class DropdownVariant extends IFormModel {
  final DpForm form;
  final DpDecoration decoration;
  final List<String> disabledItems;

  const DropdownVariant({
    required super.name,
    this.disabledItems = const [],
    required this.form,
    this.decoration = const DpDecoration(),
  });

  @override
  List<Object?> get props => [name, form, decoration, disabledItems];
}

class DpForm extends Equatable {
  final List<DropdownItem> items;

  ///If null, then disabled
  final void Function(String?)? onChanged;

  final String? initialValue;
  final String? Function(String?)? validator;
  final AutovalidateMode? autovalidateMode;

  DpForm({
    required this.items,
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
  List<Object?> get props =>
      [items, onChanged, initialValue, validator, autovalidateMode];
}

class DpDecoration extends Equatable {
  final String? hintText;
  final IconData? icon;
  final Color? selectedColor;
  final Color? hoverColor;
  final String? searchHintText;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final String? helperText;
  final bool hasSearchBox;

  const DpDecoration({
    this.hintText,
    this.icon,
    this.backgroundColor,
    this.selectedColor,
    this.hoverColor,
    this.searchHintText,
    this.foregroundColor,
    this.helperText,
    this.hasSearchBox = false,
  });

  @override
  List<Object?> get props => [
        hintText,
        icon,
        selectedColor,
        hoverColor,
        searchHintText,
        backgroundColor,
        foregroundColor,
        helperText,
        hasSearchBox
      ];
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
                  color: variant.decoration.foregroundColor ??
                      theme.dividerColor.withOpacity(0.6),
                  width: 1,
                  strokeAlign: BorderSide.strokeAlignOutside)
              .w),
      //Idle state border
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(4).r,
        borderSide: BorderSide(
                color: variant.decoration.foregroundColor ??
                    theme.dividerColor.withOpacity(0.6),
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
      focusColor: Colors.transparent,
      hoverColor: Colors.transparent,
      filled: true,
      fillColor:
          variant.decoration.backgroundColor ?? theme.colorScheme.surface,
      errorMaxLines: 2,
      helperMaxLines: 2,
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
        child: DropdownButtonFormField2<DpItem>(
          items: _getItems(themeVm.theme),
          isExpanded: true,
          value: selectedItem,
          hint: variant.decoration.hintText != null
              ? Text(
                  variant.decoration.hintText!,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodyMedium!.copyWith(
                      fontWeight: FontWeight.normal,
                      color: variant.decoration.foregroundColor),
                )
              : null,
          dropdownSearchData: variant.decoration.hasSearchBox
              ? DropdownSearchData(
                  searchController: searchController,
                  searchInnerWidget: Padding(
                    padding: const EdgeInsets.only(left: 8, right: 8, top: 8).w,
                    child: DefaultInput(
                        vm: InputModel(
                      controller: searchController,
                      name: "${variant.name}Search",
                      hintText: variant.decoration.searchHintText ?? "Search",
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
              hoverColor: Colors.transparent,
              helperText: variant.decoration.helperText,
              helperStyle: theme.textTheme.bodySmall!.copyWith(
                  color: theme.colorScheme.onSurface.withOpacity(0.4))),
          onChanged: variant.form.onChanged == null
              ? null
              : (value) {
                  state.didChange(value?.id);
                },
          dropdownStyleData: _getDropdownStyle(theme),
          iconStyleData: _getIconStyle(theme),
          menuItemStyleData: _getMenuItemStyle(theme),
          selectedItemBuilder: (context) {
            return _getItems(theme).map((e) {
              return RichText(
                overflow: TextOverflow.ellipsis,
                text: TextSpan(children: [
                  TextSpan(
                      text: selectedItem?.title,
                      style: theme.textTheme.bodyLarge!
                          .copyWith(color: variant.decoration.foregroundColor)),
                ]),
              );
            }).toList();
          },
          buttonStyleData: ButtonStyleData(
            elevation: 0,
            overlayColor: MaterialStateProperty.resolveWith((states) {
              return Colors.transparent;
            }),
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
          color: variant.decoration.foregroundColor ??
              theme.colorScheme.onSurface.withOpacity(0.6),
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
      padding: const EdgeInsets.all(8).w,
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
            return variant.decoration.hoverColor ??
                variant.decoration.backgroundColor ??
                theme.dividerColor.withOpacity(0.4);
          }
          return null;
        }),
        selectedMenuItemBuilder: (context, child) {
          return DecoratedBox(
            decoration: BoxDecoration(
              color: variant.decoration.selectedColor ??
                  variant.decoration.backgroundColor ??
                  theme.dividerColor.withOpacity(0.4),
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
    //if has group title => 35
    //if has subtitle => 50
    //if has only title => 35
    for (final groupItem in variant.form.items) {
      if (groupItem.groupTitle != null) {
        customHeights.add(35.h);
      }
      for (final item in groupItem.items) {
        if (item.subtitle != null) {
          customHeights.add(50.h);
        } else {
          customHeights.add(35.h);
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
            margin: const EdgeInsets.symmetric(horizontal: 8).w,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (groupItem.groupIcon != null)
                  Icon(groupItem.groupIcon,
                      color: theme.colorScheme.onSurface.withOpacity(0.6),
                      size: 16.w),
                Text(groupItem.groupTitle!, style: theme.textTheme.titleMedium),
              ],
            ).spaced(8),
          ),
        ));
      }
      for (final item in groupItem.items) {
        items.add(DropdownMenuItem<DpItem>(
          value: item,
          enabled: !variant.disabledItems.contains(item.id),
          child: DefaultDisabled(
              vm: DisabledVm(
            disabled: variant.disabledItems.contains(item.id),
            child: Container(
              width: double.infinity,
              height: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 8).w,
              alignment: Alignment.centerLeft,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if (item.icon != null)
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(item.icon,
                            color: theme.colorScheme.onSurface.withOpacity(0.6),
                            size: 16.w),
                        const SizedBox(width: 8).w,
                      ],
                    ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(item.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.bodyMedium),
                        if (item.subtitle != null)
                          Text(item.subtitle!,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: theme.textTheme.bodySmall!.copyWith(
                                color: theme.colorScheme.onSurface
                                    .withOpacity(0.6),
                              )),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )),
        ));
      }
    }
    return items;
  }
}

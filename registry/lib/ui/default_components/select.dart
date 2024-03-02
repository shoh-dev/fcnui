import 'dart:convert';

import 'package:fcnui_base/fcnui_base.dart';
import 'package:flutter/material.dart';

import 'disabled.dart';
import 'form.dart';
import 'input.dart';
import 'fcnui_theme.dart';

class DefaultSelect<T> extends StatefulWidget {
  final SelectOptions<T> options;
  final SelectForm<T> form;
  final SelectDecoration<T> decoration;
  final SelectNetwork<T>? networkConfig;

  const DefaultSelect({
    super.key,
    this.options = const SelectOptions(),
    required this.form,
    this.networkConfig,
    this.decoration = const SelectDecoration(),
  });

  /// Constructor for DefaultSelect that fetches the options from a network call.
  /// [networkConfig] is the configuration for the network call.
  /// [responseParser] is the parser that is used to parse the response from the network call.
  /// [responseErrorBuilder] is the builder that is used to build the error widget when the network call fails.

  const DefaultSelect.network({
    super.key,
    required this.form,
    this.options = const SelectOptions(),
    required this.networkConfig,
    this.decoration = const SelectDecoration(),
  });

  @override
  State<DefaultSelect<T>> createState() => _DefaultSelectState<T>();
}

class _DefaultSelectState<T> extends State<DefaultSelect<T>> {
  SelectDecoration<T> get decoration => widget.decoration;

  SelectOptions<T> get dpOptions => widget.options;

  List<ValueItem<T>> get options => widget.options.options;

  SelectForm<T> get form => widget.form;

  SelectNetwork<T>? get networkConfig => widget.networkConfig;

  /// Options list that is used to display the options.
  final List<ValueItem<T>> _options = [];

  /// Selected options list that is used to display the selected options.
  final List<ValueItem<T>> _selectedOptions = [];

  /// Disabled options list that is used to display the disabled options.
  final List<ValueItem<T>> _disabledOptions = [];

  /// The controller for the dropdown.
  OverlayState? _overlayState;
  OverlayEntry? _overlayEntry;
  bool _selectionMode = false;

  late final FocusNode _focusNode;
  final LayerLink _layerLink = LayerLink();

  /// Response from the network call.
  dynamic _reponseBody;

  /// value notifier that is used for controller.
  late SelectController<T> _controller;

  /// search field focus node
  FocusNode? _searchFocusNode;

  bool get isMultiSelection => decoration.selectionType == SelectionType.multi;

  double get dropdownHeight {
    double height = 0;
    for (final option in _options) {
      height += 43;
      if (option.subtitle != null) {
        height += 11;
      }
    }
    return height;
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _initialize();
    });

    _focusNode = FocusNode();
    _controller = decoration.controller ?? SelectController<T>();
  }

  /// Initializes the options, selected options and disabled options.
  /// If the options are fetched from the network, then the network call is made.
  /// If the options are passed as a parameter, then the options are initialized.
  Future<void> _initialize() async {
    if (!mounted) return;
    if (networkConfig?.networkConfig != null) {
      await _fetchNetwork();
    } else {
      _options.addAll(_controller.options.isNotEmpty == true
          ? _controller.options
          : options);
    }
    _addOptions();
    if (mounted) {
      _initializeOverlay();
    } else {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        _initializeOverlay();
      });
    }
  }

  @override
  void didUpdateWidget(covariant DefaultSelect<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    // if (_options != options) {
    //   _options.clear();
    //   _options.addAll(options);
    // }
  }

  void _initializeOverlay() {
    _overlayState ??= Overlay.of(context);

    _focusNode.addListener(_handleFocusChange);

    if (decoration.searchEnabled) {
      _searchFocusNode = FocusNode();
      _searchFocusNode!.addListener(_handleFocusChange);
    }
  }

  /// Adds the selected options and disabled options to the options list.
  void _addOptions() {
    setState(() {
      _selectedOptions.addAll(_controller.selectedOptions.isNotEmpty == true
          ? _controller.selectedOptions
          : dpOptions.selectedOptions);
      _disabledOptions.addAll(_controller.disabledOptions.isNotEmpty == true
          ? _controller.disabledOptions
          : dpOptions.disabledOptions);
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_controller._isDisposed == false) {
        _controller.setOptions(_options);
        _controller.setSelectedOptions(_selectedOptions);
        _controller.setDisabledOptions(_disabledOptions);

        _controller.addListener(_handleControllerChange);
      }
    });
  }

  /// Handles the focus change to show/hide the dropdown.
  void _handleFocusChange() {
    if (_focusNode.hasFocus && mounted) {
      _overlayEntry = _buildOverlayEntry();
      Overlay.of(context).insert(_overlayEntry!);
      _updateSelection();
      return;
    }

    if ((_searchFocusNode == null || _searchFocusNode?.hasFocus == false) &&
        _overlayEntry != null) {
      _overlayEntry?.remove();
      // ignore: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member
      _controller.notifyListeners();
    }

    if (mounted) _updateSelection();

    _controller.value._isDropdownOpen =
        _focusNode.hasFocus || _searchFocusNode?.hasFocus == true;
    // ignore: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member
    _controller.notifyListeners();
  }

  void _updateSelection() {
    setState(() {
      _selectionMode =
          _focusNode.hasFocus || _searchFocusNode?.hasFocus == true;
    });
  }

  /// Calculate offset size for dropdown.
  List _calculateOffsetSize() {
    RenderBox? renderBox = context.findRenderObject() as RenderBox?;

    var size = renderBox?.size ?? Size.zero;
    var offset = renderBox?.localToGlobal(Offset.zero) ?? Offset.zero;

    final availableHeight = MediaQuery.of(context).size.height - offset.dy;
    if (decoration.customWidget != null) {
      return [
        decoration.dropdownMenuSize ?? const Size.fromWidth(300),
        availableHeight < dropdownHeight,
      ];
    }

    return [
      decoration.dropdownMenuSize ?? size,
      availableHeight < dropdownHeight,
    ];
  }

  /// Dispose the focus node and overlay entry.
  @override
  void dispose() {
    if (_overlayEntry?.mounted == true) {
      if (_overlayState != null && _overlayEntry != null) {
        _overlayEntry?.remove();
      }
      _overlayEntry = null;
      _overlayState?.dispose();
    }
    _focusNode.removeListener(_handleFocusChange);
    _searchFocusNode?.removeListener(_handleFocusChange);
    _focusNode.dispose();
    _searchFocusNode?.dispose();
    _controller.removeListener(_handleControllerChange);

    if (decoration.controller == null ||
        decoration.controller?.isDisposed == true) {
      _controller.dispose();
    }

    super.dispose();
  }

  /// Util method to map with index.
  Iterable<E> mapIndexed<E, F>(
      Iterable<F> items, E Function(int index, F item) f) sync* {
    var index = 0;

    for (final item in items) {
      yield f(index, item);
      index = index + 1;
    }
  }

  /// Handle the focus change on tap outside of the dropdown.
  void _onOutSideTap() {
    if (_searchFocusNode != null) {
      _searchFocusNode!.unfocus();
    }
    _focusNode.unfocus();
  }

  /// Method to toggle the focus of the dropdown.
  void _toggleFocus() {
    if (_focusNode.hasFocus) {
      _focusNode.unfocus();
    } else {
      _focusNode.requestFocus();
    }
  }

  /// Clear the selected options.
  /// [SelectController] is used to clear the selected options.
  void clear() {
    if (!_controller._isDisposed) {
      _controller.clearAllSelection();
    } else {
      setState(() {
        _selectedOptions.clear();
      });
      dpOptions.onOptionSelected?.call(_selectedOptions);
    }
    if (_focusNode.hasFocus) _focusNode.unfocus();
  }

  /// handle the controller change.
  void _handleControllerChange() {
    // if the controller is null, return.
    if (_controller.isDisposed == true) return;

    // if current disabled options are not equal to the controller's disabled options, update the state.
    if (_disabledOptions != _controller.value._disabledOptions) {
      setState(() {
        _disabledOptions.clear();
        _disabledOptions.addAll(_controller.value._disabledOptions);
      });
    }

    // if current options are not equal to the controller's options, update the state.
    if (_options != _controller.value._options) {
      setState(() {
        _options.clear();
        _options.addAll(_controller.value._options);
      });
    }

    // if current selected options are not equal to the controller's selected options, update the state.
    if (_selectedOptions != _controller.value._selectedOptions) {
      setState(() {
        _selectedOptions.clear();
        _selectedOptions.addAll(_controller.value._selectedOptions);
      });
      dpOptions.onOptionSelected?.call(_selectedOptions);
    }

    if (_selectionMode != _controller.value._isDropdownOpen) {
      if (_controller.value._isDropdownOpen) {
        _focusNode.requestFocus();
      } else {
        _focusNode.unfocus();
      }
    }
  }

  bool isLoading = false;

  /// Make a request to the provided url.
  /// The response then is parsed to a list of ValueItem objects.
  Future<void> _fetchNetwork() async {
    setState(() {
      isLoading = true;
    });
    final result = await _performNetworkRequest();
    get(Uri.parse(networkConfig!.networkConfig!.url));
    if (result.statusCode == 200) {
      final data = json.decode(result.body);
      final List<ValueItem<T>> parsedOptions =
          await networkConfig!.responseParser!(data);
      _reponseBody = null;
      _options.addAll(parsedOptions);
    } else {
      _reponseBody = result.body;
    }
    setState(() {
      isLoading = false;
    });
  }

  /// Perform the network request according to the provided configuration.
  Future<Response> _performNetworkRequest() async {
    switch (networkConfig!.networkConfig!.method) {
      case RequestMethod.get:
        return await get(
          Uri.parse(networkConfig!.networkConfig!.url),
          headers: networkConfig!.networkConfig!.headers,
        );
      case RequestMethod.post:
        return await post(
          Uri.parse(networkConfig!.networkConfig!.url),
          body: networkConfig!.networkConfig!.body,
          headers: networkConfig!.networkConfig!.headers,
        );
      case RequestMethod.put:
        return await put(
          Uri.parse(networkConfig!.networkConfig!.url),
          body: networkConfig!.networkConfig!.body,
          headers: networkConfig!.networkConfig!.headers,
        );
      case RequestMethod.patch:
        return await patch(
          Uri.parse(networkConfig!.networkConfig!.url),
          body: networkConfig!.networkConfig!.body,
          headers: networkConfig!.networkConfig!.headers,
        );
      case RequestMethod.delete:
        return await delete(
          Uri.parse(networkConfig!.networkConfig!.url),
          headers: networkConfig!.networkConfig!.headers,
        );
      default:
        return await get(
          Uri.parse(networkConfig!.networkConfig!.url),
          headers: networkConfig!.networkConfig!.headers,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ThemeProvider(builder: (context, themeVm) {
      return Theme(
          data: themeVm.theme,
          child: DefaultDisabled(
              decorationBuilder: (themeVm) => DisabledDecoration(themeVm,
                  state: DisabledState(themeVm,
                      isDisabled: isLoading || decoration.disabled),
                  child: DisabledChild(themeVm,
                      child: Semantics(
                          button: true,
                          enabled: true,
                          child: CompositedTransformTarget(
                              link: _layerLink,
                              child: Focus(
                                  canRequestFocus: true,
                                  skipTraversal: true,
                                  focusNode: _focusNode,
                                  child: FormBuilderField<List<ValueItem<T>>>(
                                      name: form.name,
                                      validator: (value) {
                                        if (value == null) return null;
                                        return form.validator?.call(value);
                                      },
                                      initialValue: _selectedOptions,
                                      onChanged: (value) {
                                        if (value != null) {
                                          dpOptions.onOptionSelected
                                              ?.call(value);
                                        }
                                      },
                                      enabled: !decoration.disabled,
                                      builder: (field) {
                                        final errorText = field.errorText;
                                        final hasError = errorText != null;
                                        return Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              InkWell(
                                                splashFactory:
                                                    NoSplash.splashFactory,
                                                overlayColor:
                                                    MaterialStatePropertyAll(
                                                        FcnuiDefaultColor(
                                                                context)
                                                            .borderColor),
                                                radius: FcnuiDefaultSizes
                                                    .borderRadius,
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        FcnuiDefaultSizes
                                                            .borderRadius),
                                                onTap: _toggleFocus,
                                                child: decoration
                                                        .customWidget ??
                                                    AnimatedContainer(
                                                      duration: const Duration(
                                                          milliseconds: 200),
                                                      height:
                                                          decoration.wrapType ==
                                                                  WrapType.wrap
                                                              ? null
                                                              : decoration
                                                                      .height
                                                                      ?.h ??
                                                                  50.h,
                                                      constraints:
                                                          BoxConstraints(
                                                        minWidth: MediaQuery.of(
                                                                context)
                                                            .size
                                                            .width,
                                                        minHeight: decoration
                                                                .height?.h ??
                                                            50.h,
                                                      ),
                                                      padding:
                                                          _getContainerPadding(),
                                                      decoration:
                                                          _getContainerDecoration(
                                                              themeVm.theme,
                                                              hasError),
                                                      child: Row(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        children: [
                                                          Expanded(
                                                              child:
                                                                  _getContainerContent()),
                                                          if (_anyItemSelected) ...[
                                                            const SizedBox(
                                                                    width: FcnuiDefaultSizes
                                                                        .itemSpacing)
                                                                .w,
                                                            if (isMultiSelection &&
                                                                decoration
                                                                    .showClearIcon)
                                                              InkWell(
                                                                  onTap: () =>
                                                                      clear(),
                                                                  child:
                                                                      const Icon(
                                                                    Icons.close,
                                                                    size: FcnuiDefaultSizes
                                                                        .iconSize,
                                                                  )),
                                                            const SizedBox(
                                                                    width: FcnuiDefaultSizes
                                                                        .itemSpacing)
                                                                .w
                                                          ],
                                                          _buildSuffixIcon(),
                                                        ],
                                                      ),
                                                    ),
                                              ),
                                              if (hasError)
                                                Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 4.0),
                                                    child: Text(errorText,
                                                        style: TextStyle(
                                                            color:
                                                                FcnuiDefaultColor(
                                                                        context)
                                                                    .errorColor,
                                                            fontSize: 12.sp)))
                                            ]);
                                      }))))))));
    });
  }

  Widget _buildSuffixIcon() {
    return AnimatedRotation(
      turns: _selectionMode ? 0.5 : 0,
      duration: const Duration(milliseconds: 200),
      child: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Icon(
              Icons.keyboard_arrow_down_outlined,
              size: FcnuiDefaultSizes.iconSize,
              color: FcnuiDefaultColor(context).greyColor,
            ),
    );
  }

  /// Container Content for the dropdown.
  Widget _getContainerContent() {
    Widget column(String? value, Widget? child, {bool isGrey = false}) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (decoration.labelText != null)
            Text(
              decoration.labelText!,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          if (value != null)
            Text(
              value,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  color: isGrey ? FcnuiDefaultColor(context).greyColor : null),
            ),
          if (child != null) child,
        ],
      );
    }

    if (_selectedOptions.isEmpty ||
        decoration.showSelectedValuesContent == false) {
      return column(decoration.hintText, null, isGrey: true);
    }

    if (decoration.selectionType == SelectionType.single) {
      return column(_selectedOptions.first.label, null);
    }

    return column(null, _buildSelectedItems());
  }

  /// return true if any item is selected.
  bool get _anyItemSelected => _selectedOptions.isNotEmpty;

  /// Container decoration for the dropdown.
  Decoration _getContainerDecoration(ThemeData theme, bool hasError) {
    return BoxDecoration(
      color: decoration.isColorful
          ? theme.colorScheme.primary.withOpacity(.1)
          : FcnuiDefaultColor(context).borderColor,
      borderRadius: BorderRadius.circular(FcnuiDefaultSizes.borderRadius).r,
      border: Border.all(
              strokeAlign: BorderSide.strokeAlignOutside,
              color: hasError
                  ? FcnuiDefaultColor(context).errorColor
                  : (_selectionMode ? theme.primaryColor : Colors.transparent),
              width: _selectionMode
                  ? FcnuiDefaultSizes.selectedBorderWidth
                  : FcnuiDefaultSizes.borderWidth)
          .w,
    );
  }

  /// Build the selected items for the dropdown.
  Widget _buildSelectedItems() {
    if (decoration.wrapType == WrapType.ellipsis) {
      final List<String> texts = [];
      for (final item in _selectedOptions) {
        texts.add(item.label);
      }
      return Text(
        texts.join(", "),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: Theme.of(context).textTheme.bodyMedium,
      );
    }
    return Wrap(
        spacing: FcnuiDefaultSizes.itemSpacing,
        runSpacing: FcnuiDefaultSizes.itemSpacing,
        children: mapIndexed(_selectedOptions, (index, item) {
          return _buildSelectedItem(
              _selectedOptions[index],
              !_disabledOptions.contains(_selectedOptions[index]),
              index == _selectedOptions.length - 1);
        }).toList());
  }

  /// Build the selected item chip.
  Widget _buildSelectedItem(ValueItem<T> item, bool isEnabled, bool isLast) {
    return Text(
      "${item.label}${isLast ? "" : ","}",
      style: const TextStyle(fontWeight: FontWeight.normal),
      overflow: TextOverflow.ellipsis,
      maxLines: 1,
    );
  }

  /// Get the selectedItem icon for the dropdown
  Widget? _getSelectedIcon(bool isSelected, ThemeData theme) {
    return AnimatedOpacity(
      opacity: isSelected ? 1 : 0,
      duration: const Duration(milliseconds: 200),
      child: Icon(
        Icons.check,
        color: decoration.isColorful
            ? theme.primaryColor
            : theme.colorScheme.onSurface,
        size: FcnuiDefaultSizes.iconSize,
      ),
    );
  }

  Widget buildTransparentBox() {
    return Positioned.fill(
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: _onOutSideTap,
        child: const ColoredBox(
          color: Colors.transparent,
        ),
      ),
    );
  }

  /// Create the overlay entry for the dropdown.
  OverlayEntry _buildOverlayEntry() {
    // Calculate the offset and the size of the dropdown button
    final values = _calculateOffsetSize();
    // Get the size from the first item in the values list
    final size = values[0] as Size;
    // Get the showOnTop value from the second item in the values list
    final showOnTop = values[1] as bool;

    return OverlayEntry(builder: (context) {
      List<ValueItem<T>> options = _options;
      List<ValueItem<T>> selectedOptions = [..._selectedOptions];
      final theme = Theme.of(context);

      return StatefulBuilder(builder: ((context, dropdownState) {
        return Stack(
          children: [
            buildTransparentBox(),
            CompositedTransformFollower(
              link: _layerLink,
              showWhenUnlinked: true,
              targetAnchor:
                  showOnTop ? Alignment.topLeft : Alignment.bottomLeft,
              followerAnchor:
                  showOnTop ? Alignment.bottomLeft : Alignment.topLeft,
              offset: Offset(0, showOnTop ? -5 : 5).w,
              child: Material(
                  elevation: 1,
                  color: theme.colorScheme.surface,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(FcnuiDefaultSizes.borderRadius.r),
                    ),
                    side: BorderSide(
                        strokeAlign: BorderSide.strokeAlignInside,
                        color: FcnuiDefaultColor(context).borderColor,
                        width: FcnuiDefaultSizes.borderWidth),
                  ),
                  shadowColor: Colors.black12,
                  child: Container(
                    decoration: BoxDecoration(
                      color: theme.dividerColor.withOpacity(.2),
                      borderRadius: BorderRadius.circular(
                          FcnuiDefaultSizes.borderRadius.r),
                    ),
                    constraints: decoration.searchEnabled
                        ? BoxConstraints.loose(Size(size.width,
                            (decoration.dropdownMenuMaxHeight ?? 200) + 50))
                        : BoxConstraints.loose(Size(size.width,
                            (decoration.dropdownMenuMaxHeight ?? 200))),
                    child: _reponseBody != null && widget.networkConfig != null
                        ? Center(
                            child: networkConfig!.responseErrorBuilder!(
                                context, _reponseBody),
                          )
                        : Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (decoration.searchEnabled) ...[
                                ColoredBox(
                                  color: theme.dividerColor.withOpacity(.1),
                                  child: Padding(
                                    padding: const EdgeInsets.all(4.0).w,
                                    child: DefaultInput(
                                      decorationBuilder: (context) =>
                                          InputDecor(
                                        context,
                                        child: InputChild(context,
                                            name: "search",
                                            hintText: decoration.hintText ??
                                                "Search"),
                                        state: InputState(context,
                                            focusNode: _searchFocusNode),
                                        action: InputAction(context,
                                            onChanged: (value) {
                                          if (value == null) return;
                                          dropdownState(() {
                                            options = _options.where((element) {
                                              final label =
                                                  element.label.toLowerCase();
                                              final search =
                                                  value.toLowerCase();
                                              final subtitle = element.subtitle
                                                      ?.toLowerCase() ??
                                                  "";
                                              return label.contains(search) ||
                                                  subtitle.contains(search);
                                            }).toList();
                                          });
                                        }),
                                      ),
                                    ),
                                  ),
                                ),
                                Divider(height: 1.h),
                              ],
                              if (_options.isEmpty || options.isEmpty)
                                Expanded(
                                  child: Center(
                                    child: Text(
                                      "Not found",
                                      style: theme.textTheme.bodyMedium,
                                    ),
                                  ),
                                )
                              else
                                Expanded(
                                  child: ListView.separated(
                                    physics: const ClampingScrollPhysics(),
                                    separatorBuilder: (_, __) => SizedBox(
                                            height: isMultiSelection ? 2 : 0)
                                        .w,
                                    padding: const EdgeInsets.all(4).w,
                                    itemCount: options.length,
                                    itemBuilder: (context, index) {
                                      final option = options[index];
                                      final isSelected =
                                          selectedOptions.contains(option);

                                      onTap() {
                                        if (decoration.selectionType ==
                                            SelectionType.multi) {
                                          if (isSelected) {
                                            dropdownState(() {
                                              selectedOptions.remove(option);
                                            });
                                            setState(() {
                                              _selectedOptions.remove(option);
                                            });
                                            dpOptions.onOptionRemoved
                                                ?.call(index, option);
                                          } else {
                                            final bool hasReachMax =
                                                dpOptions.maxItems == null
                                                    ? false
                                                    : (_selectedOptions.length +
                                                            1) >
                                                        dpOptions.maxItems!;
                                            if (hasReachMax) return;

                                            dropdownState(() {
                                              selectedOptions.add(option);
                                            });
                                            setState(() {
                                              _selectedOptions.add(option);
                                            });
                                          }
                                        } else {
                                          if (isSelected) {
                                            dropdownState(() {
                                              selectedOptions.clear();
                                              selectedOptions.add(option);
                                            });
                                            setState(() {
                                              _selectedOptions.clear();
                                            });
                                          } else {
                                            dropdownState(() {
                                              selectedOptions.clear();
                                              selectedOptions.add(option);
                                            });
                                            setState(() {
                                              _selectedOptions.clear();
                                              _selectedOptions.add(option);
                                            });
                                          }
                                          _focusNode.unfocus();
                                        }

                                        _controller.value._selectedOptions
                                            .clear();
                                        _controller.value._selectedOptions
                                            .addAll(_selectedOptions);

                                        dpOptions.onOptionSelected
                                            ?.call(_selectedOptions);
                                      }

                                      if (decoration.optionBuilder != null) {
                                        return InkWell(
                                          onTap: onTap,
                                          splashFactory: NoSplash.splashFactory,
                                          child: decoration.optionBuilder!(
                                              context, option, isSelected),
                                        );
                                      }

                                      final primaryColor =
                                          Theme.of(context).primaryColor;

                                      return _buildOption(
                                        option: option,
                                        primaryColor: primaryColor,
                                        isSelected: isSelected,
                                        dropdownState: dropdownState,
                                        onTap: onTap,
                                        selectedOptions: selectedOptions,
                                        theme: Theme.of(context),
                                      );
                                    },
                                  ),
                                ),
                            ],
                          ),
                  )),
            ),
          ],
        );
      }));
    });
  }

  Widget _buildOption(
      {required ValueItem<T> option,
      required Color primaryColor,
      required bool isSelected,
      required StateSetter dropdownState,
      required void Function() onTap,
      required List<ValueItem<T>> selectedOptions,
      required ThemeData theme}) {
    bool enabled = true;

    //if disabled contains the option, then it is disabled.
    if (_disabledOptions.contains(option)) {
      enabled = false;
    }

    bool hasReachedMax = dpOptions.maxItems == null
        ? false
        : (_selectedOptions.length + 1) > dpOptions.maxItems!;
    //if _selectedOptions.length is equal to maxItems, then it is disabled.
    if (hasReachedMax) {
      if (isSelected == false) {
        enabled = false;
      }
    }

    if (dpOptions.optionItemBuilder != null) {
      return DefaultDisabled(
          decorationBuilder: (themeVm) => DisabledDecoration(themeVm,
              state: DisabledState(themeVm, isDisabled: !enabled),
              child: DisabledChild(themeVm,
                  child: InkWell(
                      onTap: onTap,
                      splashFactory: NoSplash.splashFactory,
                      child: dpOptions.optionItemBuilder!(
                          context, option, isSelected)))));
    }

    return ListTile(
      key: ValueKey(option.value),
      splashColor: Colors.transparent,
      mouseCursor:
          enabled ? SystemMouseCursors.click : SystemMouseCursors.forbidden,
      title: Text(option.label),
      subtitle: option.subtitle != null ? Text(option.subtitle!) : null,
      horizontalTitleGap: 10.w,
      titleTextStyle: theme.textTheme.bodyMedium,
      subtitleTextStyle: theme.textTheme.bodySmall!
          .copyWith(color: theme.colorScheme.onSurface.withOpacity(0.6)),
      selectedColor:
          decoration.isColorful ? primaryColor : theme.colorScheme.onSurface,
      selected: isSelected,
      autofocus: true,
      dense: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0).w,
      shape: RoundedRectangleBorder(
          borderRadius:
              BorderRadius.circular(FcnuiDefaultSizes.borderRadius).r),
      tileColor: theme.colorScheme.surface,
      selectedTileColor: decoration.isColorful
          ? theme.primaryColor.withOpacity(.1)
          : FcnuiDefaultColor(context).borderColor,
      enabled: enabled,
      onTap: onTap,
      trailing: _getSelectedIcon(isSelected, theme),
      leading: option.icon,
    );
  }

  // get the container padding.
  EdgeInsetsGeometry _getContainerPadding() {
    if (decoration.selectionType == SelectionType.single) {
      return const EdgeInsets.symmetric(
              horizontal: FcnuiDefaultSizes.paddingHorizontal)
          .w;
    } else {
      return const EdgeInsets.symmetric(
              horizontal: FcnuiDefaultSizes.paddingHorizontal)
          .w;
    }
  }
}

/// [SelectionType]
/// SelectionType enum for the selection type of the dropdown items.
/// * [single]: single selection
/// * [multi]: multi selection
enum SelectionType {
  single,
  multi,
}

/// [WrapType]
/// WrapType enum for the wrap type of the selected items.
/// * [WrapType.scroll]: scroll the selected items horizontally
/// * [WrapType.wrap]: wrap the selected items in both directions
enum WrapType { ellipsis, wrap }

/// [RequestMethod]
/// RequestMethod enum for the request method of the dropdown items.
/// * [RequestMethod.get]: get request
/// * [RequestMethod.post]: post request
/// * [RequestMethod.put]: put request
/// * [RequestMethod.delete]: delete request
/// * [RequestMethod.patch]: patch request
enum RequestMethod { get, post, put, patch, delete }

/// Configuration for the network.
///
/// [url] is the url of the network.
/// [method] is the request method of the network.
/// [headers] is the headers of the network.
/// [body] is the body of the network.
/// [queryParameters] is the query parameters of the network.

class NetworkConfig {
  final String url;
  final RequestMethod method;
  final Map<String, String>? headers;
  final Map<String, dynamic>? body;
  final Map<String, dynamic>? queryParameters;

  NetworkConfig({
    required this.url,
    this.method = RequestMethod.get,
    this.headers = const {},
    this.body,
    this.queryParameters = const {},
  });
}

/// [label] is the item that is displayed in the list. [value] is the value that is returned when the item is selected.
/// If the [value] is not provided, the [label] is used as the value.
/// An example of a [ValueItem] is:
/// ```dart
/// const ValueItem(label: 'Option 1', value: '1')
/// ```

class ValueItem<T> extends Equatable {
  /// The label of the value item
  final String label;

  final String? subtitle;

  /// The value of the value item
  final T? value;

  final Widget? icon;

  /// Default constructor for [ValueItem]
  const ValueItem(
      {required this.label, required this.value, this.subtitle, this.icon});

  /// toString method for [ValueItem]
  @override
  String toString() {
    return 'ValueItem(label: $label, value: $value, subtitle: $subtitle)';
  }

  /// toMap method for [ValueItem]
  Map<String, dynamic> toMap() {
    return {
      'label': label,
      'value': value,
      'subtitle': subtitle,
      'icon': icon,
    };
  }

  /// fromMap method for [ValueItem]
  factory ValueItem.fromMap(Map<String, dynamic> map) {
    return ValueItem<T>(
      label: map['label'] ?? '',
      value: map['value'],
      subtitle: map['subtitle'],
      icon: map['icon'],
    );
  }

  /// toJson method for [ValueItem]
  String toJson() => json.encode(toMap());

  /// fromJson method for [ValueItem]
  factory ValueItem.fromJson(String source) =>
      ValueItem<T>.fromMap(json.decode(source));

  /// CopyWith method for [ValueItem]
  ValueItem<T> copyWith({
    String? label,
    T? value,
    String? subtitle,
    Widget? icon,
  }) {
    return ValueItem<T>(
      label: label ?? this.label,
      value: value ?? this.value,
      subtitle: subtitle ?? this.subtitle,
      icon: icon ?? this.icon,
    );
  }

  @override
  List<Object?> get props => [label, value, subtitle, icon];
}

typedef OnOptionSelected<T> = void Function(List<ValueItem<T>> selectedOptions);

class SelectDecoration<T> extends Equatable {
  final String? hintText;

  final String? labelText;

  // selection type of the dropdown
  final SelectionType selectionType;

  // options configuration
  final double? dropdownHeight;

  /// Controller for the dropdown
  /// [controller] is the controller for the dropdown. It can be used to programmatically open and close the dropdown.
  final SelectController<T>? controller;

  /// Enable search
  /// [searchEnabled] is the flag to enable search in dropdown. It is used to show search bar in dropdown.
  final bool searchEnabled;

  /// Use this if [customWidget] is provided
  ///
  /// Else it will calculate the size of the dropdown based on
  ///
  /// the size of the widget
  final Size? dropdownMenuSize;

  final double? dropdownMenuMaxHeight;

  final Widget? customWidget;

  final bool disabled;

  /// option builder
  /// [optionBuilder] is the builder that is used to build the option item.
  /// The builder takes three arguments, the context, the option and the selected status of the option.
  /// The builder returns a widget.
  ///

  final Widget Function(BuildContext ctx, ValueItem<T> option, bool selected)?
      optionBuilder;

  final WrapType wrapType;

  final bool showSelectedValuesContent;

  final bool showClearIcon;

  final bool isColorful;

  final double? height;

  const SelectDecoration({
    this.hintText,
    this.selectionType = SelectionType.single,
    this.dropdownHeight,
    this.height,
    this.showClearIcon = false,
    this.showSelectedValuesContent = true,
    this.controller,
    this.searchEnabled = false,
    this.dropdownMenuSize,
    this.dropdownMenuMaxHeight,
    this.customWidget,
    this.optionBuilder,
    this.wrapType = WrapType.ellipsis,
    this.disabled = false,
    this.labelText,
    this.isColorful = false,
  });

  @override
  List<Object?> get props => [
        hintText,
        selectionType,
        dropdownHeight,
        controller,
        searchEnabled,
        dropdownMenuSize,
        dropdownMenuMaxHeight,
        customWidget,
        wrapType,
        disabled,
        labelText,
        showSelectedValuesContent,
        showClearIcon,
        isColorful,
        height,
      ];
}

class SelectForm<T> extends IFormModel {
  const SelectForm({
    required super.name,
    this.validator,
  });

  //validator
  final String? Function(List<ValueItem<T>>)? validator;

  @override
  List<Object?> get props => [name, validator];
}

class SelectOptions<T> extends Equatable {
  final List<ValueItem<T>> options;
  final List<ValueItem<T>> selectedOptions;
  final List<ValueItem<T>> disabledOptions;

  final OnOptionSelected<T>? onOptionSelected;

  /// [onOptionRemoved] is the callback that is called when an option is removed.The callback takes two arguments, the index of the removed option and the removed option.
  /// This will be called only when the delete icon is clicked on the option chip.
  ///
  /// This will not be called when the option is removed programmatically.
  ///
  /// ```index``` is the index of the removed option.
  ///
  /// ```option``` is the removed option.
  final void Function(int index, ValueItem<T> option)? onOptionRemoved;

  /// Maximum number of items that can be selected
  final int? maxItems;

  final Widget Function(BuildContext context, ValueItem<T>, bool isSelected)?
      optionItemBuilder;

  const SelectOptions({
    this.options = const [],
    this.selectedOptions = const [],
    this.disabledOptions = const [],
    this.onOptionSelected,
    this.onOptionRemoved,
    this.maxItems,
    this.optionItemBuilder,
  });

  @override
  List<Object?> get props => [
        options,
        selectedOptions,
        disabledOptions,
        maxItems,
      ];
}

class SelectNetwork<T> extends Equatable {
  const SelectNetwork({
    required this.networkConfig,
    required this.responseParser,
    this.responseErrorBuilder,
  });

  final NetworkConfig? networkConfig;
  final Future<List<ValueItem<T>>> Function(dynamic)? responseParser;
  final Widget Function(BuildContext, dynamic)? responseErrorBuilder;

  @override
  List<Object?> get props =>
      [networkConfig, responseParser, responseErrorBuilder];
}

/// MultiSelect Controller class.
/// This class is used to control the state of the MultiDefaultSelect widget.
/// This is just base class. The implementation of this class is in the SelectController class.
/// The implementation of this class is hidden from the user.
class _SelectController<T> {
  final List<ValueItem<T>> _disabledOptions = [];
  final List<ValueItem<T>> _options = [];
  final List<ValueItem<T>> _selectedOptions = [];
  bool _isDropdownOpen = false;
}

/// implementation of the SelectController class.
class SelectController<T> extends ValueNotifier<_SelectController<T>> {
  SelectController() : super(_SelectController());

  bool _isDisposed = false;

  bool get isDisposed => _isDisposed;

  /// set the dispose method.
  @override
  void dispose() {
    super.dispose();
    _isDisposed = true;
  }

  /// Clear the selected options.
  /// [SelectController] is used to clear the selected options.
  void clearAllSelection() {
    value._selectedOptions.clear();
    notifyListeners();
  }

  /// clear specific selected option
  /// [SelectController] is used to clear specific selected option.
  void clearSelection(ValueItem<T> option) {
    if (!value._selectedOptions.contains(option)) return;

    if (value._disabledOptions.contains(option)) {
      throw Exception('Cannot clear selection of a disabled option');
    }

    if (!value._options.contains(option)) {
      throw Exception(
          'Cannot clear selection of an option that is not in the options list');
    }

    value._selectedOptions.remove(option);
    notifyListeners();
  }

  /// select the options
  /// [SelectController] is used to select the options.
  void setSelectedOptions(List<ValueItem<T>> options) {
    if (options.any((element) => value._disabledOptions.contains(element))) {
      throw Exception('Cannot select disabled options');
    }

    if (options.any((element) => !value._options.contains(element))) {
      throw Exception('Cannot select options that are not in the options list');
    }

    value._selectedOptions.clear();
    value._selectedOptions.addAll(options);
    notifyListeners();
  }

  /// add selected option
  /// [SelectController] is used to add selected option.
  void addSelectedOption(ValueItem<T> option) {
    if (value._disabledOptions.contains(option)) {
      throw Exception('Cannot select disabled option');
    }

    if (!value._options.contains(option)) {
      throw Exception('Cannot select option that is not in the options list');
    }

    value._selectedOptions.add(option);
    notifyListeners();
  }

  /// set disabled options
  /// [SelectController] is used to set disabled options.
  void setDisabledOptions(List<ValueItem<T>> disabledOptions) {
    if (disabledOptions.any((element) => !value._options.contains(element))) {
      throw Exception(
          'Cannot disable options that are not in the options list');
    }

    value._disabledOptions.clear();
    value._disabledOptions.addAll(disabledOptions);
    notifyListeners();
  }

  /// setDisabledOption method
  /// [SelectController] is used to set disabled option.
  void setDisabledOption(ValueItem<T> disabledOption) {
    if (!value._options.contains(disabledOption)) {
      throw Exception('Cannot disable option that is not in the options list');
    }

    value._disabledOptions.add(disabledOption);
    notifyListeners();
  }

  /// set options
  /// [SelectController] is used to set options.
  void setOptions(List<ValueItem<T>> options) {
    value._options.clear();
    value._options.addAll(options);
    notifyListeners();
  }

  /// get disabled options
  List<ValueItem<T>> get disabledOptions => value._disabledOptions;

  /// get enabled options
  List<ValueItem<T>> get enabledOptions => value._options
      .where((element) => !value._disabledOptions.contains(element))
      .toList();

  /// get options
  List<ValueItem<T>> get options => value._options;

  /// get selected options
  List<ValueItem<T>> get selectedOptions => value._selectedOptions;

  /// get is dropdown open
  bool get isDropdownOpen => value._isDropdownOpen;

  /// open dropdown
  /// [SelectController] is used to open dropdown.
  void openDropdown() {
    if (value._isDropdownOpen) return;
    value._isDropdownOpen = true;
    notifyListeners();
  }

  /// close dropdown
  /// [SelectController] is used to close dropdown.
  void closeDropdown() {
    if (!value._isDropdownOpen) return;
    value._isDropdownOpen = false;
    notifyListeners();
  }
}

import 'package:fcnui_base/fcnui_base.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'select.dart';
import 'pagination.dart';
import 'card.dart';
import 'input.dart';

extension PlutoRowExtension on PlutoRow {
  DefaultRow toDefaultRow() {
    return DefaultRow(
      rowKey: key,
      cells: cells.entries
          .map((e) => DefaultCell(
                key: e.key,
                value: e.value.value,
              ))
          .toList(),
    );
  }
}

extension PlutoColumnExtension on PlutoColumn {
  DefaultColumn toDefaultColumn() {
    return DefaultColumn(
      name: title,
      key: field,
      type:
          type == PlutoColumnType.text() ? ColumnType.text : ColumnType.number,
      hasCheckbox: enableRowChecked,
      hasSort: enableSorting,
      footerWidget: footerRenderer != null
          ? (rows) {
              final addedAll = rows.fold<int>(0, (previousValue, element) {
                return previousValue +
                    (element.cells
                        .firstWhere(
                          (element) => element.key == field,
                        )
                        .value as int);
              });
              return Center(child: Text("Total: $addedAll"));
            }
          : null,
    );
  }
}

extension PlutoCellExtension on PlutoCell {
  DefaultCell toDefaultCell() {
    return DefaultCell(
      cellKey: key,
      key: column.field,
      value: value,
    );
  }
}

class TableController extends Equatable {
  final List<DefaultColumn> columns;
  final List<DefaultRow> rows;
  final void Function(List<DefaultRow>) onAddRows;
  final void Function(List<DefaultRow>) onRemoveRows;
  final List<DefaultRow> Function() getSelectedRows;

  /// If [isAscending] parameter is null, the table will toggle the sort direction
  final void Function(DefaultColumn column, {bool? isAscending}) onSortBy;
  final void Function() onClearSort;
  final void Function() onUnselectAll;
  final void Function() onSelectAll;
  final void Function() onToggleSelectAll;
  final void Function(DefaultColumn column) onHideColumn;
  final void Function(DefaultColumn column) onShowColumn;
  final void Function(DefaultColumn column) onToggleColumnVisibility;

  DefaultColumn getColumnOfCell(DefaultCell cell) {
    try {
      return columns.firstWhere((element) => element.key == cell.key);
    } catch (e) {
      throw Exception('Column not found');
    }
  }

  const TableController({
    required this.columns,
    required this.rows,
    required this.onAddRows,
    required this.onRemoveRows,
    required this.getSelectedRows,
    required this.onSortBy,
    required this.onClearSort,
    required this.onHideColumn,
    required this.onSelectAll,
    required this.onToggleSelectAll,
    required this.onUnselectAll,
    required this.onShowColumn,
    required this.onToggleColumnVisibility,
  });

  @override
  List<Object> get props => [columns, rows];
}

enum ColumnType { text, number }

typedef FooterWidget = Widget Function(List<DefaultRow> rows);
typedef CellWidget = Widget Function(DefaultCell cell, int rowIndex);
typedef FormatterCallback = String Function(dynamic value);

@immutable
class DefaultColumn extends Equatable {
  final String name;

  /// The key must be unique
  final String key;
  final ColumnType type;
  final bool hasCheckbox;
  final bool hasSort;
  final double? width;

  /// Does not apply if [cellWidget] is not null
  final TextAlign? cellTextAlign;
  final TextAlign? titleTextAlign;
  final Widget? titleWidget;

  //Callbacks
  final FooterWidget? footerWidget;

  /// Use this to change the cell widget
  ///
  /// If needs to format the cell value, use [formatter]
  final CellWidget? cellWidget;

  /// Use this to format the cell value
  ///
  /// If needs to change the widget completely, use [cellWidget]
  ///
  /// ex: (value) => value.toStringAsFixed(2)
  final FormatterCallback? formatter;

  DefaultColumn({
    required this.name,
    required this.type,
    required this.key,
    this.hasCheckbox = false,
    this.hasSort = true,
    this.footerWidget,
    this.cellWidget,
    this.formatter,
    this.width,
    this.cellTextAlign,
    this.titleTextAlign,
    this.titleWidget,
  }) : assert(key.isNotEmpty, 'Key cannot be empty') {
    PlutoColumnType getType() {
      return switch (type) {
        ColumnType.text => PlutoColumnType.text(),
        ColumnType.number => PlutoColumnType.number(),
      };
    }

    plutoColumn = PlutoColumn(
      title: name,
      field: key,
      enableContextMenu: false,
      enableAutoEditing: false,
      enableEditingMode: false,
      enableDropToResize: false,
      enableRowDrag: false,
      enableColumnDrag: false,
      enableRowChecked: hasCheckbox,
      enableSorting: hasSort,
      type: getType(),
      footerRenderer: footerWidget == null
          ? null
          : (colContext) {
              final rows = colContext.stateManager.rows
                  .map((e) => e.toDefaultRow())
                  .toList();
              return footerWidget!(rows);
            },
      renderer: cellWidget == null
          ? null
          : (cellContext) {
              return cellWidget!(
                cellContext.cell.toDefaultCell(),
                cellContext.rowIdx,
              );
            },
      formatter: formatter == null
          ? null
          : (value) {
              return formatter!(value);
            },
      width: width ?? PlutoGridSettings.columnWidth,
      cellPadding: cellWidget != null ? EdgeInsets.zero : null,
      titleTextAlign: PlutoColumnTextAlign.values.firstWhere(
          (element) => element.name == titleTextAlign?.name, orElse: () {
        return PlutoColumnTextAlign.left;
      }),
      textAlign: PlutoColumnTextAlign.values.firstWhere(
          (element) => element.name == cellTextAlign?.name, orElse: () {
        return PlutoColumnTextAlign.left;
      }),
      titleSpan: titleWidget == null ? null : WidgetSpan(child: titleWidget!),
    );
  }

  late final PlutoColumn plutoColumn;

  @override
  List<Object> get props => [name, type, hasCheckbox, key, hasSort];
}

@immutable
class DefaultRow extends Equatable {
  final List<DefaultCell> cells;

  late final PlutoRow plutoRow;

  final Key? rowKey;

  DefaultRow({required this.cells, this.rowKey})
      //assert that the keys are unique
      : assert(cells.map((e) => e.key).toSet().length == cells.length,
            'Cell keys must be unique') {
    plutoRow = PlutoRow(
      key: rowKey,
      cells: Map.fromEntries(cells.map((e) => MapEntry(e.key, e.plutoCell))),
    );
  }

  @override
  List<Object> get props => [cells];
}

@immutable
class DefaultCell extends Equatable {
  /// The key is the column key and must match
  final String key;
  final dynamic value;

  late final PlutoCell plutoCell;

  final Key? cellKey;

  DefaultCell({required this.value, required this.key, this.cellKey}) {
    parseValue() {
      if (value is! num) {
        if (value is String) {
          if (num.tryParse(value) != null) {
            return num.parse(value);
          }
        }
      }
      return value;
    }

    plutoCell = PlutoCell(key: cellKey, value: parseValue());
  }

  @override
  List<Object> get props => [value, key];
}

typedef GetTableController = void Function(TableController tableController);

@immutable
class TableVm extends Equatable {
  final List<DefaultColumn> columns;
  final List<DefaultRow> rows;
  final GetTableController getTableController;
  final TableLocaleText localeText;
  final bool selectWithOneTap;

  final TableDecoration decoration;

  TableVm({
    required this.columns,
    this.rows = const [],
    this.localeText = const TableLocaleText(),
    required this.getTableController,
    this.decoration = const TableDecoration(),
    this.selectWithOneTap = true,
  })  : assert(columns.isNotEmpty, 'Columns cannot be empty'),
        assert(columns.map((e) => e.key).toSet().length == columns.length,
            'Column keys must be unique');

  @override
  List<Object?> get props =>
      [columns, rows, localeText, decoration, selectWithOneTap];
}

class TableLocaleText extends Equatable {
  final String noRows;

  const TableLocaleText({this.noRows = "No rows to display"});

  TableLocaleText copyWith({String? noRows}) {
    return TableLocaleText(noRows: noRows ?? this.noRows);
  }

  @override
  List<Object?> get props => [noRows];
}

@immutable
class TableDecoration extends Equatable {
  final bool enableWrapper;
  final CardDecoration? wrapperDecoration;
  final bool isVerticalBorderVisible;
  final bool isHorizontalBorderVisible;
  final Color? checkedRowColor;
  final Color? idleRowColor;
  final Color? gridBackgroundColor;
  final Color? gridBorderColor;
  final TextStyle? columnTextStyle;
  final TextStyle? cellTextStyle;
  final Icon? sortAscendingIcon;
  final Icon? sortDescendingIcon;
  final double? defaultColumnHeight;
  final double? defaultRowHeight;

  /// If [cellWidget] is null, this padding will be used
  ///
  /// If [cellWidget] is not null, the padding will be set to zero
  final EdgeInsets? defaultCellPadding;
  final EdgeInsets? defaultColumnTitlePadding;
  final Color? evenRowColor;
  final Color? oddRowColor;
  final bool enableHeader;
  final bool enableFooter;

  const TableDecoration({
    this.wrapperDecoration,
    this.isVerticalBorderVisible = false,
    this.isHorizontalBorderVisible = true,
    this.checkedRowColor,
    this.idleRowColor,
    this.gridBackgroundColor,
    this.gridBorderColor,
    this.columnTextStyle,
    this.cellTextStyle,
    this.sortAscendingIcon,
    this.sortDescendingIcon,
    this.defaultColumnHeight,
    this.defaultRowHeight,
    this.defaultCellPadding,
    this.defaultColumnTitlePadding,
    this.evenRowColor,
    this.oddRowColor,
    this.enableHeader = true,
    this.enableFooter = true,
    this.enableWrapper = true,
  });

  @override
  List<Object?> get props => [
        wrapperDecoration,
        isVerticalBorderVisible,
        isHorizontalBorderVisible,
        checkedRowColor,
        idleRowColor,
        gridBackgroundColor,
        gridBorderColor,
        columnTextStyle,
        cellTextStyle,
        sortAscendingIcon,
        sortDescendingIcon,
        defaultColumnHeight,
        defaultRowHeight,
        defaultCellPadding,
        defaultColumnTitlePadding,
        evenRowColor,
        oddRowColor,
        enableHeader,
        enableFooter,
      ];
}

class DefaultTable extends StatefulWidget {
  const DefaultTable({super.key, required this.vm});

  final TableVm vm;

  @override
  State<DefaultTable> createState() => _DefaultTableState();
}

class _DefaultTableState extends State<DefaultTable> {
  TableVm get vm => widget.vm;

  TableDecoration get decoration => vm.decoration;

  late final PlutoGridStateManager stateManager;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {});
  }

  PlutoGridConfiguration getConfig(ThemeVm themeVm) {
    final bool isDarkMode = themeVm.themeMode == ThemeMode.dark;
    final theme = themeVm.theme;

    PlutoGridColumnSizeConfig sizeConfig() {
      return const PlutoGridColumnSizeConfig(
        autoSizeMode: PlutoAutoSizeMode.scale,
      );
    }

    //Decoration related settings
    PlutoGridStyleConfig getStyle(ThemeData theme) {
      final borderColor =
          decoration.gridBorderColor ?? Colors.grey.withOpacity(.1);
      if (isDarkMode) {
        return PlutoGridStyleConfig.dark(
          // gridBorderRadius: decoration.wrapperDecoration.borderRadius,//todo:
          gridBorderColor: borderColor,
          borderColor: borderColor,
          inactivatedBorderColor: borderColor,
          enableCellBorderHorizontal: decoration.isHorizontalBorderVisible,
          enableCellBorderVertical: decoration.isVerticalBorderVisible,
          enableColumnBorderHorizontal: decoration.isHorizontalBorderVisible,
          enableColumnBorderVertical: decoration.isVerticalBorderVisible,
          rowColor:
              decoration.idleRowColor ?? theme.dividerColor.withOpacity(.5),
          checkedColor: decoration.checkedRowColor ??
              theme.colorScheme.primary.withOpacity(.1),
          activatedBorderColor: theme.colorScheme.primary,
          gridBackgroundColor: decoration.gridBackgroundColor ??
              theme.dividerColor.withOpacity(.5),
          activatedColor: decoration.gridBackgroundColor ??
              theme.dividerColor.withOpacity(.5),
          columnTextStyle: decoration.columnTextStyle ??
              theme.textTheme.titleSmall!.copyWith(
                  color: theme.colorScheme.onSurface.withOpacity(0.5)),
          cellTextStyle:
              decoration.cellTextStyle ?? theme.textTheme.bodyMedium!,
          columnAscendingIcon: decoration.sortAscendingIcon ??
              const Icon(Icons.keyboard_arrow_up_outlined),
          columnDescendingIcon: decoration.sortDescendingIcon ??
              const Icon(Icons.keyboard_arrow_down_outlined),
          columnHeight: decoration.defaultColumnHeight ?? 42.h,
          rowHeight: decoration.defaultRowHeight ?? 42.h,
          defaultColumnTitlePadding: decoration.defaultColumnTitlePadding ??
              EdgeInsets.symmetric(horizontal: 16.w),
          defaultCellPadding: decoration.defaultCellPadding ??
              EdgeInsets.symmetric(horizontal: 16.w),
          evenRowColor: decoration.evenRowColor,
          oddRowColor: decoration.oddRowColor,
        );
      }
      return PlutoGridStyleConfig(
        // gridBorderRadius: decoration.wrapperDecoration.borderRadius, //todo:
        gridBorderColor: borderColor,
        borderColor: borderColor,
        inactivatedBorderColor: borderColor,
        enableCellBorderHorizontal: decoration.isHorizontalBorderVisible,
        enableCellBorderVertical: decoration.isVerticalBorderVisible,
        enableColumnBorderHorizontal: decoration.isHorizontalBorderVisible,
        enableColumnBorderVertical: decoration.isVerticalBorderVisible,
        rowColor: decoration.idleRowColor ?? theme.colorScheme.surface,
        checkedColor: decoration.checkedRowColor ??
            theme.colorScheme.primary.withOpacity(.1),
        activatedBorderColor: theme.colorScheme.primary,
        gridBackgroundColor:
            decoration.gridBackgroundColor ?? theme.colorScheme.surface,
        activatedColor:
            decoration.gridBackgroundColor ?? theme.colorScheme.surface,
        columnTextStyle: decoration.columnTextStyle ??
            theme.textTheme.titleSmall!
                .copyWith(color: theme.colorScheme.onSurface.withOpacity(0.5)),
        cellTextStyle: decoration.cellTextStyle ?? theme.textTheme.bodyMedium!,
        columnAscendingIcon: decoration.sortAscendingIcon ??
            const Icon(Icons.keyboard_arrow_up_outlined),
        columnDescendingIcon: decoration.sortDescendingIcon ??
            const Icon(Icons.keyboard_arrow_down_outlined),
        columnHeight: decoration.defaultColumnHeight ?? 42.h,
        rowHeight: decoration.defaultRowHeight ?? 42.h,
        defaultColumnTitlePadding: decoration.defaultColumnTitlePadding ??
            EdgeInsets.symmetric(horizontal: 16.w),
        defaultCellPadding: decoration.defaultCellPadding ??
            EdgeInsets.symmetric(horizontal: 16.w),
        evenRowColor: decoration.evenRowColor,
        oddRowColor: decoration.oddRowColor,
      );
    }

    PlutoGridScrollbarConfig getScrollbar(ThemeData theme) {
      return const PlutoGridScrollbarConfig();
    }

    if (isDarkMode) {
      return PlutoGridConfiguration.dark(
        columnSize: sizeConfig(),
        style: getStyle(theme),
        scrollbar: getScrollbar(theme),
      );
    }

    return PlutoGridConfiguration(
      columnSize: sizeConfig(),
      style: getStyle(theme),
      scrollbar: getScrollbar(theme),
    );
  }

  Widget getNoRowsWidget(ThemeData theme) {
    return Center(
      child: Text(
        vm.localeText.noRows,
        style: theme.textTheme.bodyLarge!.copyWith(
          color: theme.colorScheme.onSurface.withOpacity(0.4),
        ),
      ),
    );
  }

  Widget getTable(ThemeVm themeVm) {
    final theme = themeVm.theme;
    return SizedBox(
      width: double.infinity,
      height: 700,
      child: Theme(
        data: theme,
        child: PlutoGrid(
          configuration: getConfig(themeVm),
          createHeader: decoration.enableHeader
              ? (stateManager) => _Header(stateManager: stateManager)
              : null,
          createFooter: decoration.enableFooter
              ? (stateManager) => _Footer(stateManager: stateManager)
              : null,
          mode: PlutoGridMode.selectWithOneTap,
          onSelected: (event) {
            if (vm.selectWithOneTap) {
              if (event.row != null) {
                if (event.row!.checked != null) {
                  stateManager.setRowChecked(event.row!, !event.row!.checked!);
                }
              }
            }
          },
          noRowsWidget: getNoRowsWidget(theme),
          columns: vm.columns.map((e) => e.plutoColumn).toList(),
          rows: vm.rows.map((e) => e.plutoRow).toList(),
          onLoaded: handleOnLoadedEvent,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ThemeProvider(builder: (context, themeVm) {
      if (vm.decoration.enableWrapper) {
        return getTable(themeVm);
      } else {
        return getTable(themeVm);
      }
    });
  }

  void handleOnLoadedEvent(PlutoGridOnLoadedEvent event) {
    this.stateManager = event.stateManager;
    final stateManager = event.stateManager;

    stateManager.setPageSize(10);
    stateManager.addListener(() {
      setState(() {});
    });
    stateManager.keyManager!.eventResult.skip(KeyEventResult.ignored);
    vm.getTableController(TableController(
      columns: vm.columns,
      rows: vm.rows,
      onAddRows: (row) {
        stateManager.appendRows(row.map((e) => e.plutoRow).toList());
      },
      onRemoveRows: (rows) {
        stateManager.removeRows(rows.map((e) => e.plutoRow).toList());
      },
      getSelectedRows: () {
        return stateManager.checkedRows.map((e) => e.toDefaultRow()).toList();
      },
      onSortBy: (column, {isAscending}) {
        if (isAscending == null) {
          if (column.plutoColumn.sort.isAscending) {
            stateManager.sortDescending(column.plutoColumn);
          } else {
            stateManager.sortAscending(column.plutoColumn);
          }
        } else {
          if (isAscending) {
            stateManager.sortAscending(column.plutoColumn);
          } else {
            stateManager.sortDescending(column.plutoColumn);
          }
        }
      },
      onClearSort: () {
        final column = stateManager.getSortedColumn;
        if (column != null) {
          //if ascending, toggle 2 times to clear
          //if descending, toggle 1 time to clear
          if (column.sort.isAscending) {
            stateManager.toggleSortColumn(column);
            stateManager.toggleSortColumn(column);
          } else {
            stateManager.toggleSortColumn(column);
          }
        }
      },
      onSelectAll: () {
        stateManager.toggleAllRowChecked(true);
      },
      onUnselectAll: () {
        stateManager.toggleAllRowChecked(false);
      },
      onToggleSelectAll: () {
        if (stateManager.hasCheckedRow) {
          stateManager.toggleAllRowChecked(false);
        } else {
          stateManager.toggleAllRowChecked(true);
        }
      },
      onHideColumn: (column) {
        stateManager.hideColumn(column.plutoColumn, true);
      },
      onShowColumn: (column) {
        stateManager.hideColumn(column.plutoColumn, false);
      },
      onToggleColumnVisibility: (column) {
        stateManager.hideColumn(column.plutoColumn, !column.plutoColumn.hide);
      },
    ));
    setState(() {});
  }
}

class _Header extends StatefulWidget {
  final PlutoGridStateManager stateManager;

  const _Header({required this.stateManager});

  @override
  State<_Header> createState() => _HeaderState();
}

class _HeaderState extends State<_Header> {
  PlutoGridStateManager get stateManager => widget.stateManager;
  FocusNode focusNode = FocusNode();

  final List<PlutoColumn> columns = [];

  @override
  void initState() {
    columns.addAll(stateManager.columns);
    setState(() {});
    super.initState();
    focusNode = FocusNode(onKey: (node, event) {
      if (event is RawKeyUpEvent) {
        return KeyEventResult.handled;
      }
      return stateManager.keyManager!.eventResult.skip(KeyEventResult.ignored);
    });
  }

  @override
  void dispose() {
    stateManager.gridFocusNode.removeListener(handleFocus);
    focusNode.dispose();
    super.dispose();
  }

  void handleFocus() {
    stateManager.setKeepFocus(!focusNode.hasFocus);
  }

  PopupMenuThemeData getPopupMenuTheme(ThemeData theme) {
    return PopupMenuThemeData(
      position: PopupMenuPosition.under,
      surfaceTintColor: theme.colorScheme.primary,
      elevation: 2,
      labelTextStyle: MaterialStateProperty.resolveWith((states) {
        //if disabled
        if (states.contains(MaterialState.disabled)) {
          return theme.textTheme.bodyMedium!.copyWith(
            color: theme.colorScheme.onSurface.withOpacity(0.5),
          );
        }
        return theme.textTheme.bodyMedium!;
      }),
      enableFeedback: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ThemeProvider(builder: (context, themeVm) {
      final theme = themeVm.theme;
      return Theme(
        data: theme.copyWith(
          popupMenuTheme: getPopupMenuTheme(theme),
        ),
        child: SizedBox(
          height: 70,
          child: Padding(
            padding: const EdgeInsets.all(10).w,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // search field
                SizedBox(
                  height: double.maxFinite,
                  width: MediaQuery.sizeOf(context).width * 0.3,
                  child: DefaultInput(
                    vm: InputModel(
                      name: "table_search",
                      hintText: "Filter",
                      focusNode: focusNode,
                      onChanged: (value) {
                        try {
                          stateManager.setFilter((element) =>
                              element.cells.values.any((cell) => cell.value
                                  .toString()
                                  .toLowerCase()
                                  .contains(value!.toLowerCase())) ==
                              true);
                        } catch (e) {
                          debugPrint(e.toString());
                        }
                      },
                    ),
                  ),
                ).w,

                SizedBox(
                  width: MediaQuery.sizeOf(context).width * 0.3,
                  child: DefaultSelect<PlutoColumn>(
                    form: const SelectForm(name: "columns"),
                    decoration: SelectDecoration(
                      showSelectedValuesContent: false,
                      labelText: "Columns",
                      hintText: columns.length == stateManager.columns.length
                          ? "All"
                          : columns.every((element) => element.hide)
                              ? "None"
                              : "${columns.where((element) => element.hide == false).length} selected",
                      selectionType: SelectionType.multi,
                    ),
                    options: SelectOptions(
                      onOptionRemoved: (index, option) {
                        if (option.value != null) {
                          stateManager.hideColumn(option.value!, true);
                        }
                      },
                      onOptionSelected: (selectedOptions) {
                        if (selectedOptions.isNotEmpty) {
                          for (var col in selectedOptions) {
                            if (col.value != null) {
                              stateManager.hideColumn(col.value!, false);
                            }
                          }
                        }
                      },
                      selectedOptions: [
                        for (var col in columns)
                          ValueItem(
                            label: col.title,
                            value: col,
                          )
                      ],
                      options: [
                        for (var col in columns)
                          ValueItem(
                            label: col.title,
                            value: col,
                          )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ).w,
      );
    });
  }
}

class _Footer extends StatefulWidget {
  final PlutoGridStateManager stateManager;
  const _Footer({
    required this.stateManager,
  });

  @override
  State<_Footer> createState() => __Footer();
}

class __Footer extends State<_Footer> {
  PlutoGridStateManager get stateManager => widget.stateManager;

  int pageNumber = 1;
  int pageSize = 10;

  @override
  void initState() {
    super.initState();
    stateManager.setPage(pageNumber);
    stateManager.setPageSize(pageSize);
    setState(() {});
    stateManager.addListener(() {
      if (mounted) {
        setState(() {
          pageNumber = stateManager.page;
          pageSize = stateManager.pageSize;
        });
      }
    });
  }

  void changePageSize(int size) {
    setState(() {
      pageSize = size;
    });
    stateManager.setPageSize(size);
    stateManager.setPage(1);
  }

  void changePageNumber(int number) {
    setState(() {
      pageNumber = number;
    });
    stateManager.setPage(number);
  }

  @override
  Widget build(BuildContext context) {
    //"Total ${(stateManager.rows.length * stateManager.totalPage).toString()} rows"),
    return SizedBox(
      height: 70.h,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            //Page size changer
            SizedBox(
              width: MediaQuery.sizeOf(context).width * 0.2,
              child: DefaultSelect<int>(
                form: const SelectForm(name: "table_page_size"),
                decoration: const SelectDecoration(labelText: 'Rows per page'),
                options: SelectOptions(
                  onOptionSelected: (newList) {
                    if (newList.isNotEmpty) {
                      changePageSize(newList.first.value!);
                    }
                  },
                  options: [
                    for (var ps in [10, 50, 100])
                      ValueItem(
                        label: ps.toString(),
                        value: ps,
                      )
                  ],
                  selectedOptions: [
                    ValueItem(
                        label: "${stateManager.pageSize}",
                        value: stateManager.pageSize)
                  ],
                ),
              ),
            ),

            //Page number
            DefaultPagination(
                totalPages: stateManager.totalPage,
                onPageChanged: changePageNumber,
                currentPage: stateManager.page),
          ],
        ),
      ),
    );
  }
}

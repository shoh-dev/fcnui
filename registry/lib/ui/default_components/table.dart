import 'package:fcnui_base/fcnui_base.dart';
import 'package:flutter/material.dart';
import 'package:registry/ui/default_components/card.dart';

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

class TableController extends Equatable {
  final List<DefaultColumn> columns;
  final List<DefaultRow> rows;
  final void Function(List<DefaultRow>) onAddRows;
  final void Function(List<DefaultRow>) onRemoveRows;
  final List<DefaultRow> Function() getSelectedRows;

  /// If [isAscending] parameter is null, the table will toggle the sort direction
  final void Function(DefaultColumn column, {bool? isAscending}) onSortBy;
  final void Function() clearSort;
  final void Function() unselectAll;
  final void Function() selectAll;
  final void Function() toggleSelectAll;

  DefaultColumn getColumnOfCell(DefaultCell cell) {
    try {
      return columns.firstWhere((element) => element.key == cell.key);
    } catch (e, st) {
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
    required this.clearSort,
    required this.unselectAll,
    required this.selectAll,
    required this.toggleSelectAll,
  });

  @override
  List<Object> get props => [columns, rows];
}

enum ColumnType { text, number }

@immutable
class DefaultColumn extends Equatable {
  final String name;

  /// The key must be unique
  final String key;
  final ColumnType type;
  final bool hasCheckbox;
  final bool hasSort;

  late final PlutoColumn plutoColumn;

  DefaultColumn({
    required this.name,
    required this.type,
    required this.key,
    this.hasCheckbox = false,
    this.hasSort = true,
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
    );
  }

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
        if (num.tryParse(value) != null) {
          return num.parse(value);
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
  TableDecoration? decoration;

  TableVm({
    required this.columns,
    this.rows = const [],
    this.localeText = const TableLocaleText(),
    required this.getTableController,
    this.decoration,
  })  : assert(columns.isNotEmpty, 'Columns cannot be empty'),
        assert(columns.map((e) => e.key).toSet().length == columns.length,
            'Column keys must be unique') {
    decoration ??= TableDecoration();
  }

  @override
  List<Object> get props => [columns, rows, localeText];
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
  CardDecoration? wrapperDecoration;
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
  final EdgeInsets? defaultCellPadding;
  final EdgeInsets? defaultColumnTitlePadding;
  final Color? evenRowColor;
  final Color? oddRowColor;

  TableDecoration({
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
  }) {
    wrapperDecoration ??= const CardDecoration(
      padding: EdgeInsets.all(0),
      borderRadius: BorderRadius.all(Radius.circular(16)),
    );
  }

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
      final decoration = vm.decoration!;
      final borderColor = decoration.gridBorderColor ?? Colors.black12;
      if (isDarkMode) {
        return PlutoGridStyleConfig.dark(
          gridBorderRadius: decoration.wrapperDecoration!.borderRadius,
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
                  color: theme.colorScheme.onSurface.withOpacity(0.6)),
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
        gridBorderRadius: decoration.wrapperDecoration!.borderRadius,
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
                .copyWith(color: theme.colorScheme.onSurface.withOpacity(0.6)),
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
    final isDarkMode = themeVm.themeMode == ThemeMode.dark;
    return SizedBox(
      width: double.infinity,
      height: 500,
      child: Theme(
        data: theme,
        child: PlutoGrid(
          configuration: getConfig(themeVm),
          // createFooter: ,//todo:
          // createFooter: ,//todo:
          // rowColorCallback: (rowColorContext) {
          //   // if (rowColorContext.rowIdx.isEven) {
          //   //   return vm.decoration!.evenRowColor ??
          //   //       theme.colorScheme.surface.withOpacity(.05);
          //   // }
          //   // return vm.decoration!.oddRowColor ??
          //   //     theme.colorScheme.surface.withOpacity(.05);
          //   if (rowColorContext.rowIdx.isEven &&
          //       vm.decoration!.evenRowColor != null) {
          //     print('even row color ${rowColorContext.rowIdx.isEven}');
          //     return vm.decoration!.evenRowColor!;
          //   }
          //   if (rowColorContext.rowIdx.isOdd &&
          //       vm.decoration!.oddRowColor != null) {
          //     return vm.decoration!.oddRowColor!;
          //   }
          //   return theme.colorScheme.surface.withOpacity(.05);
          // },
          mode: PlutoGridMode.select,
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
      if (vm.decoration!.wrapperDecoration != null) {
        return DefaultCard(
          decoration: vm.decoration!.wrapperDecoration!,
          custom: CardCustom(widget: getTable(themeVm)),
        );
      } else {
        return getTable(themeVm);
      }
    });
  }

  void handleOnLoadedEvent(PlutoGridOnLoadedEvent event) {
    stateManager = event.stateManager;
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
      clearSort: () {
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
      selectAll: () {
        stateManager.toggleAllRowChecked(true);
      },
      unselectAll: () {
        stateManager.toggleAllRowChecked(false);
      },
      toggleSelectAll: () {
        if (stateManager.hasCheckedRow) {
          stateManager.toggleAllRowChecked(false);
        } else {
          stateManager.toggleAllRowChecked(true);
        }
      },
    ));
  }
}

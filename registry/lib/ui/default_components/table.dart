import 'package:fcnui_base/fcnui_base.dart';
import 'package:flutter/material.dart';

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

class TableVm extends Equatable {
  final List<DefaultColumn> columns;
  final List<DefaultRow> rows;
  final GetTableController getTableController;

  TableVm({
    required this.columns,
    this.rows = const [],
    required this.getTableController,
  })  : assert(columns.isNotEmpty, 'Columns cannot be empty'),
        assert(columns.map((e) => e.key).toSet().length == columns.length,
            'Column keys must be unique');

  @override
  List<Object> get props => [columns, rows];
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
      if (isDarkMode) {
        return const PlutoGridStyleConfig.dark();
      }
      return const PlutoGridStyleConfig();
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
        'No rows',
        style: theme.textTheme.titleMedium,
      ),
    );
  }

  //TODO: Add the following features to the table:
  // Hide context menu
  // Off auto edit mode
  // Off resize column and row
  // Off drag column and row

  @override
  Widget build(BuildContext context) {
    return ThemeProvider(builder: (context, themeVm) {
      final theme = themeVm.theme;
      final isDarkMode = themeVm.themeMode == ThemeMode.dark;
      return SizedBox(
        width: double.infinity,
        height: 500,
        child: PlutoGrid(
          configuration: getConfig(themeVm),
          // createFooter: ,//todo:
          // createFooter: ,//todo:
          // rowColorCallback: (rowColorContext) {},//todo:
          mode: PlutoGridMode.select,
          noRowsWidget: getNoRowsWidget(theme),
          columns: vm.columns.map((e) => e.plutoColumn).toList(),
          rows: vm.rows.map((e) => e.plutoRow).toList(),
          onLoaded: (event) {
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
                return stateManager.checkedRows
                    .map((e) => e.toDefaultRow())
                    .toList();
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
          },
        ),
      );
    });
  }
}

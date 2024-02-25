import 'package:fcnui_base/fcnui_base.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:registry/ui/default_components/button.dart';
import 'package:registry/ui/default_components/card.dart';
import 'package:registry/ui/default_components/dp_item.dart';
import 'package:registry/ui/default_components/dropdown.dart';
import 'package:registry/ui/default_components/form.dart';
import 'package:registry/ui/default_components/table.dart';
import 'manager/manager.dart';
import 'ui/layout/default_layout.dart';

void main() async {
  runApp(DefaultStoreProvider(child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ThemeProvider(
      builder: (context, vm) => MaterialApp.router(
        debugShowCheckedModeBanner: false,
        // theme: ThemeData(useMaterial3: true),
        // darkTheme: ThemeData(brightness: Brightness.dark, useMaterial3: true),
        theme: FlexThemeData.light(scheme: vm.flexScheme, useMaterial3: true),
        darkTheme:
            FlexThemeData.dark(scheme: vm.flexScheme, useMaterial3: true),
        themeMode: vm.themeMode,
        title: 'Flutter Demo',
        routerConfig: registryRouter,
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final formModel = FormModel();

  final List<DefaultColumn> columns = [
    DefaultColumn(
      key: "name",
      name: "Name",
      type: ColumnType.text,
      width: 300,
      hasCheckbox: true,
      cellWidget: (cell, rowIndex) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const CircleAvatar(),
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  cell.value['name'],
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.normal,
                  ),
                ),
                Text(
                  cell.value['email'],
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
              ],
            )
          ],
        ).spaced(8);
      },
    ),
    DefaultColumn(
      key: "role",
      name: "Role",
      type: ColumnType.text,
      cellWidget: (cell, rowIndex) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                cell.value['name'],
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.normal,
                ),
              ),
              Text(
                cell.value['description'],
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        );
      },
    ),
    DefaultColumn(
      key: "status",
      name: "Status",
      type: ColumnType.text,
      cellTextAlign: TextAlign.center,
      titleTextAlign: TextAlign.center,
      width: 80,
      cellWidget: (cell, rowIndex) {
        return Center(
          child: Badge(
            padding: const EdgeInsets.symmetric(horizontal: 6),
            label: Text(cell.value,
                style: TextStyle(
                  color: rowIndex % 2 == 0 ? Colors.green : Colors.red,
                )),
            largeSize: 24,
            backgroundColor: rowIndex % 2 == 0
                ? Colors.green.withOpacity(.2)
                : Colors.red.withOpacity(.2),
          ),
        );
      },
    ),
    DefaultColumn(
      key: "actions",
      name: "Actions",
      type: ColumnType.text,
      titleTextAlign: TextAlign.center,
      cellTextAlign: TextAlign.right,
      width: 10,
      hasSort: false,
      cellWidget: (cell, rowIndex) {
        return PopupMenuButton(
          tooltip: "",
          offset: const Offset(0, 40).w,
          itemBuilder: (context) {
            //View
            //Edit
            //Delete
            return const [
              PopupMenuItem(value: "view", child: Text("View")),
              PopupMenuItem(value: "edit", child: Text("Edit")),
              PopupMenuItem(value: "delete", child: Text("Delete")),
            ];
          },
          child: const Icon(Icons.more_vert_rounded, color: Colors.grey),
        );
      },
    ),
  ];

  final List<DefaultRow> rows = [
    for (int i = 0; i < 200; i++)
      DefaultRow(
        cells: [
          DefaultCell(
            value: {
              "name": "Name $i",
              "email": "email $i",
            },
            key: "name",
          ),
          DefaultCell(
            value: {
              "name": "Role $i",
              "description": "Description $i",
            },
            key: "role",
          ),
          DefaultCell(
            value: i % 2 == 0 ? "Active" : "Inactive",
            key: "status",
          ),
          DefaultCell(
            value: "Actions $i",
            key: "actions",
          ),
        ],
      ),
  ];

  late final TableController tableController;

  @override
  Widget build(BuildContext context) {
    return ThemeProvider(
      builder: (context, vm) {
        return Scaffold(
          appBar: const DefaultAppBar(),
          body: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  // DefaultButton(
                  //     variant: SecondaryButtonVariant(
                  //         onPressed: () => ChangeUsePlatformThemeAction(
                  //                 usePlatformTheme: !vm.usePlatformTheme)
                  //             .payload(),
                  //         text: "Use platform theme ${vm.usePlatformTheme}")),
                  // ElevatedButton(
                  //     onPressed: () {
                  //       print(tableController.getSelectedRows().length);
                  //     },
                  //     child: const Text("get selected")),
                  //
                  // ElevatedButton(
                  //     onPressed: () {
                  //       tableController
                  //           .onRemoveRows(tableController.getSelectedRows());
                  //     },
                  //     child: const Text("remove selected")),
                  //
                  // ElevatedButton(
                  //     onPressed: () {
                  //       tableController.onRemoveRows(rows);
                  //     },
                  //     child: const Text("remove all")),
                  //
                  // ElevatedButton(
                  //     onPressed: () {
                  //       tableController.onAddRows([
                  //         DefaultRow(cells: [
                  //           DefaultCell(value: "Name 4", key: "name"),
                  //           DefaultCell(value: 4, key: "age"),
                  //           DefaultCell(value: "Yes", key: "is_married"),
                  //         ])
                  //       ]);
                  //     },
                  //     child: const Text("add")),
                  //
                  // ElevatedButton(
                  //     onPressed: () {
                  //       print(tableController.getColumnOfCell(
                  //           tableController.rows.first.cells[2]));
                  //     },
                  //     child: const Text("get column of cell")),
                  //
                  // ElevatedButton(
                  //     onPressed: () {
                  //       tableController.onSortBy(tableController.columns[1],
                  //           isAscending: true);
                  //     },
                  //     child: const Text("sort by column 2 asc")),
                  //
                  // ElevatedButton(
                  //     onPressed: () {
                  //       tableController.onSortBy(tableController.columns[1],
                  //           isAscending: false);
                  //     },
                  //     child: const Text("sort by column 2 desc")),
                  //
                  // ElevatedButton(
                  //     onPressed: () {
                  //       tableController.onSortBy(tableController.columns[1]);
                  //     },
                  //     child: const Text("sort by column 2 toggle")),
                  //
                  // ElevatedButton(
                  //     onPressed: () {
                  //       tableController.onClearSort();
                  //     },
                  //     child: const Text("clear sort")),
                  //
                  // ElevatedButton(
                  //     onPressed: () {
                  //       tableController.onSelectAll();
                  //     },
                  //     child: const Text("select all")),
                  //
                  // ElevatedButton(
                  //     onPressed: () {
                  //       tableController.onUnselectAll();
                  //     },
                  //     child: const Text("unselect all")),
                  //
                  // ElevatedButton(
                  //     onPressed: () {
                  //       tableController.onToggleSelectAll();
                  //     },
                  //     child: const Text("toggle select all")),
                  //
                  // ElevatedButton(
                  //     onPressed: () {
                  //       tableController
                  //           .onHideColumn(tableController.columns[1]);
                  //     },
                  //     child: const Text("hide age column")),
                  //
                  // ElevatedButton(
                  //     onPressed: () {
                  //       tableController
                  //           .onShowColumn(tableController.columns[1]);
                  //     },
                  //     child: const Text("show age column")),
                  //
                  // ElevatedButton(
                  //     onPressed: () {
                  //       tableController.onToggleColumnVisibility(
                  //           tableController.columns[1]);
                  //     },
                  //     child: const Text("toggle age column")),

                  //   ------------------------------------------

                  DefaultTable(
                    vm: TableVm(
                      decoration: TableDecoration(
                        defaultRowHeight: 56,
                        defaultColumnTitlePadding: const EdgeInsets.all(8),
                      ),
                      columns: columns,
                      rows: rows,
                      getTableController: (tableController) {
                        this.tableController = tableController;
                        setState(() {});
                      },
                    ),
                  ),
                ],
              ).spaced(20)),
        );
      },
    );
  }
}

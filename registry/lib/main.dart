import 'package:fcnui_base/fcnui_base.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:registry/ui/default_components/button.dart';
import 'package:registry/ui/default_components/dp_item.dart';
import 'package:registry/ui/default_components/form.dart';
import 'package:registry/ui/default_components/radio.dart';
import 'package:registry/ui/default_components/save_button.dart';
import 'package:registry/ui/default_components/switch.dart';
import 'package:registry/ui/default_components/table.dart';
import 'package:registry/ui/default_components/with_label.dart';
import 'manager/manager.dart';
import 'ui/default_components/dropdown.dart';
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
        theme: ThemeData(useMaterial3: true),
        darkTheme: ThemeData(brightness: Brightness.dark, useMaterial3: true),
        // theme: FlexThemeData.light(scheme: vm.flexScheme, useMaterial3: true),
        // darkTheme:
        //     FlexThemeData.dark(scheme: vm.flexScheme, useMaterial3: true),
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
        name: 'Name', hasCheckbox: true, key: "name", type: ColumnType.text),
    DefaultColumn(name: 'Age', key: "age", type: ColumnType.number),
    DefaultColumn(
        name: 'Is Married',
        hasSort: false,
        key: "is_married",
        type: ColumnType.text),
  ];

  final List<DefaultRow> rows = [
    for (int i = 0; i < 3; i++)
      DefaultRow(cells: [
        DefaultCell(value: "Name $i", key: "name"),
        DefaultCell(value: i, key: "age"),
        DefaultCell(value: i % 2 == 0 ? "Yes" : "No", key: "is_married"),
      ])
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
                  DefaultButton(
                      variant: SecondaryButtonVariant(
                          onPressed: () => ChangeUsePlatformThemeAction(
                                  usePlatformTheme: !vm.usePlatformTheme)
                              .payload(),
                          text: "Use platform theme ${vm.usePlatformTheme}")),
                  ElevatedButton(
                      onPressed: () {
                        print(tableController.getSelectedRows().length);
                      },
                      child: const Text("get selected")),

                  ElevatedButton(
                      onPressed: () {
                        tableController
                            .onRemoveRows(tableController.getSelectedRows());
                      },
                      child: const Text("remove selected")),

                  ElevatedButton(
                      onPressed: () {
                        tableController.onRemoveRows(rows);
                      },
                      child: const Text("remove all")),

                  ElevatedButton(
                      onPressed: () {
                        tableController.onAddRows([
                          DefaultRow(cells: [
                            DefaultCell(value: "Name 4", key: "name"),
                            DefaultCell(value: 4, key: "age"),
                            DefaultCell(value: "Yes", key: "is_married"),
                          ])
                        ]);
                      },
                      child: const Text("add")),

                  ElevatedButton(
                      onPressed: () {
                        print(tableController.getColumnOfCell(
                            tableController.rows.first.cells[2]));
                      },
                      child: const Text("get column of cell")),

                  ElevatedButton(
                      onPressed: () {
                        tableController.onSortBy(tableController.columns[1],
                            isAscending: true);
                      },
                      child: const Text("sort by column 2 asc")),

                  ElevatedButton(
                      onPressed: () {
                        tableController.onSortBy(tableController.columns[1],
                            isAscending: false);
                      },
                      child: const Text("sort by column 2 desc")),

                  ElevatedButton(
                      onPressed: () {
                        tableController.onSortBy(tableController.columns[1]);
                      },
                      child: const Text("sort by column 2 toggle")),

                  ElevatedButton(
                      onPressed: () {
                        tableController.clearSort();
                      },
                      child: const Text("clear sort")),

                  ElevatedButton(
                      onPressed: () {
                        tableController.selectAll();
                      },
                      child: const Text("select all")),

                  ElevatedButton(
                      onPressed: () {
                        tableController.unselectAll();
                      },
                      child: const Text("unselect all")),

                  ElevatedButton(
                      onPressed: () {
                        tableController.toggleSelectAll();
                      },
                      child: const Text("toggle select all")),

                  //   ------------------------------------------

                  DefaultTable(
                    vm: TableVm(
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

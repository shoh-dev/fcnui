import 'package:fcnui_base/fcnui_base.dart';
import 'package:flutter/material.dart';

class DefaultLayout extends StatefulWidget {
  final Widget Function(TabController) child;
  const DefaultLayout({super.key, required this.child});

  @override
  State<DefaultLayout> createState() => _DefaultLayoutState();
}

class _DefaultLayoutState extends State<DefaultLayout>
    with SingleTickerProviderStateMixin {
  late final TabController tabController;

  @override
  void initState() {
    tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DefaultAppBar(tabController: tabController),
      body: Container(
        decoration: BoxDecoration(
          border: Border.all(
              color: Theme.of(context).colorScheme.onSurface, width: 1),
        ),
        padding: const EdgeInsets.all(16.0),
        child: widget.child(tabController),
      ),
    );
  }
}

class DefaultAppBar extends StatelessWidget implements PreferredSizeWidget {
  final TabController? tabController;
  const DefaultAppBar({super.key, this.tabController});

  @override
  Widget build(BuildContext context) {
    return ThemeProvider(builder: (context, vm) {
      return AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        actions: [
          Container(
            width: 200,
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: DropdownButtonFormField<int>(
                menuMaxHeight: 200,
                value: FlexScheme.values
                    .indexWhere((e) => e.name == vm.flexScheme.name),
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: vm.theme.colorScheme.onPrimary)),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 8)),
                items: FlexScheme.values
                    .map((e) => DropdownMenuItem<int>(
                        value: e.index, child: Text(e.formatted.capitalize)))
                    .toList(),
                onChanged: (value) {
                  vm.onChangeThemeScheme(FlexScheme.values[value!]);
                }),
          ),
          const Spacer(),
          IconButton(
            onPressed: () {
              switch (vm.themeMode) {
                case ThemeMode.light:
                  vm.onToggleThemeMode(ThemeMode.dark);
                  break;
                case ThemeMode.dark:
                  vm.onToggleThemeMode(ThemeMode.light);
                  break;
                default:
                  break;
              }
            },
            icon: Icon(getThemeModeIcon(vm.themeMode)),
          ),
        ],
        bottom: tabController != null
            ? TabBar(
                controller: tabController,
                indicator: BoxDecoration(
                  color: vm.theme.colorScheme.primary.withOpacity(.1),
                ),
                indicatorSize: TabBarIndicatorSize.tab,
                tabs: const [
                    Tab(text: "Preview"),
                    Tab(text: "Code"),
                  ])
            : null,
      );
    });
  }

  IconData getThemeModeIcon(ThemeMode themeMode) => switch (themeMode) {
        ThemeMode.system => Icons.brightness_auto,
        ThemeMode.light => Icons.brightness_7,
        ThemeMode.dark => Icons.brightness_4
      };

  @override
  Size get preferredSize => Size.fromHeight(
      kToolbarHeight + (tabController != null ? kTextTabBarHeight : 0));
}

extension FlexSchemeExt on FlexScheme {
  //split by capital letters and join with space
  String get formatted => name.split(RegExp(r"(?=[A-Z])")).join(' ');
}

import 'package:fcnui/src/functions/init/init_json.dart';
import 'package:fcnui/src/src.dart';

Future<void> main(List<String> arguments) async {
  await myMain(arguments);
}

Future<void> myMain(List<String> arguments) async {
  final args = arguments.map((e) => e.toLowerCase()).toList();
  if (args.isEmpty || args[0].isEmpty) {
    print('Invalid command. Use: fcnui <command>');
    close();
  }

  //Initialize dependencies
  getIt.registerSingleton<ApiClient>(ApiClient());

  getIt.registerSingleton<InitJson>(InitJson());

  isFlutterProject();

  final firstArg = arguments[0];

  final initJson = getIt<InitJson>();

  if (firstArg == "init") {
    final initialization = Initialization(initJson: initJson);
    initialization.init();
    close();
  }

  if (!initJson.isInitialized) {
    print('Please run "fcnui init" first');
    close();
  }

  final componentMethods = ComponentMethods(initJson: initJson);

  switch (firstArg) {
    case "add":
      final components = arguments.sublist(1);
      if (components.isEmpty) {
        print('Invalid command. Use: fcnui add <componentName>');
        close();
      }
      await componentMethods.add(components);
      close();
    default:
      print("Invalid command. Use: 'fcnui help' for more information.");
      close();
  }
}

import 'package:cli/src/functions/init/init_json.dart';
import 'package:cli/src/src.dart';

Future<void> main(List<String> arguments) async {
  final args = arguments.map((e) => e.toLowerCase()).toList();
  if (args.isEmpty) {
    print('Invalid command. Use: cli <command>');
    close();
  }

  await myMain(args);
}

Future<void> myMain(List<String> arguments) async {
  //Initialize dependencies
  getIt.registerSingleton<ApiClient>(ApiClient());

  getIt.registerSingleton<InitJson>(InitJson());

  // isFlutterProject();//todo: uncomment this line

  final firstArg = arguments[0];

  final initJson = getIt<InitJson>();

  if (firstArg == "init") {
    final initialization = Initialization(initJson: initJson);
    initialization.init();
    close();
  }

  if (!initJson.isInitialized) {
    print('Please run "cli init" first');
    close();
  }

  final componentMethods = ComponentMethods(initJson: initJson);

  switch (firstArg) {
    case "add":
      final components = arguments.sublist(1);
      if (components.isEmpty) {
        print('Invalid command. Use: cli add <componentName>');
        close();
      }
      await componentMethods.add(components);
      close();
    default:
      print("Invalid command. Use: 'cli help' for more information.");
      close();
  }
}

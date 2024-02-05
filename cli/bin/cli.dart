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
  final InitJson initJson = InitJson();
  final ApiClient apiClient = ApiClient();

  getIt.registerSingleton<ApiClient>(apiClient);
  getIt.registerSingleton<InitJson>(initJson);

  // isFlutterProject();

  final firstArg = arguments[0];

  if (firstArg == "init") {
    final initialization = Initialization(initJson: initJson);
    initialization.init();
    close();
  }

  switch (firstArg) {
    case "add":
    // if (!Initialization(initJson: initJson).initialized()) {
    //   print('Please run "cli init" first');
    //   close();
    // }
    // await doAdd(arguments);
    // close();
  }
}

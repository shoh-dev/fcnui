import 'dart:io';

import 'src/functions/init/init_json.dart';
import 'src/src.dart';

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
  initializeDependency();

  // isFlutterProject();

  final firstArg = arguments[0];

  final InitJson initJson = InitJson();
  if (firstArg == "init") {
    final initialized =
        await Initialization(initJson: initJson).doInit(arguments);
    if (initialized) {
      print('Initialized');
    } else {
      print('Failed to initialize');
    }
    close();
  }

  switch (firstArg) {
    case "init":
    case "add":
      if (!Initialization(initJson: initJson).initialized()) {
        print('Please run "cli init" first');
        close();
      }
      await doAdd(arguments);
      close();
  }
}

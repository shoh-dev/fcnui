import 'dart:io';

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

  isFlutterProject();

  final firstArg = arguments[0];

  switch (firstArg) {
    case "init":
      doInit(arguments);
      close();
    case "add":
      await doAdd(arguments);
      close();
  }
}

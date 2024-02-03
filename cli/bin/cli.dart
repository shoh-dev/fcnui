import 'dart:io';

import 'src/src.dart';

Future<void> main(List<String> arguments) async {
  if (arguments.isEmpty) {
    print('Invalid command. Use: cli <command>');
    close();
  }

  myMain(arguments);
}

void myMain(List<String> arguments) {
  //Initialize dependencies
  initializeDependency();

  // isFlutterProject(); //todo: uncomment this line

  final firstArg = arguments[0];

  switch (firstArg) {
    case "init":
      doInit(arguments);
      close();
    case "add":
      doAdd(arguments);
      break;
    case "pub":
      doPub(arguments);
      break;
  }
}

void doPub(List<String> args) {
  if (args.length < 2) {
    print('Invalid command. Use: cli pub <package-name>');
    return;
  }

  final packageName = args[1];

  final yourWorkingDir = Directory.current.path;
  //call flutter pub add packageName
  try {
    Process.runSync('flutter', ['pub', 'add', packageName],
        workingDirectory: yourWorkingDir, runInShell: true);
  } on ProcessException catch (e) {
    print(e.message);
    print(e.errorCode);
    print(e.executable);
  }
}

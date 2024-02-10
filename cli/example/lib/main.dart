// ignore_for_file: avoid_print

import 'dart:io';

Future<ProcessResult> run(List<String> args) async {
  final process = await Process.run('fcnui', args);
  print(process.stdout.toString());
  return process;
}

void main() {
  //ivalid command
  // invalidCommand();

  //init
  // initialize();

  //add button
  addButton();
}

void invalidCommand() {
  run([]);
}

void initialize() {
  run(['init']);
}

void addButton() {
  run(['add', 'button']);
}

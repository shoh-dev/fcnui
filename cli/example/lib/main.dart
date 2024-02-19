// ignore_for_file: avoid_print

import 'dart:io';

Future<ProcessResult> run(List<String> args) async {
  final process = await Process.run('fcnui', args);
  print(process.stdout.toString());
  return process;
}

void main() {
  //invalid command
  // invalidCommand();

  //init
  // initialize();

  //add button
  // addButton();

  //version
  // version();

  //help
  // help();

  //remove
  remove();
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

void version() {
  run(['version']);
}

void help() {
  run(['help']);
}

void remove() {
  run(['remove', 'button']);
}

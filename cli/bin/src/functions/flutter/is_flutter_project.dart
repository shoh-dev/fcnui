import 'dart:io';
import 'package:yaml/yaml.dart';
import '../../src.dart';

void _printNotFlutterProjectAndClose() {
  print(
      'Not a Flutter project. Please run this command in a Flutter project directory.');
  close();
}

void isFlutterProject() {
  try {
    if (!File(kPubspec).existsSync()) {
      _printNotFlutterProjectAndClose();
    }
    final yamlFile = File(kPubspec);
    final YamlMap pubspecFile = loadYaml(yamlFile.readAsStringSync());
    final containsDeps = pubspecFile.containsKey('dependencies');
    if (!containsDeps) {
      _printNotFlutterProjectAndClose();
    }
    final bool containsFlutter =
        pubspecFile['dependencies'].containsKey('flutter');
    if (!containsFlutter) {
      _printNotFlutterProjectAndClose();
    }

    final projectName = pubspecFile['name'];
    print('Flutter project found => $projectName');
  } catch (e) {
    _printNotFlutterProjectAndClose();
  }
}

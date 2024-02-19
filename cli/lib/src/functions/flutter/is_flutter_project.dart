import 'dart:io';
import 'package:yaml_edit/yaml_edit.dart';

import '../../src.dart';

void _printNotFlutterProjectAndClose() {
  print(
      'Not a Flutter project. Please run this command in a Flutter project directory.');
  close();
}

YamlEditor? isFlutterProject() {
  try {
    if (!File(kPubspecYaml).existsSync()) {
      _printNotFlutterProjectAndClose();
    }
    final yamlFile = File(kPubspecYaml);
    final YamlEditor pubspecFile = YamlEditor(yamlFile.readAsStringSync());
    //If parsed successfully then it's a Flutter project
    //If cannot parse, it throws error so catch it and print error message
    //Most likely the user is not in a Flutter project directory
    final flutterNodeValue =
        pubspecFile.parseAt(['dependencies', 'flutter']).value;
    if (flutterNodeValue == null) {
      _printNotFlutterProjectAndClose();
    }
    final projectName = pubspecFile.parseAt(['name']).value;
    logger('Flutter project found => $projectName');
    return pubspecFile;
  } catch (e) {
    print(e.toString());
    _printNotFlutterProjectAndClose();
  }
  return null;
}

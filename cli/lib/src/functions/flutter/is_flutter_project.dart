import 'dart:io';
import 'package:fcnui/src/functions/log/logger.dart';
import 'package:yaml_edit/yaml_edit.dart';

void _printNotFlutterProject() {
  logger(
      'Not a Flutter project. Please run this command in a Flutter project directory.');
}

YamlEditor? isFlutterProject(String pubspecPath) {
  try {
    if (!File(pubspecPath).existsSync()) {
      _printNotFlutterProject();
    }
    final yamlFile = File(pubspecPath);
    final YamlEditor pubspecFile = YamlEditor(yamlFile.readAsStringSync());
    //If parsed successfully then it's a Flutter project
    //If cannot parse, it throws error so catch it and print error message
    //Most likely the user is not in a Flutter project directory
    final flutterNodeValue =
        pubspecFile.parseAt(['dependencies', 'flutter']).value;
    if (flutterNodeValue == null) {
      _printNotFlutterProject();
    }
    final projectName = pubspecFile.parseAt(['name']).value;
    logger('Flutter project found => $projectName');
    return pubspecFile;
  } catch (e) {
    logger(e.toString());
    _printNotFlutterProject();
  }
  return null;
}

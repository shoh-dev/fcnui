import 'dart:io';

import 'package:fcnui/src/constants.dart';
import 'package:yaml_edit/yaml_edit.dart';

void versionCommand() {
  final yamlFile = File(kPubspecYaml);
  final YamlEditor pubspecFile = YamlEditor(yamlFile.readAsStringSync());
  final version = pubspecFile.parseAt(['version']).value;
  print('Version: $version');
}

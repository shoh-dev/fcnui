import 'dart:convert';
import 'dart:io';

import 'package:fpdart/fpdart.dart';
import 'package:yaml/yaml.dart';
import 'package:yaml_edit/yaml_edit.dart';

import '../../constants.dart';
import '../functions.dart';

void initFlutterCnYaml() {
  //Create a new Yaml file
  try {
    final file = File(kFlutterCnUiYaml);
    final yamlEditor = YamlEditor(file.readAsStringSync());
    yamlEditor.update(['registry', 'theme', 'version'], "0.0.2");
    logger(yamlEditor.toString(), hint: 'yaml');
    file.writeAsStringSync(yamlEditor.toString());

    // if (!file.existsSync()) {
    //   file.writeAsStringSync(_content);
    // }
    // final YamlMap yaml = loadYaml(file.readAsStringSync());
    // final encoded = json.encode(yaml);
    // final updateOption = yaml.modifyAt(Eq.eqString, (value) {
    //   return value;
    // }, 'registry');
    // yaml.update("registry", (value) => 'test');
    // for (var element in yaml.entries) {
    //   if (element.key == 'registry') {
    //     if (element.value.containsKey('theme')) {
    //       element.value['theme']['version'] = '0.0.2';
    //       logger(element.value['theme']['version']);
    //     }
    //   }
    // }
    // logger(updateOption, hint: 'updateOption');
    // final newYaml = YamlMap.wrap(yaml);
    // file.writeAsStringSync(newYaml.toString());
  } catch (e) {
    print('Error flutter_cn_ui.yaml file initFlutterCnYaml: $e');
    close();
  }
}

String _content = r'''
name: flutter_cn_ui
version: 0.0.1
description: Helper package for Flutter CN UI

registry:
  theme:
    name: default
    version: 0.0.1
  
  components:
    button:
      version: 0.0.1
''';

import 'dart:io';
import 'package:yaml_edit/yaml_edit.dart';

import '../../constants.dart';
import '../functions.dart';

class InitYaml {
  bool get initYamlExists {
    return getYamlFile() != null;
  }

  File? getYamlFile() {
    final file = File(kFlutterCnUiYaml);
    if (file.existsSync()) {
      return file;
    }
    return null;
  }

  YamlEditor getFlutterCnUiYaml() {
    final file = File(kFlutterCnUiYaml);
    final yamlEditor = YamlEditor(file.readAsStringSync());
    return yamlEditor;
  }

  void initYamlFile() {
    //Create a new Yaml file
    try {
      //1. check if file exists
      //1.1 if not, create file
      final file = getYamlFile();
      if (file == null) {
        File(kFlutterCnUiYaml).writeAsStringSync(_content);
        print('flutter_cn_ui.yaml file created');
      } else {
        print('flutter_cn_ui.yaml file exists');
      }
    } catch (e) {
      print('Error flutter_cn_ui.yaml file initFlutterCnYaml: $e');
      close();
    }
  }

  void updateYaml(List<String> keys, dynamic value) {
    if (getYamlFile() == null) {
      print('Error: flutter_cn_ui.yaml file not found');
      close();
    }
    final yamlEditor = getFlutterCnUiYaml();
    yamlEditor.update(keys, value);
    getYamlFile()!.writeAsStringSync(yamlEditor.toString());
  }

  String? get componentsFolderPath {
    try {
      final componentsFolder = getFlutterCnUiYaml()
          .parseAt(['registry', 'components', 'folder']).value;
      if (componentsFolder == null) {
        return null;
      }
      if (componentsFolder.toString().isEmpty) {
        return null;
      }
      return componentsFolder.toString();
    } catch (e) {
      return null;
    }
  }

  final String _content = r'''
name: flutter_cn_ui
version: 0.0.1
description: Helper package for Flutter CN UI

registry:
  theme:
    name: default
    version: 0.0.1
  
  components:
    folder:
    ui:
      button:
      version: 0.0.1
''';
}

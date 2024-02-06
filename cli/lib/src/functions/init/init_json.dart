import 'dart:convert';
import 'dart:io';
import 'package:fcnui/src/constants.dart';
import 'package:fcnui/src/functions/functions.dart';
import 'init_json_md.dart';

class InitJson {
  InitJson() {
    initJsonFile();
  }
  late final InitJsonMd initJsonMd;

  bool get isInitialized {
    return initJsonMd.registry.componentsFolder != null;
  }

  File? getJsonFile() {
    final file = File(kFlutterCnUiJson);
    if (file.existsSync()) {
      return file;
    }
    return null;
  }

  InitJsonMd getCnUiJson() {
    try {
      final file = File(kFlutterCnUiJson);
      return InitJsonMd.fromJson(jsonDecode(file.readAsStringSync()));
    } catch (e) {
      print('Error reading flutter_cn_ui.json file: $e');
      close();
      rethrow;
    }
  }

  void initJsonFile() {
    //Create a new Json file
    try {
      //1. check if file exists
      //1.1 if not, create file
      final file = getJsonFile();
      if (file == null) {
        final defaultJson = InitJsonMd();
        File(kFlutterCnUiJson)
            .writeAsStringSync(jsonEncode(defaultJson.toJson()));
        print('flutter_cn_ui.json file created');
      } else {
        print('flutter_cn_ui.json file exists');
      }
      initJsonMd = getCnUiJson();
    } catch (e) {
      print('Error flutter_cn_ui.json file initFlutterCnJson: $e');
      close();
    }
  }

  void updateJson(InitJsonMd newJsonData) {
    if (getJsonFile() == null) {
      print('Error: flutter_cn_ui.json file not found');
      close();
    }
    final file = getJsonFile()!;
    file.writeAsStringSync(jsonEncode(newJsonData.toJson()));
  }

  bool isComponentRegistered(ComponentData component) {
    final json = getCnUiJson();
    return json.registry.components
        .any((element) => element.name == component.name);
  }

  void registerComponent(ComponentData component) {
    if (getJsonFile() == null) {
      print('Error: flutter_cn_ui.json file not found');
      close();
    }
    final json = getCnUiJson();
    //if exists replace
    final index = json.registry.components
        .indexWhere((element) => element.name == component.name);
    if (index != -1) {
      json.registry.components[index] = component;
      getJsonFile()!.writeAsStringSync(jsonEncode(json.toJson()));
      logger("Updated ${component.name} in flutter_cn_ui.json");
      return;
    }
    //if not exists add
    json.registry.components.add(component);
    logger("Registered ${component.name} in flutter_cn_ui.json");
    getJsonFile()!.writeAsStringSync(jsonEncode(json.toJson()));
  }

  String getComponentVersion(String componentName) {
    final json = getCnUiJson();
    final component = json.registry.components
        .firstWhere((element) => element.name == componentName);
    return component.version;
  }
}

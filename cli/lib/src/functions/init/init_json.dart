import 'dart:convert';
import 'dart:io';
import '../../constants.dart';
import '../functions.dart';
import 'init_json_md.dart';

class InitJson {
  late final InitJsonMd initJsonMd;

  InitJson() {
    initJsonFile();
  }

  bool get initJsonExists {
    return getJsonFile() != null;
  }

  File? getJsonFile() {
    final file = File(kFlutterCnUiJson);
    if (file.existsSync()) {
      return file;
    }
    return null;
  }

  InitJsonMd getCnUiJson() {
    final file = File(kFlutterCnUiJson);
    return InitJsonMd.fromJson(jsonDecode(file.readAsStringSync()));
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
    json.registry.components.add(component);
    logger("Registered ${component.name} in flutter_cn_ui.json");
    getJsonFile()!.writeAsStringSync(json.toString());
  }
}

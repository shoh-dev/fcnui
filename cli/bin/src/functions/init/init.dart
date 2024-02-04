import 'dart:io';
import '../../constants.dart';
import '../../dependency/dependency.dart';
import 'init_json.dart';

class Initialization {
  final InitJson initJson;

  Initialization({required this.initJson});
  //Steps
  //1 - Check if flutter_cn_ui.json exists
  //2 - If not, create it
  //3 - If yes, check if components folder exists
  //4 - If not, ask for the folder path
  //5 - If yes, do nothing
  //6 - Update the yaml file with the components folder path
  //7 - Create the components folder if it doesn't exist
  //8 - Done

  bool initialized() {
    //If flutter_cn_ui.json exists and components folder exists, return true
    if (getIt.isRegistered<InitJson>()) {
      InitJson initJson = getIt.get<InitJson>();
      if (initJson.initJsonMd.registry.componentsFolder != null) {
        return true;
      }
    }
    return false;
  }

  Future<bool> doInit(List<String> arguments) async {
    //If components folder exists, do nothing, just print the components
    if (initJson.initJsonMd.registry.componentsFolder != null) {
      print(
          'Components folder already exists at: ${initJson.initJsonMd.registry.componentsFolder}');
      return true;
    }

    //else ask for the folder path
    // Prompt user for components folder location
    stdout.write(
        'Enter components folder location inside lib (default: $kDefaultComponentsFolder): ');
    String fullPath = "";
    String componentsFolder = stdin.readLineSync() ?? "";
    if (componentsFolder.isEmpty) {
      componentsFolder = kDefaultComponentsFolder;
    } else {
      //If starts with /, remove it
      //ex: /components -> components
      if (componentsFolder.startsWith(pSeparator)) {
        componentsFolder = componentsFolder.substring(1);
      }
      //If ends with /, remove it
      //ex: components/ -> components
      if (componentsFolder.endsWith(pSeparator)) {
        componentsFolder =
            componentsFolder.substring(0, componentsFolder.length - 1);
      }
    }
    fullPath = kProjectBaseLibPath + (componentsFolder);
    // Create the components folder if it doesn't exist
    if (!Directory(fullPath).existsSync()) {
      Directory(fullPath).createSync(recursive: true);
      initJson.updateJson(initJson.initJsonMd.copyWith(
          registry: initJson.initJsonMd.registry
              .copyWith(componentsFolder: componentsFolder)));
      print('Components folder created at: $fullPath');
      print(
          'Components folder created: ${initJson.initJsonMd.registry.componentsFolder}');
      registerInitJson(initJson);
    }
    return true;
  }
}

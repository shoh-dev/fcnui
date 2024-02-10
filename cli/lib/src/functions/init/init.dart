import 'dart:io';
import '../../src.dart';
import 'init_json.dart';

class Initialization {
  final InitJson initJson;

  Initialization({required this.initJson});
  void init() {
    //Check if the components folder is registered
    if (initJson.initJsonMd.registry.componentsFolder != null) {
      print(
          'Components folder is at: ${initJson.initJsonMd.registry.componentsFolder}');
      close();
    }
    //Ask for the components folder location
    final componentsFolder = _requireComponentsFolder();
    //Update the components folder location
    initJson.updateJson(initJson.initJsonMd.copyWith(
        registry: initJson.initJsonMd.registry
            .copyWith(componentsFolder: componentsFolder)));
    print('Components folder registered at: $componentsFolder');
  }
}

///Ask to the user for the components folder location
///If the user doesn't provide a location, the default location will be used which is [kDefaultComponentsFolder]
///If the folder doesn't exist, it will be created and returned
String _requireComponentsFolder() {
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
    print('Components folder created: $componentsFolder');
  }
  return componentsFolder;
}

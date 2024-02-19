import 'dart:io';
import '../../src.dart';

export 'init_json.dart';
export 'init_json_md.dart';

class Initialization {
  final InitJson initJson;

  Initialization({required this.initJson});
  String init(String defaultComponentPath) {
    //Check if the components folder is registered
    if (initJson.initJsonMd.registry.componentsFolder != null) {
      logger(
          'Components folder is at: ${initJson.initJsonMd.registry.componentsFolder}');
      return initJson.initJsonMd.registry.componentsFolder!;
    }
    //Ask for the components folder location
    final componentsFolder = _requireComponentsFolder(defaultComponentPath);
    //Update the components folder location
    initJson.updateJson(initJson.initJsonMd.copyWith(
        registry: initJson.initJsonMd.registry
            .copyWith(componentsFolder: componentsFolder)));
    logger('Components folder registered at: $componentsFolder');
    return componentsFolder;
  }
}

///Ask to the user for the components folder location
///If the user doesn't provide a location, the default location will be used which is [defaultComponentPath]
///If the folder doesn't exist, it will be created and returned
String _requireComponentsFolder(String defaultComponentPath) {
  stdout.write(
      'Enter components folder location inside lib (default: $defaultComponentPath): ');
  String fullPath = "";
  String componentsFolder = stdin.readLineSync() ?? "";
  if (componentsFolder.isEmpty) {
    componentsFolder = defaultComponentPath;
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
    logger('Components folder created: $componentsFolder');
  }
  return componentsFolder;
}

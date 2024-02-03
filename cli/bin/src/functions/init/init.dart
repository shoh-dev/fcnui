import 'dart:io';
import '../../constants.dart';
import 'init_yaml.dart';

Future<bool> doInit(List<String> arguments) async {
  final InitYaml initYaml = InitYaml();

  initYaml.initYamlFile();

  //If components folder exists, do nothing, just print the components
  if (initYaml.componentsFolderPath != null) {
    print(
        'Components folder already exists at: ${initYaml.componentsFolderPath}');
    return true;
  }

  //else ask for the folder path
  // Prompt user for components folder location
  stdout.write(
      'Enter components folder location inside lib (default: components): ');
  String fullPath = "";
  String componentsFolder = stdin.readLineSync() ?? "";
  if (componentsFolder.isEmpty) {
    componentsFolder = 'components';
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
    initYaml.updateYaml(['registry', 'components', 'folder'], componentsFolder);
    print('Components folder created: ${initYaml.componentsFolderPath}');
  }
  return true;
}

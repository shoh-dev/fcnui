import 'dart:io';

Future<bool> doInit(List<String> arguments) async {
  bool initDone = false;

  // Prompt user for components folder location
  stdout.write('Enter components folder location (default: lib/components): ');
  String fullPath = "";
  String basePath = Directory.current.path + Platform.pathSeparator;
  String componentsFolder = stdin.readLineSync() ?? "";
  if (componentsFolder.isEmpty) {
    componentsFolder = 'lib/components';
  }
  fullPath = basePath + (componentsFolder);
  // Create the components folder if it doesn't exist
  if (!Directory(fullPath).existsSync()) {
    Directory(fullPath).createSync(recursive: true);
    print('Components folder created: $fullPath');
  } else {
    print('Components folder already exists: $fullPath');
  }
  initDone = true;
  return initDone;
}

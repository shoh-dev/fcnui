import 'dart:io';

///This must be switched manually based on the environment
const bool kDebugMode = false;

const String kPubspecYaml = 'pubspec.yaml';
const String kFlutterCnUiJson = 'fcnui.json';
const String kDefaultInitJsonName = 'fcnui';
const String kDefaultInitJsonVersion = '0.0.1';
const String kDefaultInitJsonDescription = 'Helper package for Flutter CN UI';
const String kDefaultThemeName = 'greyLaw';
const String kDefaultThemeVersion = '0.0.1';
const String kDefaultComponentsFolder = 'components';
String pSeparator = Platform.pathSeparator;
String kProjectBaseLibPath =
    '${Directory.current.path}${pSeparator}lib$pSeparator';

String getComponentsFullPath(String componentsFolder) =>
    kProjectBaseLibPath + (componentsFolder);

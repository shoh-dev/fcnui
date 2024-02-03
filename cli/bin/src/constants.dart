import 'dart:io';

const String kPubspecYaml = 'pubspec.yaml';
const String kFlutterCnUiYaml = 'flutter_cn_ui.yaml';

String pSeparator = Platform.pathSeparator;
String kProjectBaseLibPath =
    '${Directory.current.path}${pSeparator}lib$pSeparator';

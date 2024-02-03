import 'dart:io';

String getComponentsPath() {
  final yourWorkingDir = Directory.current.path;
  return "$yourWorkingDir/lib/components";
}

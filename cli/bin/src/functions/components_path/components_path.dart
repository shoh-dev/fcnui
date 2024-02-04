import 'dart:io';

import '../../constants.dart';
import '../init/init_yaml.dart';

String getComponentsPath() {
  return "$kProjectBaseLibPath${InitYaml().componentsFolderPath}";
}

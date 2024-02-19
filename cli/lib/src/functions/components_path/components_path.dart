import 'package:fcnui/src/functions/init/init_json.dart';
import '../../constants.dart';

String getComponentsPath(InitJson initJson) {
  return "$kProjectBaseLibPath${initJson.initJsonMd.registry.componentsFolder}";
}

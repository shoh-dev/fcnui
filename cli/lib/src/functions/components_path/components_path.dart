import 'package:fcnui/src/functions/init/init_json.dart';

import '../../constants.dart';
import '../../dependency/dependency.dart';

String getComponentsPath() {
  return "$kProjectBaseLibPath${getIt.get<InitJson>().initJsonMd.registry.componentsFolder}";
}

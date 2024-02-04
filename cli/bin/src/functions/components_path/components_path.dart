import '../../constants.dart';
import '../../dependency/dependency.dart';
import '../init/init_json_md.dart';

String getComponentsPath() {
  return "$kProjectBaseLibPath${getIt.get<InitJsonMd>().registry.componentsFolder}";
}

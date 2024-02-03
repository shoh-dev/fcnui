import 'dart:io';

import '../../api/api.dart';
import '../../dependency/dependency.dart';
import '../functions.dart';

Future<void> doAdd(List<String> args) async {
  final String componentName = args[1];

  //Find the given component from db
  final Result componentResult =
      await getIt.get<ApiClient>().findComponent([componentName]);

  componentResult.fold((l) {
    //error from catch
    logger(l, hint: 'error');
  }, (r) {
    //success
    final bool success = r['success'];
    if (!success) {
      logger(r['error'], hint: 'error');
    } else {
      final List<Map<String, dynamic>> listOfComponents =
          r['data'].cast<Map<String, dynamic>>();
      for (var component in listOfComponents) {
        final componentPath = getComponentsPath();
        final componentDir =
            "${Directory(componentPath).path}/${component['name']}.dart";
        //check if this components exists
        if (File(componentDir).existsSync()) {
          logger('Component already exists', hint: 'error');
          exit(0);
        }
        File(componentDir).writeAsStringSync(component['content']);
      }
    }
  });
}

import 'dart:io';

import '../../api/api.dart';
import '../../constants.dart';
import '../../dependency/dependency.dart';
import '../functions.dart';
import '../init/init_json.dart';
import '../init/init_json_md.dart';

Future<void> doAdd(List<String> args) async {
  final List<String> componentNames = args.sublist(1);

  //Find the given component from db
  final componentsResult =
      await getIt.get<ApiClient>().findComponents(componentNames);
  componentsResult.fold((l) {
    //error from catch
    print((l as DefaultErrorImpl).message);
  }, (r) {
    //success
    final bool success = r.success;
    if (!success) {
      if (r.error == null) {
        print('Error from server');
      }
      if (r.error!.message != null) {
        print(r.error!.message!);
      }
    } else {
      final listOfFoundComponents = r.data ?? [];
      final listOfNotFoundComponents = r.error?.notFoundComponents ?? [];

      for (var component in listOfFoundComponents) {
        final componentPath = getComponentsPath();
        //check if componentPath exists
        if (!Directory(componentPath).existsSync()) {
          _createComponentPath(componentPath);
        }
        final componentDir = "$componentPath$pSeparator${component.name}.dart";
        final initJson = getIt.get<InitJson>();
        final componentData = ComponentData.fromComponentFetchData(component);
        //check if this components exists
        if (File(componentDir).existsSync()) {
          if (!initJson.isComponentRegistered(componentData)) {
            //if not registered in the yaml, then register it
            initJson.registerComponent(componentData);
          }
          logger('${component.name} already exists', hint: '');
          continue;
        }

        //check if componentData.depends is not empty

        //write the component to the file if it does not exist
        _writeComponentFile(componentDir, componentData, component, initJson);
      }
      if (listOfNotFoundComponents.isNotEmpty) {
        print('$listOfNotFoundComponents are not found in the database');
      }
    }
  });
}

void _createComponentPath(String componentPath) {
  print('$componentPath does not exist');
  print('Creating $componentPath');
  Directory(componentPath).createSync();
}

void _writeComponentFile(String componentDir, ComponentData componentData,
    ComponentFetchData component, InitJson initJson) {
  File(componentDir).writeAsStringSync(component.content);
  initJson.registerComponent(componentData);
  print('Component ${component.name} added successfully');
}

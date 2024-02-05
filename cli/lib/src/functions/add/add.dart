import 'dart:io';

import '../../api/api.dart';
import '../../api/models/models.dart';
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
          print('$componentPath does not exist');
          print('Creating $componentPath');
          Directory(componentPath).createSync();
        }
        final componentDir = "$componentPath$pSeparator${component.name}.dart";
        final initJson = getIt.get<InitJson>();
        //check if this components exists
        if (File(componentDir).existsSync()) {
          if (!initJson.isComponentRegistered(
              ComponentData.fromComponentFetchData(component))) {
            //if not registered in the yaml, then register it
            initJson.registerComponent(
                ComponentData.fromComponentFetchData(component));
          }
          //todo: handle if exists
          logger('${component.name} already exists', hint: '');
          continue;
        }
        File(componentDir).writeAsStringSync(component.content);
        initJson
            .registerComponent(ComponentData.fromComponentFetchData(component));
        print('Component ${component.name} added successfully');
      }
      if (listOfNotFoundComponents.isNotEmpty) {
        print('$listOfNotFoundComponents are not found in the database');
      }
    }
  });
}

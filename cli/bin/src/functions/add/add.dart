import 'dart:io';

import '../../api/api.dart';
import '../../api/models/models.dart';
import '../../constants.dart';
import '../../dependency/dependency.dart';
import '../functions.dart';

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
        final componentDir = "$componentPath$pSeparator${component.name}.dart";
        //check if this components exists
        if (File(componentDir).existsSync()) {
          //todo: handle if exists
          logger('${component.name} already exists', hint: '');
          continue;
        }
        File(componentDir).writeAsStringSync(component.content);
        print('Component ${component.name} added successfully');
      }
      if (listOfNotFoundComponents.isNotEmpty) {
        print('$listOfNotFoundComponents are not found in the database');
      }
    }
  });
}

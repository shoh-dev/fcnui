import 'dart:io';
import 'package:cli/src/functions/init/init_json.dart';
import 'package:cli/src/functions/init/init_json_md.dart';
import 'package:cli/src/src.dart';

class ComponentMethods {
  final InitJson initJson;

  ComponentMethods({required this.initJson});

  Future<void> add(List<String> components) async {
    final fullComponentsFolder =
        getComponentsFullPath(initJson.initJsonMd.registry.componentsFolder!);

    final componentsResult =
        await getIt.get<ApiClient>().findComponents(components);
    componentsResult.fold(
      (error) {
        print((error as DefaultErrorImpl).message);
      },
      (success) {
        final bool isSuccess = success.success;
        if (!isSuccess) {
          if (success.error == null) {
            print('Error from server');
          }
          if (success.error!.message != null) {
            print(success.error!.message!);
          }
        } else {
          final listOfFoundComponents = success.data ?? [];
          final listOfNotFoundComponents =
              success.error?.notFoundComponents ?? [];

          for (var component in listOfFoundComponents) {
            final componentPath = getComponentsPath();
            //check if componentPath exists
            if (!Directory(componentPath).existsSync()) {
              print('$componentPath does not exist');
              print('Creating $componentPath');
              Directory(componentPath).createSync();
            }
            final componentDir =
                "$componentPath$pSeparator${component.name}.dart";
            final initJson = getIt.get<InitJson>();
            //check if this components exists
            if (File(componentDir).existsSync()) {
              if (!initJson.isComponentRegistered(
                  ComponentData.fromComponentFetchData(component))) {
                //if not registered in the yaml, then register it
                initJson.registerComponent(
                    ComponentData.fromComponentFetchData(component));
              }
              //check if the versions are same
              //if same just print a message
              //else ask the user to update the component
              final bool isSameVersion = component.version ==
                  initJson.getComponentVersion(component.name);
              if (isSameVersion) {
                logger('${component.name} already exists', hint: '');
              } else {
                print('Component ${component.name} already exists with a '
                    'different version: ${component.version}. Old version: ${initJson.getComponentVersion(component.name)}');
                print('Do you want to update the component? (y/N): ');
                final answer = stdin.readLineSync();
                if (answer == 'y') {
                  File(componentDir).writeAsStringSync(component.content);
                  initJson.registerComponent(
                      ComponentData.fromComponentFetchData(component));
                  print(
                      'Component ${component.name}:${component.version} updated successfully');
                }
              }
              continue;
            }
            File(componentDir).writeAsStringSync(component.content);
            initJson.registerComponent(
                ComponentData.fromComponentFetchData(component));
            print('Component ${component.name} added successfully');
          }

          if (listOfNotFoundComponents.isNotEmpty) {
            print('$listOfNotFoundComponents are not found in the database');
          }
        }
      },
    );
    close();
  }
}

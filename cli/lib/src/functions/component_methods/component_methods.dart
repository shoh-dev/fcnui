import 'dart:io';
import 'package:fcnui/src/src.dart';

class ComponentMethods {
  final InitJson initJson;
  final ApiClient apiClient;

  ComponentMethods({required this.initJson, required this.apiClient});

  Future<void> add(List<String> components) async {
    final componentsResult = await apiClient.findComponents(components);
    await componentsResult.fold(
      (error) {
        print("3");
        logger((error as DefaultErrorImpl).message);
      },
      (success) async {
        if (!success.success) {
          _checkSuccess(success);
        } else {
          final listOfFoundComponents = success.data ?? [];
          final listOfNotFoundComponents =
              success.error?.notFoundComponents ?? [];

          for (var component in listOfFoundComponents) {
            final componentPath = getComponentsPath(initJson);
            //check if componentPath exists
            if (!Directory(componentPath).existsSync()) {
              _createComponentPath(componentPath);
            }

            final registryComponentData =
                RegistryComponentData.fromComponentFetchData(component);

            final componentDir =
                "$componentPath$pSeparator${component.name}.dart";

            //check if this components exists
            if (File(componentDir).existsSync() &&
                initJson.isComponentRegistered(registryComponentData)) {
              //check if the versions are same
              //if same just print a message
              //else ask the user to update the component
              final bool isSameVersion = component.version ==
                  initJson.getComponentVersion(component.name);

              if (isSameVersion) {
                logger("'${component.name}' already exists");
              } else {
                _askUserToUpdateComponent(
                    component, registryComponentData, initJson, componentDir);
              }
              continue;
            }
            //If component is not found in the database then add it
            _addComponent(
                componentDir, component, registryComponentData, initJson);

            //Check if component.depends is not empty
            if (component.dependencies.isNotEmpty) {
              logger(
                  "Component '${component.name}' depends on ${component.dependencies}");
              await add(component.dependencies);
            }
          }

          if (listOfNotFoundComponents.isNotEmpty) {
            logger('$listOfNotFoundComponents are not found in the database');
          }
        }
      },
    );
    close();
  }

  void remove(List<String> components) {
    final componentPath = getComponentsPath(initJson);
    for (var component in components) {
      final componentDir = "$componentPath$pSeparator$component.dart";
      if (File(componentDir).existsSync()) {
        File(componentDir).deleteSync();
        initJson.unregisterComponent(component);
        logger("Component '$component' removed successfully");
      } else {
        logger("Component '$component' does not exist");
      }
    }
    close();
  }
}

void _createComponentPath(String componentPath) {
  logger('$componentPath does not exist');
  logger('Creating $componentPath');
  Directory(componentPath).createSync();
}

void _askUserToUpdateComponent(
    ComponentFetchData component,
    RegistryComponentData registryComponentData,
    InitJson initJson,
    String componentDir) {
  logger(
      'Component ${component.name} already exists with a different version: ${component.version}. Old version: ${initJson.getComponentVersion(component.name)}');
  logger(
      'Do you want to update the component (Note your component will be overwritten)? (y/n): ');
  final answer = stdin.readLineSync();
  if (answer == 'y') {
    _updateComponent(componentDir, component, registryComponentData, initJson);
  } else {
    logger("Component '${component.name}' not updated");
  }
}

void _updateComponent(String componentDir, ComponentFetchData component,
    RegistryComponentData registryComponentData, InitJson initJson) {
  File(componentDir).writeAsStringSync(component.content);
  initJson.registerComponent(registryComponentData);
  logger(
      "Component '${component.name}':${component.version} updated successfully");
}

void _addComponent(String componentDir, ComponentFetchData component,
    RegistryComponentData registryComponentData, InitJson initJson) {
  File(componentDir).writeAsStringSync(component.content);
  initJson.registerComponent(registryComponentData);
  logger("Component '${component.name}' added successfully");
}

void _checkSuccess(
    DefaultResponse<List<ComponentFetchData>, ComponentFetchError> success) {
  if (success.error == null) {
    logger('Error from server');
  }
  if (success.error!.message != null) {
    logger(success.error!.message!);
  }
}

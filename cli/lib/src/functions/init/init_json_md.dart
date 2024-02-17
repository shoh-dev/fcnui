import 'package:equatable/equatable.dart';

import '../../api/models/component_md.dart';
import '../../constants.dart';

class InitJsonMd extends Equatable {
  final String name;
  final String version;
  final String description;
  final Registry registry;

  const InitJsonMd({
    this.name = kDefaultInitJsonName,
    this.version = kDefaultInitJsonVersion,
    this.description = kDefaultInitJsonDescription,
    this.registry = const Registry(),
  });

  //fromJson
  factory InitJsonMd.fromJson(Map<String, dynamic> json) {
    return InitJsonMd(
      name: json['name'] as String,
      version: json['version'] as String,
      description: json['description'] as String,
      registry: Registry.fromJson(json['registry'] as Map<String, dynamic>),
    );
  }

  //toJson
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'version': version,
      'description': description,
      'registry': registry.toJson(),
    };
  }

  //copyWith
  InitJsonMd copyWith({
    String? name,
    String? version,
    String? description,
    Registry? registry,
  }) {
    return InitJsonMd(
      name: name ?? this.name,
      version: version ?? this.version,
      description: description ?? this.description,
      registry: registry ?? this.registry,
    );
  }

  @override
  List<Object> get props => [name, version, description, registry];
}

class Registry extends Equatable {
  final ThemeData theme;
  final String? componentsFolder;
  final List<ComponentData> components;

  const Registry({
    this.theme = const ThemeData(),
    this.componentsFolder,
    this.components = const <ComponentData>[],
  });

  //fromJson
  factory Registry.fromJson(Map<String, dynamic> json) {
    return Registry(
      theme: ThemeData.fromJson(json['theme'] as Map<String, dynamic>),
      componentsFolder: json['componentsFolder'] as String?,
      components: (json['components'] as List<dynamic>)
          .map((e) => ComponentData.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  //toJson
  Map<String, dynamic> toJson() {
    return {
      'theme': theme.toJson(),
      'componentsFolder': componentsFolder,
      'components': components.map((e) => e.toJson()).toList(),
    };
  }

  //copyWith
  Registry copyWith({
    ThemeData? theme,
    String? componentsFolder,
    List<ComponentData>? components,
  }) {
    return Registry(
      theme: theme ?? this.theme,
      componentsFolder: componentsFolder ?? this.componentsFolder,
      components: components ?? this.components,
    );
  }

  @override
  List<Object?> get props => [theme, componentsFolder, components];
}

class ThemeData extends Equatable {
  final String name;
  final String version;

  const ThemeData({
    this.name = kDefaultThemeName,
    this.version = kDefaultThemeVersion,
  });

  //fromJson
  factory ThemeData.fromJson(Map<String, dynamic> json) {
    return ThemeData(
      name: json['name'] as String,
      version: json['version'] as String,
    );
  }

  //toJson
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'version': version,
    };
  }

  //copyWith
  ThemeData copyWith({
    String? name,
    String? version,
  }) {
    return ThemeData(
      name: name ?? this.name,
      version: version ?? this.version,
    );
  }

  @override
  List<Object> get props => [name, version];
}

class ComponentData extends Equatable {
  final String name;
  final String version;
  final List<String> depends;

  const ComponentData({
    required this.name,
    required this.version,
    this.depends = const <String>[],
  });

  //fromJson
  factory ComponentData.fromJson(Map<String, dynamic> json) {
    return ComponentData(
      name: json['name'] as String,
      version: json['version'] as String,
      depends:
          (json['depends'] as List<dynamic>).map((e) => e as String).toList(),
    );
  }

  //fromComponentFetchData
  factory ComponentData.fromComponentFetchData(ComponentFetchData data) {
    return ComponentData(
      name: data.name,
      version: data.version,
      depends: data.depends,
    );
  }

  //toJson
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'version': version,
      'depends': depends,
    };
  }

  //copyWith
  ComponentData copyWith({
    String? name,
    String? version,
    List<String>? depends,
  }) {
    return ComponentData(
      name: name ?? this.name,
      version: version ?? this.version,
      depends: depends ?? this.depends,
    );
  }

  @override
  List<Object> get props => [name, version, depends];
}

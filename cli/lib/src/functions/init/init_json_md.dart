import '../../api/models/component_md.dart';
import '../../constants.dart';

class InitJsonMd {
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
}

class Registry {
  final ThemeData theme;
  final String? componentsFolder;
  final List<RegistryComponentData> components;

  const Registry({
    this.theme = const ThemeData(),
    this.componentsFolder,
    this.components = const <RegistryComponentData>[],
  });

  //fromJson
  factory Registry.fromJson(Map<String, dynamic> json) {
    return Registry(
      theme: ThemeData.fromJson(json['theme'] as Map<String, dynamic>),
      componentsFolder: json['componentsFolder'] as String?,
      components: (json['components'] as List<dynamic>)
          .map((e) => RegistryComponentData.fromJson(e as Map<String, dynamic>))
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
    List<RegistryComponentData>? components,
  }) {
    return Registry(
      theme: theme ?? this.theme,
      componentsFolder: componentsFolder ?? this.componentsFolder,
      components: components ?? this.components,
    );
  }
}

class ThemeData {
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
}

class RegistryComponentData {
  final String name;
  final String version;

  const RegistryComponentData({
    required this.name,
    required this.version,
  });

  //fromJson
  factory RegistryComponentData.fromJson(Map<String, dynamic> json) {
    return RegistryComponentData(
      name: json['name'] as String,
      version: json['version'] as String,
    );
  }

  //fromComponentFetchData
  factory RegistryComponentData.fromComponentFetchData(
      ComponentFetchData data) {
    return RegistryComponentData(
      name: data.name,
      version: data.version,
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
  RegistryComponentData copyWith({
    String? name,
    String? version,
  }) {
    return RegistryComponentData(
      name: name ?? this.name,
      version: version ?? this.version,
    );
  }
}

import 'models.dart';

class ComponentFetchData extends DefaultData {
  final String name;
  final String content;
  final String version;
  const ComponentFetchData({
    required this.name,
    required this.content,
    required this.version,
  });

  factory ComponentFetchData.fromJson(Map<String, dynamic> json) {
    final data = json;
    return ComponentFetchData(
      name: data['name'],
      content: data['content'],
      version: data['version'],
    );
  }

  @override
  bool? get stringify => true;

  @override
  List<Object?> get props => [name, content, version];
}

class ComponentFetchError extends DefaultError {
  final List<String> notFoundComponents;

  const ComponentFetchError(
      {super.message, this.notFoundComponents = const []});

  @override
  List<Object?> get props => [message, notFoundComponents];

  factory ComponentFetchError.fromJson(Map<String, dynamic> json) {
    final error = json['error'];
    return ComponentFetchError(
      message: error is String ? error : null,
      notFoundComponents: error is Map
          ? error['notFoundComponents'] != null
              ? List<String>.from(error['notFoundComponents'])
              : []
          : [],
    );
  }

  @override
  bool? get stringify => true;
}

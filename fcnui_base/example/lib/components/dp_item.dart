//v0.0.1

import 'package:fcnui_base/fcnui_base.dart';

class DpItem extends Equatable {
  final String id;
  final String title;
  final String? subtitle;

  const DpItem({required this.id, required this.title, this.subtitle});

  @override
  List<Object?> get props => [id, title, subtitle];
}

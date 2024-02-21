//v0.0.1

import 'package:fcnui_base/fcnui_base.dart';
import 'package:flutter/material.dart';

class DpItem extends Equatable {
  final String id;
  final String title;
  final String? subtitle;
  final IconData? icon;

  const DpItem(
      {required this.id, required this.title, this.subtitle, this.icon});

  @override
  List<Object?> get props => [id, title, subtitle, icon];

  //copyWith
  DpItem copyWith({
    String? id,
    String? title,
    String? subtitle,
    IconData? icon,
  }) {
    return DpItem(
      id: id ?? this.id,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      icon: icon ?? this.icon,
    );
  }
}

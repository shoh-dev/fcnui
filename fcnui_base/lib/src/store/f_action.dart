import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

abstract class FAction extends Equatable {
  FAction() {
    debugPrint(toString());
  }

  @override
  String toString() {
    return 'FAction => $runtimeType => props: $props';
  }
}

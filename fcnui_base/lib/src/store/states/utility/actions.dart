import 'package:fcnui_base/src/store/f_action.dart';

class UpdateUtilityState extends FAction {
  final bool? isScreenUtilEnabled;
  UpdateUtilityState({this.isScreenUtilEnabled});

  @override
  List<Object?> get props => [isScreenUtilEnabled];
}

class ChangeScreenUtilEnabledState extends FAction {
  final bool isScreenUtilEnabled;

  ChangeScreenUtilEnabledState({required this.isScreenUtilEnabled});

  @override
  List<Object?> get props => [isScreenUtilEnabled];
}

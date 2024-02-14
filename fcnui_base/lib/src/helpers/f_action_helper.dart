import 'package:fcnui_base/fcnui_base.dart';
import 'package:fcnui_base/src/store/f_action.dart';

extension FActionHelper on FAction {
  dynamic payload() {
    fcnGetIt.get<Store<AppState>>().dispatch(this);
  }
}

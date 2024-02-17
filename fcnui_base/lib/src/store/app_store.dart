import 'package:fcnui_base/src/store/app_reducer.dart';
import 'package:redux/redux.dart';
import 'app_state.dart';
import 'middlewares/middlewares.dart';

final appStore =
    Store<AppState>(appReducer, initialState: AppState.initial(), middleware: [
  ThemeStateMiddleware(),
  UtilityStateMiddleware(),
]);

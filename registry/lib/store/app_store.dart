import 'package:redux/redux.dart';
import 'package:registry/store/app_reducer.dart';
import 'app_state.dart';
import 'middlewares/middlewares.dart';

final appStore =
    Store<AppState>(appReducer, initialState: AppState.initial(), middleware: [
  ThemeStateMiddleware(),
]);

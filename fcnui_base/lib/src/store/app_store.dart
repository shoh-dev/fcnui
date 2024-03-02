import 'package:fcnui_base/src/store/app_reducer.dart';
import 'package:redux/redux.dart';
import 'app_state.dart';
import 'middlewares/middlewares.dart';

final appStore = Store<FcnuiAppState>(appReducer,
    initialState: FcnuiAppState.initial(),
    middleware: [
      ThemeStateMiddleware(),
      UtilityStateMiddleware(),
    ]);

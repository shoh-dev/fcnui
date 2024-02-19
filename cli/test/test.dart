import 'idle.test.dart';
import 'initjson.test.dart';
import 'initialization.test.dart';

void main() {
  //Called before initial
  idleTest();

  //Called after initial
  initJsonTest();
  initializationTest();
  // componentMethodsTest();
}

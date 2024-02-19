import 'package:fcnui/src/src.dart';
import 'package:test/test.dart';

void initializationTest() {
  late final InitJson initJson;
  late final InitJsonMd initJsonMd;
  late final Initialization initialization;
  group("initialization", () {
    setUpAll(() {
      initJson = InitJson(path: "test/fcnui.json");
      initJson.initJsonFile();
      initJsonMd = initJson.getCnUiJson();
      initialization = Initialization(initJson: initJson);
    });

    test("initialization init", () {
      expect(initialization.init(initJsonMd.registry.componentsFolder!),
          equals(initJsonMd.registry.componentsFolder));
    });
  });
}

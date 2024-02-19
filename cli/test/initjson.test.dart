import 'package:fcnui/src/src.dart';
import 'package:test/test.dart';

void initJsonTest() {
  late final InitJson initJson;
  late final InitJsonMd initJsonMd;

  group("iniJson test", () {
    setUpAll(() {
      initJson = InitJson(path: "test/fcnui.json");
      initJson.initJsonFile();
      initJsonMd = initJson.getCnUiJson();
    });
    test("finds fcnui file", () {
      final jsonMd = initJson.getCnUiJson();
      //is type of InitJsonMd
      expect(jsonMd, isA<InitJsonMd>());
    });

    //test updateJson
    test("update fcnui file", () {
      final newJsonData = initJsonMd.copyWith(
          registry:
              initJsonMd.registry.copyWith(componentsFolder: "components"));
      initJson.updateJson(newJsonData);
      expect(initJson.getCnUiJson().registry.componentsFolder, "components");
    });
  });
}

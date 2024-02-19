import 'package:fcnui/src/src.dart';
import 'package:test/test.dart';

void idleTest() {
  group("idle functions", () {
    //Test help command
    test("help test", () {
      expect(helpCommand(), helpResponse);
    });

    //Test version command
    test("version test", () {
      expect(versionCommand(), versionResponse);
    });

    //Is Flutter project
    test("isFlutterProject test true", () {
      expect(isFlutterProject("test/test_pubspec.yaml"), isNotNull);
    });

    test("isFlutterProject test false", () {
      expect(isFlutterProject("test/test_pubspec_false.yaml"), isNull);
    });
  });
}

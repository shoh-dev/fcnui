import 'package:fcnui/src/functions/log/logger.dart';

const String helpResponse = '''
init
  - Initialize the project

add <componentName>
  - Add a new component

remove <componentName>
  - Remove a component

version
  - Get the current version of the CLI

[Visit https://fcnui.shoh.dev/docs/get_started for more information]
''';

String helpCommand() {
  logger(helpResponse);
  return helpResponse;
}

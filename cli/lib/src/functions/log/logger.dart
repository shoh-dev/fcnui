import 'package:fcnui/src/constants.dart';

void logger(dynamic message, {String? hint}) {
  if (!isTestMode) {
    print(message.toString());
  }
}

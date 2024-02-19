import 'package:fcnui/src/functions/log/logger.dart';

const versionResponse = '1.0.6';

String versionCommand() {
  logger('Version: $versionResponse');
  return versionResponse;
}

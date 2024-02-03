void logger(dynamic message, {String hint = "LOGGER"}) {
  print("-----------$hint-----------");
  print(message.toString());
  print("-----------$hint-----------");
}

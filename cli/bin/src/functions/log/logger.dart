void logger(dynamic message, {String? hint}) {
  print("-----------$hint-----------");
  print(message.toString());
  print("-----------$hint-----------");
}

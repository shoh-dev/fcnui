extension IterableHelper on Iterable {
  //First where or null
  T? firstWhereOrNull<T>(bool Function(T) test) {
    for (var element in this) {
      if (test(element)) {
        return element;
      }
    }
    return null;
  }
}

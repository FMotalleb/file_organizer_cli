abstract class Storage<T> implements Iterator<T> {
  T pop();
  void push(T value);
  void pushAll(Iterable<T> list);
  bool get isEmpty;
  bool get isNotEmpty;
}

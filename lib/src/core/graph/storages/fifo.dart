import 'package:file_organizer_cli/src/core/graph/storages/storage.dart';

class Fifo<T> extends Storage<T> {
  Fifo(this._source);
  Fifo.empty() : _source = [];

  @override
  T get current => _source.first;
  final List<T> _source;

  @override
  void push(T value) => _source.add(value);
  @override
  T pop() => _source.removeAt(0);

  @override
  void pushAll(Iterable<T> list) => _source.addAll(list);

  @override
  bool get isEmpty => _source.isEmpty;
  @override
  bool get isNotEmpty => _source.isNotEmpty;
  @override
  bool moveNext() {
    if (_source.length == 1) {
      return false;
    }
    _source.removeAt(0);
    return true;
  }
}

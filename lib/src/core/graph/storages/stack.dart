import 'package:file_organizer_cli/src/core/graph/storages/linked_list.dart';
import 'package:file_organizer_cli/src/core/graph/storages/storage.dart';

final _noItemError = Exception('No Item In Storage');

class Stack<T> extends Storage<T> {
  Stack([Iterable<T> list = const []])
      : _source = list.isEmpty
            ? null
            : LinkedArrayNode.fromArray(
                list,
              );

  Stack.empty() : _source = null;

  @override
  T get current {
    if (_source == null) {
      throw _noItemError;
    }
    return _source!.data;
  }

  LinkedArrayNode<T>? _source;

  @override
  void push(T value) {
    if (_source == null) {
      _source = LinkedArrayNode<T>(
        value,
      );
    } else {
      _source = _source!.add(value);
    }
  }

  @override
  T pop() {
    final source = _source;
    if (source == null) {
      throw _noItemError;
    }

    final data = source.data;
    _source = source.next;
    return data;
  }

  @override
  void pushAll(Iterable<T> list) {
    if (list.isEmpty) return;
    if (_source == null) {
      _source = LinkedArrayNode<T>.fromArray(
        list,
      );
    } else {
      _source = _source!.addAll(list);
    }
  }

  @override
  bool get isEmpty => _source == null;
  @override
  bool get isNotEmpty => _source != null;

  @override
  bool moveNext() {
    if (_source == null) {
      return false;
    }
    _source = _source!.next;
    return true;
  }
}

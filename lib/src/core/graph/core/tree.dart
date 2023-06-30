import 'dart:async';

import 'package:meta/meta.dart';

abstract class ITree<T> {
  List<T> get children;
  @mustCallSuper
  Future<bool> removeChild(T child);
  @mustCallSuper
  Future<void> addChild(T child);
}

extension ITreeHelper<T> on ITree<T> {
  Future<void> onChildren(FutureOr<void> Function(T) task) async {
    final internalChildren = children.toList();
    for (final child in internalChildren) {
      await task(child);
    }
  }
}

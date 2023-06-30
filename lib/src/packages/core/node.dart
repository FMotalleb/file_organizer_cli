import 'dart:async';

import 'package:file_organizer_cli/src/packages/core/tree.dart';
import 'package:file_organizer_cli/src/packages/node_crawlers/node_crawlers.dart';
import 'package:meta/meta.dart';

abstract class INode extends ITree<INode> {
  INode? get parent;
  @mustCallSuper
  @visibleForOverriding
  set parent(INode? node) {
    if (node == null) {
      close();
    } else if (parent != null) {
      throw Exception('You Cannot switch parent of a living being');
    }
  }

  bool get isClosed;
  @mustCallSuper
  Future<void> onPlanted() => Future.value();
  @mustCallSuper
  Future<void> close() => onChildren((p0) => p0.close());

  @mustCallSuper
  Future<void> flush() => onChildren(
        (p0) => p0.flush(),
      );
  @override
  Future<void> addChild(INode child) {
    child.parent = this;
    return child.onPlanted();
  }
}

extension INodeHelper on INode {
  @protected
  bool get isEdge => children.isEmpty;

  int get depth => NodeCrawler(crawlMethod: Node2RootCrawler(this)).length;
  void printTree([String? prefix]) {
    prefix ??= '-';
    print('$prefix $this');
    // final maxIndex = children.length - 1;
    for (final i in children.asMap().entries) {
      i.value.printTree('$prefix-');
    }
  }

  INode get context => this;
}

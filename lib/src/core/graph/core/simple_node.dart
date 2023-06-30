import 'package:file_organizer_cli/src/core/graph/core/node.dart';

class Node extends INode {
  Node() : children = [];

  static Future<Node> newNode([List<INode>? children]) async {
    final newNode = Node();
    if (children == null) return newNode;
    for (final i in children) {
      await newNode.addChild(i);
    }
    return newNode;
  }

  @override
  final List<INode> children;

  @override
  Future<void> close() async {
    isClosed = true;
    return super.close();
  }

  @override
  bool isClosed = false;

  @override
  Future<bool> removeChild(INode child) async {
    return children.remove(child);
  }

  @override
  Future<void> addChild(INode child) async {
    children.add(child);
    return super.addChild(child);
  }

  @override
  INode? get parent => _parent;
  INode? _parent;
  @override
  set parent(INode? node) {
    super.parent = node;
    _parent = node;
  }
}

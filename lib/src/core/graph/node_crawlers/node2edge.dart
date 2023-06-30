import 'package:file_organizer_cli/src/core/graph/core/node.dart';
import 'package:file_organizer_cli/src/core/graph/node_crawlers/node_crawlers.dart';
import 'package:file_organizer_cli/src/core/graph/storages/stack.dart';

class Node2EdgeCrawler implements NodeCrawlMethod {
  Node2EdgeCrawler(this._current);
  @override
  INode get current => _current;
  INode _current;
  final Stack<INode> _crawlStack = Stack.empty();
  @override
  bool moveNext() {
    _crawlStack.pushAll(_current.children);
    if (_crawlStack.isEmpty) {
      return false;
    }
    _current = _crawlStack.pop();
    return true;
  }
}

import 'package:file_organizer_cli/src/core/graph/core/node.dart';
import 'package:file_organizer_cli/src/core/graph/node_crawlers/node_crawlers.dart';
import 'package:file_organizer_cli/src/core/graph/storages/stack.dart';

typedef _DepthCrawlInfo = ({int depth, INode node});

class ToDeepestEdge implements Node2EdgeCrawler {
  ToDeepestEdge(INode node)
      : _currentDeepestNode = (depth: 0, node: node),
        _currentNode = (depth: 0, node: node),
        _crawlStack = Stack.empty();
  final Stack<_DepthCrawlInfo> _crawlStack;
  @override
  INode get current => _currentDeepestNode.node;
  _DepthCrawlInfo _currentDeepestNode;
  _DepthCrawlInfo _currentNode;

  @override
  bool moveNext() {
    _crawlStack.pushAll(
      _currentNode.node.children.map(
        (e) => (depth: _currentNode.depth + 1, node: e),
      ),
    );
    if (_crawlStack.isEmpty) {
      return false;
    }
    _currentNode = _crawlStack.pop();
    if (_currentNode.depth >= _currentDeepestNode.depth) {
      _currentDeepestNode = _currentNode;
    }
    return true;
  }
}

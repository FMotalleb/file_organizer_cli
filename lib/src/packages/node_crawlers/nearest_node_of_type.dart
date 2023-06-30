import 'package:file_organizer_cli/src/packages/core/node.dart';
import 'package:file_organizer_cli/src/packages/node_crawlers/node_crawlers.dart';
import 'package:file_organizer_cli/src/packages/storages/fifo.dart';
import 'package:file_organizer_cli/src/packages/storages/storage.dart';

typedef _DepthCrawlInfo<T extends INode> = ({int depth, T node});

class ToNearestNodeOfType<T extends INode> implements Node2EdgeCrawler {
  ToNearestNodeOfType(INode node)
      : _currentNearestNode = (depth: 0, node: node),
        _currentNode = (depth: 0, node: node),
        _crawlStack = Fifo.empty();
  final Storage<_DepthCrawlInfo> _crawlStack;
  @override
  INode get current => _currentNearestNode.node;
  _DepthCrawlInfo _currentNearestNode;
  _DepthCrawlInfo _currentNode;
  @override
  bool moveNext() {
    final isCorrectType = _currentNode.node is T;
    if (isCorrectType == false) {
      _crawlStack.pushAll(
        _currentNode.node.children.map(
          (e) => (depth: _currentNode.depth + 1, node: e),
        ),
      );
    }
    if (isCorrectType) {
      if (_currentNode.depth <= _currentNearestNode.depth || //
          _currentNearestNode.node is! T) {
        _currentNearestNode = _currentNode;
      }
    }
    if (_crawlStack.isEmpty) {
      return false;
    }
    _currentNode = _crawlStack.pop();

    return true;
  }
}

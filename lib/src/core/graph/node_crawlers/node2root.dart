import 'package:file_organizer_cli/src/core/graph/core/node.dart';
import 'package:file_organizer_cli/src/core/graph/node_crawlers/node_crawlers.dart';

class Node2RootCrawler implements NodeCrawlMethod {
  Node2RootCrawler(this._current);
  @override
  INode get current => _current;
  INode _current;
  @override
  bool moveNext() {
    if (_current.parent == null) {
      return false;
    }
    _current = _current.parent!;
    return true;
  }
}

import 'package:file_organizer_cli/src/packages/core/node.dart';

typedef NodeCrawlMethod = Iterator<INode>;

class NodeCrawler extends Iterable<INode> {
  NodeCrawler({
    required NodeCrawlMethod crawlMethod,
  }) : iterator = crawlMethod;

  @override
  final Iterator<INode> iterator;
}

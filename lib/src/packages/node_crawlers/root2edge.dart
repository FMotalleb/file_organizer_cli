import 'package:file_organizer_cli/src/packages/core/node.dart';
import 'package:file_organizer_cli/src/packages/node_crawlers/node_crawlers.dart';

class Root2EdgeCrawler extends Node2EdgeCrawler {
  factory Root2EdgeCrawler(INode node) {
    final root = NodeCrawler(
      crawlMethod: Node2RootCrawler(node),
    ).last;
    return Root2EdgeCrawler._(root);
  }

  Root2EdgeCrawler._(super.root);
}

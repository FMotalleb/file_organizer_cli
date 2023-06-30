import 'package:file_organizer_cli/src/core/graph/core/node.dart';
import 'package:file_organizer_cli/src/core/graph/node_crawlers/node_crawlers.dart';

T firstParentOfType<T extends INode>(
  INode node,
) =>
    parentsOfType<T>(node).first;

Iterable<T> parentsOfType<T extends INode>(INode node) {
  return NodeCrawler(
    crawlMethod: Node2RootCrawler(node),
  ).whereType<T>();
}

Iterable<T> branchesOfType<T extends INode>(INode node) {
  return NodeCrawler(
    crawlMethod: Node2EdgeCrawler(node),
  ).whereType<T>();
}

T deepestBranchOfType<T extends INode>(INode node) {
  return NodeCrawler(
    crawlMethod: ToDeepestNodeOfType<T>(node),
  ).whereType<T>().last;
}

T nearestBranchOf<T extends INode>(INode node) {
  return NodeCrawler(
    crawlMethod: ToNearestNodeOfType<T>(node),
  ).whereType<T>().last;
}

import 'package:file_organizer_cli/src/packages/core/node.dart';

abstract class IHydratedNode extends INode {
  Future<Map<String, dynamic>> toMap();
  Future<void> fromMap(Map<String, dynamic> map, INode? parent);
}

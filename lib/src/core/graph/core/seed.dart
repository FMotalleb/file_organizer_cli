import 'package:file_organizer_cli/src/core/graph/core/simple_node.dart';

class Seed extends Node {
  Seed(this._branches) : isPlanted = false;

  final List<Seed> _branches;
  bool isPlanted;
  Future<void> plant() async {
    for (final b in _branches) {
      await addChild(b);
      await b.plant();
    }
    isPlanted = true;
  }
}

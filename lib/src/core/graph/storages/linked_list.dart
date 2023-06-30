final class LinkedArrayNode<T> {
  LinkedArrayNode(
    this.data, {
    this.next,
  });
  factory LinkedArrayNode.fromArray(Iterable<T> list) {
    final root = LinkedArrayNode(list.first);
    final skipped = list.skip(1);
    return root.addAll(skipped);
  }

  final T data;

  LinkedArrayNode<T>? next;

  LinkedArrayNode<T> add(T data) => LinkedArrayNode(
        data,
        next: this,
      );

  LinkedArrayNode<T> addAll(Iterable<T> data) => data.fold<LinkedArrayNode<T>>(
        this,
        (
          last,
          current,
        ) =>
            last.add(current),
      );
}

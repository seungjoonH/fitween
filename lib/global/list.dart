extension ListExtension on List {
  void shift(int i) {
    if (i == 0 || isEmpty) return;
    List x = sublist(i);
    x.addAll(sublist(0, i));
    clear(); addAll(x);
  }
}
import 'package:fitween/model/enum/part.dart';

class Limb {
  late Part part1;
  late Part part2;
  late Part part3;

  Limb(this.part1, this.part2, this.part3);
  Limb.list(List<Part> list) {
    part1 = list[0];
    part2 = list[1];
    part3 = list[2];
  }
  Limb.intList(List<int> list) {
    part1 = Part.values[list[0]];
    part2 = Part.values[list[1]];
    part3 = Part.values[list[2]];
  }

  bool contains(Part part) {
    return [part1, part2, part3].contains(part);
  }
}
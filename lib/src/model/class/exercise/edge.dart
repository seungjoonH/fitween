import 'package:fitween/src/model/class/exercise.dart';

class Edge {
  late Part part1;
  late Part part2;

  Edge(this.part1, this.part2);
  Edge.index(int index1, int index2) {
    part1 = Part.values[index1];
    part2 = Part.values[index2];
  }

  bool equalTo(Edge edge) => (
      edge.part1 == part1 && edge.part2 == part2
          || edge.part1 == part2 && edge.part2 == part1
  );
}

class Edges {
  static List<Edge> list = [
    Edge.index( 0,  1), // nose to left_eye
    Edge.index( 0,  2), // nose to right_eye
    Edge.index( 1,  3), // left_eye to left_ear
    Edge.index( 2,  4), // right_eye to right_ear
    Edge.index( 0,  5), // nose to left_shoulder
    Edge.index( 0,  6), // nose to right_shoulder
    Edge.index( 5,  7), // left_shoulder to left_elbow
    Edge.index( 7,  9), // left_elbow to left_wrist
    Edge.index( 6,  8), // right_shoulder to right_elbow
    Edge.index( 8, 10), // right_elbow to right_wrist
    Edge.index( 5,  6), // left_shoulder to right_shoulder
    Edge.index( 5, 11), // left_shoulder to left_hip
    Edge.index( 6, 12), // right_shoulder to right_hip
    Edge.index(11, 12), // left_hip to right_hip
    Edge.index(11, 13), // left_hip to left_knee
    Edge.index(13, 15), // left_knee to left_ankle
    Edge.index(12, 14), // right_hip to right_knee
    Edge.index(14, 16), // right_knee to right_ankle
  ];
}
enum ExerciseUnit {
  minute, step, kilometer, count, weight;

  static List<ExerciseUnit> get distances => [minute, step, kilometer];
  static List<ExerciseUnit> get weights => [count, weight];
}
import 'package:fitween/model/class/game/rocket_up.dart';
import 'package:flame/components.dart';

class LevelManager extends Component with HasGameRef<RocketUp> {
  LevelManager({this.selectedLevel = 1, this.level = 1});

  int selectedLevel;
  int level; //
  final Map<int, Difficulty> levelsConfig = {
    1: const Difficulty(
        gravity: 8.0, score: 0),
    2: const Difficulty(
        gravity: 8.5, score: 20),
    3: const Difficulty(
        gravity: 9, score: 40),
    4: const Difficulty(
        gravity: 10, score: 80),
    5: const Difficulty(
        gravity: 11, score: 100),
  };

  double get startingGravity {
    return levelsConfig[selectedLevel]!.gravity;
  }

  double get gravity {
    return levelsConfig[level]!.gravity;
  }

  Difficulty get difficulty {
    return levelsConfig[level]!;
  }

  bool shouldLevelUp(int score) {
    int nextLevel = level + 1;

    if (levelsConfig.containsKey(nextLevel)) {
      return levelsConfig[nextLevel]!.score == score;
    }

    return false;
  }

  List<int> get levels {
    return levelsConfig.keys.toList();
  }

  void increaseLevel() {
    if (level < levelsConfig.keys.length) {
      level++;
    }
  }

  void setLevel(int newLevel) {
    if (levelsConfig.containsKey(newLevel)) {
      level = newLevel;
    }
  }

  void selectLevel(int selectLevel) {
    if (levelsConfig.containsKey(selectLevel)) {
      selectedLevel = selectLevel;
    }
  }

  void reset() {
    level = selectedLevel;
  }
}

class Difficulty {
  final double gravity;
  final int score;

  const Difficulty(
      {required this.gravity,
        required this.score});
}
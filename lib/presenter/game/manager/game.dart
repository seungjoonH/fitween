import 'package:fitween/model/class/game/rocket_up.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class GameManager extends Component with HasGameRef<RocketUp> {
  GameManager();
  ValueNotifier<int> score = ValueNotifier(0);
  GameState state = GameState.intro;

  bool get isPlaying => state == GameState.playing;
  bool get isGameOver => state == GameState.gameOver;
  bool get isIntro => state == GameState.intro;

  void reset() {
    score.value = 0;
    state = GameState.intro;
  }

  void increaseScore() {
    score.value++;
  }
}

enum GameState { intro, playing, gameOver }
import 'dart:ui';

import 'package:fitween/model/class/game/sprites/player.dart';
import 'package:fitween/model/class/game/world.dart';
import 'package:fitween/model/class/workout/handler.dart';
import 'package:fitween/model/enum/workout.dart';
import 'package:fitween/presenter/game/manager/game.dart';
import 'package:fitween/presenter/game/manager/level.dart';
import 'package:fitween/presenter/game/manager/object.dart';
import 'package:flame/input.dart';
import 'package:flame/game.dart';

class RocketUp extends FlameGame
    with HasKeyboardHandlerComponents, HasCollisionDetection {

  final World _world = World();
  LevelManager levelManager = LevelManager();
  GameManager gameManager = GameManager();
  ObjectManager objectManager = ObjectManager();
  int screenBufferSpace = 300;

  late Player player;

  @override
  Future<void> onLoad() async {
    await add(_world);

    await add(gameManager);
    overlays.add('gameOverlay');
    await add(levelManager);
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (gameManager.isGameOver) {
      return;
    }

    if (gameManager.isIntro) {
      startGame();
      return;
    }

    if (gameManager.isPlaying) {
      final Rect worldBounds = Rect.fromLTRB(
        0,
        camera.position.y - screenBufferSpace,
        camera.gameSize.x,
        camera.position.y + _world.size.y,
      );
      camera.worldBounds = worldBounds;
      if (player.isMovingDown) {
        camera.worldBounds = worldBounds;
      }

      var isInTopHalfOfScreen = player.position.y <= (_world.size.y / 2);
      if (!player.isMovingDown && isInTopHalfOfScreen) {
        camera.followComponent(player);
      }

      if (player.position.y >
          camera.position.y +
              _world.size.y +
              player.size.y +
              screenBufferSpace) {
        onLose();
      }
    }
  }

  @override
  Color backgroundColor() {
    return const Color.fromARGB(255, 241, 247, 249);
  }

  void initializeGameStart() {
    setCharacter();

    gameManager.reset();

    if (children.contains(objectManager)) objectManager.removeFromParent();

    levelManager.reset();

    player.reset();
    camera.worldBounds = Rect.fromLTRB(
      0,
      -_world.size.y, // top of screen is 0, so negative is already off screen
      camera.gameSize.x,
      _world.size.y +
          screenBufferSpace, // makes sure bottom bound of game is below bottom of screen
    );
    camera.followComponent(player);

    player.resetPosition();

    objectManager = ObjectManager();

    add(objectManager);
  }

  void setCharacter() {
    player = Player();
    add(player);
  }

  void startGame() {
    initializeGameStart();
    gameManager.state = GameState.playing;
    overlays.remove('mainMenuOverlay');
  }

  void resetGame() {
    startGame();
    overlays.remove('gameOverOverlay');
  }

  void onLose() {
    gameManager.state = GameState.gameOver;
    player.removeFromParent();
    overlays.add('gameOverOverlay');
  }

  void togglePauseState() {
    if (paused) {
      resumeEngine();
    } else {
      pauseEngine();
    }
  }
}
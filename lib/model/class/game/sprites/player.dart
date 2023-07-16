import 'dart:async';

import 'package:fitween/model/class/game/rocket_up.dart';
import 'package:fitween/model/enum/player_state.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/services.dart';

class Player extends SpriteGroupComponent<PlayerState>
    with HasGameRef<RocketUp>, CollisionCallbacks {
  Player({
    super.position,
    this.jumpSpeed = 600,
  }) : super(
    size: Vector2(79, 109),
    anchor: Anchor.topCenter,
    priority: 1,
  );

  int _hAxisInput = 0;
  Vector2 _velocity = Vector2.zero();
  bool get isMovingDown => _velocity.y > 0;
  double jumpSpeed;
  double _gravity = 0;

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    await add(CircleHitbox());

    await _loadCharacterSprites();
    current = PlayerState.center;
  }

  @override
  void update(double dt) {
    if (gameRef.gameManager.isIntro || gameRef.gameManager.isGameOver) return;

    _velocity.x = _hAxisInput * jumpSpeed;

    final double dashHorizontalCenter = size.x / 2;

    if (position.x < dashHorizontalCenter) {
      position.x = gameRef.size.x - (dashHorizontalCenter);
    }
    if (position.x > gameRef.size.x - (dashHorizontalCenter)) {
      position.x = dashHorizontalCenter;
    }

    _velocity.y += _gravity;

    position += _velocity * dt;

    if(current == PlayerState.rocket) {
      size = Vector2(120, 170);
    } else {
      size = Vector2(79, 109);
    }

    super.update(dt);
  }

  // @override
  // bool onKeyEvent(RawKeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
  //   _hAxisInput = 0;
  //
  //   // During development, its useful to "cheat"
  //   if (keysPressed.contains(LogicalKeyboardKey.arrowUp)) {
  //     jump();
  //   }
  //
  //   return true;
  // }

  void resetDirection() {
    _hAxisInput = 0;
  }

  bool get isInvincible => current == PlayerState.rocket;

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);

    bool isCollidingVertically =
        (intersectionPoints.first.y - intersectionPoints.last.y).abs() < 5;
  }

  void jump({double? specialJumpSpeed}) {
    if(_gravity == 0) {
      _gravity = 9;
    }
    current = PlayerState.rocket;

    _velocity.y = specialJumpSpeed != null ? -specialJumpSpeed : -jumpSpeed;
    gameRef.gameManager.increaseScore();

    _removePowerupAfterTime(1000);
  }

  void _removePowerupAfterTime(int ms) {
    Future.delayed(Duration(milliseconds: ms), () {
      current = PlayerState.center;
    });
  }

  void reset() {
    _velocity = Vector2.zero();
    current = PlayerState.center;
  }

  void resetPosition() {
    position = Vector2(
      (gameRef.size.x) / 2,
      (gameRef.size.y - size.y) / 2,
    );
  }

  Future<void> _loadCharacterSprites() async {
    final left = await gameRef.loadSprite('game/rocket_1.png');
    final right = await gameRef.loadSprite('game/rocket_1.png');
    final center = await gameRef.loadSprite('game/rocket_1.png');
    final rocket = await gameRef.loadSprite('game/rocket_4.png');
    final nooglerCenter =
    await gameRef.loadSprite('game/rocket_1.png');
    final nooglerLeft =
    await gameRef.loadSprite('game/rocket_1.png');
    final nooglerRight =
    await gameRef.loadSprite('game/rocket_1.png');

    sprites = <PlayerState, Sprite>{
      PlayerState.left: left,
      PlayerState.right: right,
      PlayerState.center: center,
      PlayerState.rocket:rocket,
    };
  }
}
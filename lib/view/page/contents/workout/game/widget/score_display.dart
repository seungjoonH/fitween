import 'package:fitween/global/theme.dart';
import 'package:fitween/model/class/game/rocket_up.dart';
import 'package:fitween/view/widget/widget/text.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

class ScoreDisplay extends StatelessWidget {
  const ScoreDisplay({super.key, required this.game, this.isLight = false});

  final Game game;
  final bool isLight;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: (game as RocketUp).gameManager.score,
      builder: (context, value, child) {
        return FText('Score: $value',
          style: textTheme(context).displaySmall,
        );
      },
    );
  }
}
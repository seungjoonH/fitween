import 'package:fitween/global/global.dart';
import 'package:fitween/src/controller/validator/validator.dart';
import 'package:fitween/src/view/widget/button/button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_shake_animated/flutter_shake_animated.dart';
import 'package:get/get.dart';

class FSelectionButton<T> extends StatelessWidget {
  const FSelectionButton({
    super.key,
    required this.values,
    required this.validator,
    this.interval = 20.0,
  });

  final Iterable<T> values;
  final ButtonFieldValidatorCont<T> validator;
  final double interval;

  Color get _backgroundColor => FTheme.background;
  Color get _textColor => validator.coloring ? FTheme.error : FTheme.stroke;
  Color get _borderColor => validator.coloring ? FTheme.error : FTheme.stroke;

  Widget _buildButton(BuildContext context, T t) {
    bool selected = validator.value == t;
    Color backgroundColor = selected ? FTheme.text : _backgroundColor;
    Color textColor = selected ? _backgroundColor : _textColor;
    Color borderColor = _borderColor;

    return FButton(
      text: ((t as dynamic).locale as String).capitalize!,
      stretch: true,
      alignment: ButtonAlignment.center,
      onPressed: () => validator.setValue(t),
      backgroundColor: backgroundColor,
      textColor: textColor,
      borderColor: borderColor,
    );
  }

  List<Widget> _buildButtonChildren(BuildContext context) {
    List<Widget> buttons = values.map((t) {
      return Expanded(child: _buildButton(context, t));
    }).toList();

    List<Widget> children = [];

    for (int i = 0; i < 2 * buttons.length - 1; i++) {
      int n = i ~/ 2;
      if (i % 2 == 0) { children.add(buttons[n]); }
      else { children.add(SizedBox(width: interval)); }
    }

    return children;
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => ShakeWidget(
      autoPlay: validator.shaking,
      shakeConstant: ShakeHorizontalConstant2(),
      child: Row(children: _buildButtonChildren(context)),
    ));
  }
}

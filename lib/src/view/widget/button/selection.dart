import 'package:fitween/global/global.dart';
import 'package:fitween/src/controller/validator/validator.dart';
import 'package:fitween/src/model/enum/enum.dart';
import 'package:fitween/src/view/widget/widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_shake_animated/flutter_shake_animated.dart';
import 'package:get/get.dart';

class FSelectionButton<T> extends StatelessWidget {
  const FSelectionButton({
    super.key,
    required this.values,
    required this.validator,
    this.interval,
  });

  final Iterable<T> values;
  final ButtonFieldValidatorCont<T> validator;
  final double? interval;

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
      else { children.add(SizedBox(width: interval ?? 20.0.w)); }
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

class FTypeSelectionButton extends StatefulWidget {
  const FTypeSelectionButton({
    super.key,
    required this.values,
    this.interval,
    this.onChanged,
  });

  final Iterable<FType> values;
  final double? interval;
  final Function(FType)? onChanged;

  @override
  State<FTypeSelectionButton> createState() => _FTypeSelectionButtonState();
}

class _FTypeSelectionButtonState extends State<FTypeSelectionButton> {
  FType _selected = FType.distance;

  void changeType(FType type) => setState(() => _selected = type);
  void onChanged(FType type) {
    if (widget.onChanged == null) return;
    widget.onChanged!(type);
  }

  Widget _buildSelectionButtonWidget(BuildContext context, FType type) {
    bool isSelected = _selected == type;
    Color color = isSelected ? type.color
        : Color.alphaBlend(FTheme.backgroundAlt.withOpacity(.3), type.color);

    return ScalePressableWidget(
      onPressed: () {
        changeType(type);
        onChanged(type);
      },
      child: ClipPath(
        clipper: BookmarkClipper(),
        child: AnimatedContainer(
          duration: 200.ms,
          width: isSelected ? 60.0.w : 50.0.w,
          color: color,
          padding: EdgeInsets.fromLTRB(.0, 5.0.h, 15.0.w, 5.0.h),
          child: FText(
            type.locale,
            bold: true,
            color: FTheme.achro95,
            align: TextAlign.center,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: FType.activeValues
          .map((t) => _buildSelectionButtonWidget(context, t))
          .separateH(height: 10.0.h),
    );
  }
}


class BookmarkClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, 0);
    path.lineTo(size.width, 0);
    path.lineTo(size.width * .8, size.height * .5);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return false;
  }
}
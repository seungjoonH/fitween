import 'package:fitween/global/theme.dart';
import 'package:fitween/src/view/widget/widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FCheckButton extends StatefulWidget {
  const FCheckButton({
    super.key,
    required this.value,
    required this.onChanged,
    this.text,
    this.activeColor = FTheme.colorA,
    this.color,
  });

  final bool value;
  final Function(bool?) onChanged;
  final String? text;
  final Color activeColor;
  final Color? color;

  @override
  State<FCheckButton> createState() => _FCheckButtonState();
}

class _FCheckButtonState extends State<FCheckButton> with DarkPressable<FCheckButton> {
  @override
  void setState(VoidCallback fn) {
    if (!mounted) return;
    super.setState(fn);
  }

  @override
  Widget buildContent(BuildContext context) {
    Color colorAlt = widget.color ?? FTheme.bar;
    return Padding(
      padding: EdgeInsets.fromLTRB(.0, 2.0.h, 10.0.w, 2.0.h),
      child: Row(
        children: [
          Checkbox(
            value: widget.value,
            onChanged: widget.onChanged,
            activeColor: widget.activeColor,
          ),
          if (widget.text != null)
          FText(
            widget.text!,
            color: widget.value ? widget.activeColor : colorAlt,
          ),
        ],
      ),
    );
  }

  @override
  VoidCallback? get onPressed => () => widget.onChanged(widget.value);
}

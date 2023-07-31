import 'package:fitween/global/theme.dart';
import 'package:fitween/view/widget/button/button.dart';
import 'package:fitween/view/widget/widget/card.dart';
import 'package:fitween/view/widget/widget/text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FToggleListWidget extends StatefulWidget {
  const FToggleListWidget({
    super.key,
    required this.text,
    required this.list,
    this.emptyText,
  });

  final String text;
  final List<Widget> list;
  final String? emptyText;

  @override
  State<FToggleListWidget> createState() => _FToggleListWidgetState();
}

class _FToggleListWidgetState extends State<FToggleListWidget> {
  bool _hide = false;
  late Widget _empty;

  @override
  void initState() {
    _empty = widget.emptyText == null
        ? Container() : FCard(
      backgroundColor: Colors.transparent,
      borderColor: FTheme.grey,
      child: SizedBox(
        height: 100.0.h,
        child: Center(
          child: FText(
            widget.emptyText!,
            maxLines: 2,
            align: TextAlign.center,
            color: FTheme.grey,
          ),
        ),
      ),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FTextButton(
          stretch: true,
          alignment: MainAxisAlignment.start,
          onPressed: () => setState(() => _hide = !_hide),
          padding: EdgeInsets.symmetric(
            horizontal: 7.0.w,
            vertical: 10.0.h,
          ),
          child: Row(
            children: [
              FText(widget.text),
              SizedBox(width: 10.0.w),
              Icon(_hide
                  ? Icons.keyboard_arrow_up_outlined
                  : Icons.keyboard_arrow_down_outlined,
                size: 20.0.r,
              ),
            ],
          ),
        ),
        SizedBox(height: 20.0.h),
        if (!_hide)
        widget.list.isEmpty ? _empty : ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: widget.list.length,
          itemBuilder: (context, i) => widget.list[i],
          separatorBuilder: (context, _) => SizedBox(height: 30.0.h),
        ),
      ],
    );
  }
}
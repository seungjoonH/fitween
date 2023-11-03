import 'dart:math';

import 'package:fitween/global/global.dart';
import 'package:fitween/src/view/widget/widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FTabData {
  late int index;
  late String text;
  late Color color;
  late Widget content;

  FTabData({
    required this.index,
    required this.text,
    required this.color,
    required this.content,
  });
}

class FTabWidget extends StatefulWidget {
  const FTabWidget({
    super.key,
    required this.data,
    this.selected = false,
    this.onPressed,
  });

  final FTabData data;
  final bool selected;
  final VoidCallback? onPressed;

  @override
  State<FTabWidget> createState() => _FTabWidgetState();
}

class _FTabWidgetState extends State<FTabWidget> with ScalePressable {
  Color get _tabColor => widget.selected
      ? widget.data.color
      : ThemeCont.to.bar;

  Color get _textColor => widget.selected
      ? ThemeCont.achro95
      : ThemeCont.to.comment;

  @override
  Widget buildContent(BuildContext context) {
    return ClipPath(
      clipper: FTabClipper(),
      child: Container(
        width: 100.0.w,
        color: _tabColor,
        alignment: Alignment.center,
        child: FText(
          widget.data.text,
          style: ThemeCont.to.titleSmall,
          align: TextAlign.center,
          bold: widget.selected,
          color: _textColor,
        ),
      ),
    );
  }

  @override
  VoidCallback? get onPressed => widget.onPressed;
}


class FTabViewWidget extends StatelessWidget {
  const FTabViewWidget({
    super.key,
    required this.selectedIndex,
    required this.tabs,
    required this.contentHeight,
    required this.onChanged,
  });

  final int selectedIndex;
  final List<FTabData> tabs;
  final double contentHeight;
  final Function(int) onChanged;

  FTabData get _selectedTab => tabs[selectedIndex];

  Widget _buildHeaderWidget(BuildContext context) {
    List<FTabData> tabList = [...tabs];
    FTabData toReplace = tabs[selectedIndex];
    tabList.removeAt(selectedIndex);
    tabList.add(toReplace);

    return SizedBox(
      height: 40.0.h,
      child: Stack(
        alignment: Alignment.centerLeft,
        children: tabList.map((tab) {
          bool selected = selectedIndex == tab.index;
          double offset = selected ? 0 : 3.0.h;
          return Positioned(
            top: offset, bottom: -offset,
            left: tab.index * 85.0.w,
            child: FTabWidget(
              data: tab,
              selected: selectedIndex == tab.index,
              onPressed: () => onChanged(tab.index),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildContentWidget(BuildContext context) {
    final contentBackgroundColor = Color.alphaBlend(
      _selectedTab.color.withOpacity(.05),
      ThemeCont.to.background,
    );
    final borderRadius = BorderRadius.only(
      bottomRight: Radius.circular(20.0.r),
    );

    return Container(
      width: double.infinity,
      height: contentHeight,
      padding: EdgeInsets.all(20.0.r),
      decoration: BoxDecoration(
        borderRadius: borderRadius,
        border: Border.fromBorderSide(
          BorderSide(
            width: 2.0.r,
            color: _selectedTab.color,
            strokeAlign: BorderSide.strokeAlignOutside,
          ),
        ),
        color: contentBackgroundColor,
      ),
      child: _selectedTab.content,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildHeaderWidget(context),
        _buildContentWidget(context),
      ],
    );
  }
}

class FTabClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    final radius = 20.0.r;
    final w = size.width;
    final h = size.height;

    Point<double> tl = Point(.1 * w, 0);
    Point<double> tr = Point(.9 * w, 0);
    Point<double> bl = Point(0, h);
    Point<double> br = Point(w, h);
    double theta = atan(10 * h / w);
    double l = radius * tan(theta / 2);

    path.moveTo(bl.x, bl.y);
    path.lineTo(br.x, br.y);
    path.lineTo(tr.x + l * cos(theta), tr.y + l * sin(theta));
    path.quadraticBezierTo(tr.x, tr.y, tr.x - l, tr.y);
    path.lineTo(tl.x + l, tl.y);
    path.quadraticBezierTo(tl.x, tl.y, tl.x - l * cos(theta), tl.y + l * sin(theta));
    path.close();
    return path;
  }
  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
import 'package:fitween/src/controller/controller.dart';
import 'package:fitween/src/model/class/model.dart';
import 'package:fitween/src/view/widget/widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

abstract class ItemCellWidget extends StatefulWidget {
  const ItemCellWidget({
    super.key,
    this.item,
    this.size,
    this.onPressed,
    this.margin = false,
  });

  final Item? item;
  final double? size;
  final VoidCallback? onPressed;
  final bool margin;
}

abstract class ItemCellWidgetState<T extends ItemCellWidget> extends State<T> {
  InventoryCont get cont => InventoryCont.to;

  bool get _doesItemExist => widget.item != null;
  double get _size => widget.size ?? 80.0.r;
  double get _radius => _size * .2;

  Widget? _buildItemImageWidget(BuildContext context) {
    if (!_doesItemExist) return null;
    return SvgPicture.asset(
      widget.item!.imageUrl,
      width: 100.0.r,
      height: 100.0.r,
    );
  }

  Widget _buildEmptyCellWidget(BuildContext context) {
    Color shadowColor = (ThemeCont.to.isLightMode
        ? ThemeCont.achro70 : ThemeCont.achro5);
    Color backgroundColor = (ThemeCont.to.isLightMode
        ? ThemeCont.achro90 : ThemeCont.achro10).withOpacity(.5);

    return ClipRRect(
      borderRadius: BorderRadius.circular(_radius),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: _size,
            height: _size,
            decoration: BoxDecoration(
              color: shadowColor,
              borderRadius: BorderRadius.circular(_radius),
            ),
          ),
          Positioned(
            right: -_size * .05,
            bottom: -_size * .05,
            child: Container(
              width: _size,
              height: _size,
              decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: BorderRadius.circular(_radius * .9),
              ),
            ),
          ),
        ],
      ),
    );
  }

  int get _count;
  void _onPressed();

  Widget _buildCountWidget(BuildContext context) {
    return Obx(() => Container(
      width: 20.0.r,
      height: 20.0.r,
      margin: EdgeInsets.all(5.0.r),
      decoration: BoxDecoration(
        color: ThemeCont.to.backgroundAlt,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: ThemeCont.to.bar,
            offset: Offset(1.0.r, 1.0.r),
          ),
        ],
      ),
      alignment: Alignment.center,
      child: FText(
        '$_count',
        style: ThemeCont.to.bodySmall,
        bold: true,
      ),
    ));
  }

  Widget _buildCoveredWidget(BuildContext context) => Container();

  Widget _buildChildWidget(BuildContext context) {
    Widget? child = _buildItemImageWidget(context);
    return Stack(
      alignment: Alignment.center,
      children: [
        _buildEmptyCellWidget(context),
        if (child != null)
        Stack(
          alignment: Alignment.bottomRight,
          children: [ child, _buildCountWidget(context) ],
        ),
        Positioned.fill(
          child: _buildCoveredWidget(context),
        ),
      ],
    );
  }

  Widget _buildPressableWidget(BuildContext context) {
    return DarkPressableWidget(
      onPressed: _onPressed,
      child: _buildChildWidget(context),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: widget.margin
          ? EdgeInsets.all(_size * .05)
          : EdgeInsets.zero,
      width: _size,
      height: _size,
      child: _buildPressableWidget(context),
    );
  }
}


class ItemToEarnCellWidget extends ItemCellWidget {
  const ItemToEarnCellWidget({
    super.key,
    super.item,
    super.size,
    super.onPressed,
    super.margin,
    this.disabled,
    this.received,
    this.receivedColor,
    required this.count,
  });

  final bool? disabled;
  final bool? received;
  final Color? receivedColor;
  final int count;

  @override
  State<ItemToEarnCellWidget> createState() => _ItemToEarnCellWidgetState();
}

class _ItemToEarnCellWidgetState extends ItemCellWidgetState<ItemToEarnCellWidget> {
  @override
  int get _count => widget.count;
  bool get _disabled => widget.disabled ?? false;
  bool get _received => widget.received ?? false;
  Color get _receivedColor => widget.receivedColor ?? ThemeCont.to.outline;

  @override
  void _onPressed() {
    if (_disabled) return;
    if (widget.onPressed == null) return;
    widget.onPressed!();
  }

  @override
  Widget _buildPressableWidget(BuildContext context) {
    if (_disabled) return GrayScaleWidget(child: _buildChildWidget(context));
    if (_received) return _buildChildWidget(context);
    return PulseWidget(
      onPressed: _onPressed,
      child: _buildChildWidget(context),
    );
  }

  @override
  Widget _buildCoveredWidget(BuildContext context) {
    if (!_received) return Container();
    return Container(
      decoration: BoxDecoration(
        color: ThemeCont.to.seaByMode.withOpacity(.7),
        borderRadius: BorderRadius.circular(_radius),
        border: Border.all(
          width: 2.5,
          color: _receivedColor,
          strokeAlign: BorderSide.strokeAlignOutside,
        ),
      ),
      child: Icon(
        Icons.check,
        size: 40.0.r,
        color: _receivedColor,
      ),
    );
  }
}

class MyItemCellWidget extends ItemCellWidget {
  const MyItemCellWidget({
    super.key,
    super.item,
    super.size,
    super.margin,
    this.pressable = true,
  });

  final bool pressable;

  @override
  State<MyItemCellWidget> createState() => _MyItemCellWidgetState();
}

class _MyItemCellWidgetState extends ItemCellWidgetState<MyItemCellWidget> {

  @override
  int get _count => cont.countOfItem(widget.item!.key);

  @override
  void _onPressed() {
    if (!widget.pressable) return;
    cont.showDetailedInformationDialog(widget.item!);
  }
}

class ItemInventoryWidget extends StatelessWidget {
  const ItemInventoryWidget({
    super.key,
    required this.itemList,
    required this.rowCount,
    required this.columnCount,
    this.size,
  });

  final List<Item> itemList;
  final int rowCount;
  final int columnCount;
  final double? size;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Column(
        children: List.generate(
          rowCount, (j) => Row(
            children: List.generate(
              columnCount, (i) {
                int index = i + j * columnCount;
                Item? item;
                if (index < itemList.length) item = itemList[index];
                return MyItemCellWidget(
                  item: item,
                  size: size,
                  margin: true,
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}


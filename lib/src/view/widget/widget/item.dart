import 'package:fitween/src/controller/controller.dart';
import 'package:fitween/src/model/class/model.dart';
import 'package:fitween/src/view/widget/widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class ItemCellWidget extends StatefulWidget {
  const ItemCellWidget({
    super.key,
    this.item,
    this.size,
    this.pressable = true,
  });

  final Item? item;
  final double? size;
  final bool pressable;

  @override
  State<ItemCellWidget> createState() => _ItemCellWidgetState();
}

class _ItemCellWidgetState extends State<ItemCellWidget> {
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
    return ClipRRect(
      borderRadius: BorderRadius.circular(_radius),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: _size,
            height: _size,
            decoration: BoxDecoration(
              color: ThemeCont.to.background,
              borderRadius: BorderRadius.circular(_radius),
            ),
          ),
          Container(
            width: _size,
            height: _size,
            decoration: BoxDecoration(
              color: ThemeCont.achro5.withOpacity(.1),
              borderRadius: BorderRadius.circular(_radius),
            ),
          ),
          Positioned(
            right: -_size * .03,
            bottom: -_size * .03,
            child: Container(
              width: _size,
              height: _size,
              decoration: BoxDecoration(
                color: ThemeCont.to.background.withOpacity(.7),
                borderRadius: BorderRadius.circular(_radius * .9),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCountWidget(BuildContext context) {
    return Obx(() => Container(
      width: 20.0.r,
      height: 20.0.r,
      margin: EdgeInsets.all(7.0.r),
      decoration: BoxDecoration(
        color: ThemeCont.to.backgroundAlt,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: ThemeCont.to.bar,
            offset: Offset(2.0.r, 2.0.r),
          ),
        ],
      ),
      alignment: Alignment.center,
      child: FText(
        '${cont.countOfItem(widget.item!.key)}',
        style: ThemeCont.to.bodySmall,
        bold: true,
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    Widget? child = _buildItemImageWidget(context);

    return Container(
      margin: EdgeInsets.all(_size * .05),
      width: _size,
      height: _size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          _buildEmptyCellWidget(context),
          if (child != null)
          Stack(
            alignment: Alignment.bottomRight,
            children: [
              DarkPressableWidget(
                onPressed: () {
                  if (!_doesItemExist) return;
                  if (!widget.pressable) return;
                  cont.showDetailedInformationDialog(widget.item!);
                },
                child: child,
              ),
              _buildCountWidget(context),
            ],
          ),
        ],
      ),
    );
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
                return ItemCellWidget(
                  item: item,
                  size: size,
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}


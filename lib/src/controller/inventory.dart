import 'package:fitween/route.dart';
import 'package:fitween/src/controller/controller.dart';
import 'package:fitween/src/model/class/dao.dart';
import 'package:fitween/src/model/class/model.dart';
import 'package:fitween/src/view/widget/widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class InventoryCont extends GetxController {
  static InventoryCont get to => Get.find<InventoryCont>();

  FUser get _logged => AuthCont.logged!;

  final _inventory = <String, Item>{}.obs;
  List<Item> get inventory {
    int compare(Item a, Item b) => a.key.compareTo(b.key);
    return [..._inventory.values]..sort(compare);
  }

  final _counts = <String, int>{}.obs;
  Map<String, int> get counts => _counts;

  Future init() async => await _syncFrom();

  Future _syncFrom() async {
    await AuthCont.load(FUserLoadCont.onlyCollection());
    _inventory.assignAll(_logged.collection!.inventory);
    _counts.assignAll(_logged.collection!.counts);
  }

  Future _syncTo() async {
    _logged.collection!.syncItemsFrom(_inventory, _counts);
    await FUserCollectionDAO().saveOne(_logged.collection!);
  }

  bool _hasItem(String id) => _inventory[id] != null;
  Item _getItem(String id) => _inventory[id]!;
  int countOfItem(String id) => _counts[id] ?? 0;

  void useItem(String id) async {
    if (!_hasItem(id)) return;
    Item item = _getItem(id);
    _counts[id] = countOfItem(id) - 1;
    if (countOfItem(id) <= 0) {
      _inventory.remove(id);
      _counts.remove(id);
    }
    await item.use();
    await _syncTo();
  }

  Future awardItem(Item item, {int count = 1}) async {
    String id = item.key;
    if (_hasItem(id)) {
      _counts[id] = countOfItem(id) + count;
      return;
    }
    _counts[id] = count;
    _inventory[id] = item;
    await _syncTo();
  }

  String get useButtonText => LangCont.tr('button.use');

  void showDetailedInformationDialog(Item item) {
    showFDialog(
      title: item.title,
      content: Column(
        children: [
          ItemCellWidget(
            item: item,
            size: 100.0.r,
            pressable: false,
          ),
          SizedBox(height: 10.0.h),
          FText(
            item.description,
            color: ThemeCont.to.comment,
            style: ThemeCont.to.commentStyle,
            maxLines: 0,
          ),
        ],
      ),
      type: DialogType.bi,
      rightText: useButtonText,
      rightPressed: () => useItem(item.key),
      rightBackgroundColor: ThemeCont.colorA,
    );
  }

  String get itemAwardedTitle => LangCont.tr('item.dialog.awarded-title');
  String getItemAwardedText(int count) => LangCont.plural('item.dialog.awarded-text', count);
  String get goToInventoryButtonText => LangCont.tr('word.inventory').capitalize!;

  Map<String, Item> _dataToItems(Map<String, int> data) => {
    for (String id in data.keys) id : Item.fromId(id)
  };

  void _awardItems(Map<String, int> itemData) async {
    Map<String, Item> items = _dataToItems(itemData);
    for (String id in itemData.keys) {
      await awardItem(items[id]!, count: itemData[id]!);
    }
    HomePageCont.to.receiveGift();
    _syncTo();
  }

  void showAwardedItemInformationDialog(Map<String, int> itemData) {
    Map<String, Item> items = _dataToItems(itemData);
    _awardItems(itemData);

    showFDialog(
      title: itemAwardedTitle,
      content: Column(
        children: [
          ...itemData.keys.map((id) {
            int count = itemData[id] ?? 0;
            return FText(
              '"${items[id]!.title}" x$count',
              color: ThemeCont.to.comment,
              style: ThemeCont.to.commentStyle,
            );
          }),
          SizedBox(height: 10.0.h),
          FText(
            getItemAwardedText(itemData.length),
            style: ThemeCont.to.bodyLarge,
            maxLines: 2,
          ),
        ],
      ),
      type: DialogType.bi,
      rightText: goToInventoryButtonText,
      rightPressed: () => FRoute.toInventory(),
    );
  }
}
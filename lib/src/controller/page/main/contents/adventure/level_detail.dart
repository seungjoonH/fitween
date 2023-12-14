import 'package:fitween/global/global.dart';
import 'package:fitween/src/controller/controller.dart';
import 'package:fitween/src/model/class/amount/amount.dart';
import 'package:fitween/src/model/class/dao.dart';
import 'package:fitween/src/model/class/local.dart';
import 'package:fitween/src/model/class/model.dart';
import 'package:fitween/src/model/enum/enum.dart';
import 'package:get/get.dart';

class LevelDetailPageCont extends PageCont {
  static LevelDetailPageCont get to => Get.find<LevelDetailPageCont>();

  AdventurePageCont get adventureCont => AdventurePageCont.to;

  Level? get level => adventureCont.selectedLevel!;
  Amount get amount => adventureCont.amount;
  LevelLocal get levelLocal => LevelLocal.byType(adventureCont.activeType)!;

  bool get isCurrent => level!.isEqualTo(levelLocal.getCurrentLevel(amount));

  String get centerText {
    FType type = adventureCont.activeType;
    String currentAmountText = level!.getCurrentValue(amount).thouSep;
    String goalText = type.withUnit(level!.goal, scaling: false);
    return '$currentAmountText / $goalText';
  }

  final _compensationBadge = Rx<FBadge?>(null);
  final _compensationBadgeAvailable = false.obs;
  final _badgeCanBeEarned = false.obs;

  FBadge? get compensationBadge => _compensationBadge.value;
  bool get compensationBadgeAvailable => _compensationBadgeAvailable.value;
  bool get badgeCanBeEarned => _badgeCanBeEarned.value;

  Future _setCompensationBadgeState() async {
    FBadge badge = level!.badge;
    _compensationBadge(badge);
    _compensationBadgeAvailable(await badge.activate);
    _badgeCanBeEarned(compensationBadge!.canBeEarned);
  }

  final _items = <Item>[].obs;
  final _pointDivided = <int>[].obs;
  final _itemReceived = <bool>[].obs;

  List<Item> get items => _items;
  List<int> get pointDivided => _pointDivided;
  List<bool> get itemReceived => _itemReceived;

  void _setItems() {
    _items.assignAll([...level!.items.reversed]);
    _pointDivided.assignAll([...level!.pointDivided.reversed.cast<int>()]);
    _itemReceived.assignAll([...logged.collection!.levelReceived[level!.key] ?? []]);
  }

  void _receiveItem(int index) {
    if (index >= _itemReceived.length) {
      for (int i = _itemReceived.length; i <= index; i++) {
        _itemReceived.add(false);
      }
    }
    _itemReceived[index] = true;

  }

  bool isItemReceived(int index) => index < _itemReceived.length
      ? _itemReceived[index]
      : false;

  @override
  Future load() async {
    await _setCompensationBadgeState();
    _setItems();
  }

  @override
  String get loadKey => 'level-detail';

  void badgePressed() async {
    if (!compensationBadgeAvailable) return;
    await FBadgeCont.to.earnBadge(compensationBadge!.key);
    await load();
  }

  void itemPressedByIndex(int index) async {
    if (isItemReceived(index)) return;

    String id = items[index].key;
    int count = pointDivided[index];

    _receiveItem(index);
    await InventoryCont.to.awardItems({id: count});
    logged.collection!.syncItemReceivedFrom(level!.key, itemReceived);
    adventureCont.setLevelReceived(logged.collection!.levelReceived);
    await FUserCollectionDAO().saveOne(logged.collection!);
  }
}